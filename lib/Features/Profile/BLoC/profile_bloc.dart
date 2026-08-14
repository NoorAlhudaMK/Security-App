import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/Profile/BLoC/profile_event.dart';
import 'package:security_app/Features/Profile/BLoC/profile_state.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Repository/shift_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ShiftRepository shiftRepository;

  ProfileBloc({required this.shiftRepository}) : super(ProfileState(isDarkMode: AppColors.isDark)) {
    on<ToggleTheme>((event, emit) {
      AppColors.isDark = event.isDark;
      emit(state.copyWith(isDarkMode: event.isDark));
    });

    on<ChangeLanguage>((event, emit) {
      emit(state.copyWith(language: event.lang));
    });

    on<FetchShiftData>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final shifts = await shiftRepository.getShifts();
        emit(state.copyWith(isLoading: false, shifts: shifts));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}