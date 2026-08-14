import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Data/Repository/visitors_repository.dart';
import 'visitors_event.dart';
import 'visitors_state.dart';

class VisitorsBloc extends Bloc<VisitorsEvent, VisitorsState> {
  final VisitorsRepository repository;
  final MobileScannerController? cameraController;
  final ImagePicker _picker = ImagePicker();
  final colors = AppColors();

  VisitorsBloc(this.repository, {this.cameraController})
      : super(const VisitorsInitial()) {
    on<FetchVisitors>((event, emit) async {
      final currentScanning = state.isScanning;
      emit(const VisitorsLoading());

      try {
        final token = await CacheManager.getToken();
        final visitors = await repository.getVisitors(token ?? "");

        emit(VisitorsLoaded(visitors, isScanning: currentScanning));
      } catch (e) {
        emit(VisitorsError(e.toString()));
      }
    });

    on<AddVisitorEvent>((event, emit) async {
      emit(const VisitorsLoading());
      try {
        final token = await CacheManager.getToken();
        if (token == null) throw Exception("جلسة منتهية");

        await repository.addVisitor(token, event.visitorData);

        add(FetchVisitors());
      } catch (e) {
        emit(VisitorsError("خطأ: ${e.toString()}"));
      }
    });

    on<CheckoutVisitorEvent>((event, emit) async {
      emit(VisitorsLoading());
      try {
        final token = await CacheManager.getToken();
        await repository.checkoutVisitor(token!, event.visitId, event.gateId);

        add(FetchVisitors());
      } catch (e) {
        emit(VisitorsError("حدث خطأ أثناء تسجيل خروج الزائر"));
      }
    });

    on<ConfirmVisitEvent>((event, emit) async {
      emit(VisitorsLoading());
      try {
        final token = await CacheManager.getToken();
        await repository.confirmVisit(token!, event.qrToken, event.gateId);

        add(FetchVisitors());
      } catch (e) {
        emit(VisitorsError("حدث خطأ أثناء تأكيد الزيارة"));
      }
    });

    on<ToggleScannerEvent>((event, emit) async {
      if (cameraController == null) return; // تأكد من وجوده أولاً

      if (state.isScanning) {
        await cameraController!.stop();
        emit(state.copyWith(isScanning: false));
      } else {
        emit(state.copyWith(isScanning: true));
        await cameraController!.start();
      }
    });

    on<PickIdImageEvent>((event, emit) async {
      await cameraController?.stop(); // استخدام ?. بدلاً من . المباشرة
      emit(state.copyWith(isScanning: false));

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 85,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'قص صورة الهوية',
              toolbarColor: colors.textMain,
              toolbarWidgetColor: colors.primary,
              initAspectRatio: CropAspectRatioPreset.ratio16x9,
              lockAspectRatio: false,
              aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
            ),
            IOSUiSettings(title: 'قص صورة الهوية'),
          ],
        );

        if (croppedFile != null) {
          emit(state.copyWith(visitorIdImage: File(croppedFile.path)));
        }
      }
    });

    on<QRDetectedEvent>((event, emit) {
      emit(state.copyWith(lastScannedCode: event.code));
    });
  }

  @override
  Future<void> close() {
    cameraController?.dispose();
    return super.close();
  }
}
