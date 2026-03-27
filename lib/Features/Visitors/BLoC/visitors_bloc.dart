import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../Core/Colors/app_colors.dart';
import 'visitors_event.dart';
import 'visitors_state.dart';

class VisitorsBloc extends Bloc<VisitorsEvent, VisitorsState> {
  final MobileScannerController cameraController;
  final ImagePicker _picker = ImagePicker();
  final colors = AppColors();

  VisitorsBloc(this.cameraController) : super(VisitorsState()) {

    on<ToggleScannerEvent>((event, emit) async {
      if (state.isScanning) {
        await cameraController.stop();
        emit(state.copyWith(isScanning: false));
      } else {
        emit(state.copyWith(isScanning: true));
        // تشغيل الكاميرا بعد تحديث الحالة لضمان وجود الويدجيت
        await cameraController.start();
      }
    });

    on<PickIdImageEvent>((event, emit) async {
      await cameraController.stop();

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
              aspectRatioPresets: [
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'قص صورة الهوية',
            ),
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
    cameraController.dispose();
    return super.close();
  }
}