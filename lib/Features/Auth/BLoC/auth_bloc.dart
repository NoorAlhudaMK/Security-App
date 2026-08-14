import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.username, event.password);

        final fullUser = await authRepository.fetchAndCacheUserProfile(
          user.token!,
        );

        emit(AuthSuccess(fullUser));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll('Exception:', '').trim()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading()); // يمكنك إظهار حالة تحميل أثناء عملية الخروج من السيرفر
      try {
        final token = await CacheManager.getToken();
        if (token != null) {
          // تمرير token واستدعاء الدالة مع إمكانية تحديد unregisterDevice حسب الحاجة
          await authRepository.logout(token, unregisterDevice: false);
        }
        await CacheManager.clearAll();
        emit(AuthInitial());
      } catch (e) {
        // حتى لو فشل الاتصال بالسيرفر، يفضل مسح الذاكرة المؤقتة وتسجيل الخروج محلياً لضمان راحة المستخدم
        await CacheManager.clearAll();
        emit(AuthInitial());
      }
    });

    on<TogglePasswordVisibility>((event, emit) {
      if (state is AuthInitial) {
        final currentState = state as AuthInitial;
        emit(AuthInitial(isPasswordVisible: !currentState.isPasswordVisible));
      }
    });
  }
}