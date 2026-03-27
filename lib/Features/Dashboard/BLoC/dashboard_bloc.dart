import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Repository/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  // نقوم بحقن الريبوزيتوري هنا (Dependency Injection)
  final DashboardRepository repository;

  DashboardBloc(this.repository) : super(DashboardInitial()) {

    on<FetchDashboardData>((event, emit) async {
      emit(DashboardLoading()); // إظهار مؤشر التحميل

      try {
        // طلب البيانات من الـ API عبر الـ Repository
        final data = await repository.getDashboardStats();

        emit(DashboardSuccess(data)); // إرسال البيانات للواجهة
      } catch (e) {
        // في حال حدوث خطأ (انقطاع إنترنت، خطأ سيرفر، إلخ)
        emit(DashboardFailure("فشل في جلب البيانات: ${e.toString()}"));
      }
    });
  }
}