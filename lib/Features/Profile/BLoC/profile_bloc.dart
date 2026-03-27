import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/Profile/BLoC/profile_event.dart';
import 'package:security_app/Features/Profile/BLoC/profile_state.dart';

import '../../../Core/Colors/app_colors.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState(isDarkMode: AppColors.isDark)) {

    on<ToggleTheme>((event, emit) {

      AppColors.isDark = event.isDark;

      emit(state.copyWith(isDarkMode: event.isDark));
    });

    on<ChangeLanguage>((event, emit) {
      emit(state.copyWith(language: event.lang));
    });
  }
}