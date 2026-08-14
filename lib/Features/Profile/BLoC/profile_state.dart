import '../../../Data/Models/shift_model.dart';

class ProfileState {
  final bool isDarkMode;
  final String language;
  final bool isLoading;
  final List<ShiftModel> shifts;
  final String? errorMessage;

  ProfileState({
    this.isDarkMode = false,
    this.language = 'ar',
    this.isLoading = false,
    this.shifts = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isDarkMode,
    String? language,
    bool? isLoading,
    List<ShiftModel>? shifts,
    String? errorMessage,
  }) {
    return ProfileState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      shifts: shifts ?? this.shifts,
      errorMessage: errorMessage,
    );
  }
}