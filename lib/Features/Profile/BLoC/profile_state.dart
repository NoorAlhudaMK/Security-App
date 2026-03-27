class ProfileState {
  final bool isDarkMode;
  final String language;

  ProfileState({
    this.isDarkMode = false,
    this.language = 'ar',
  });

  ProfileState copyWith({bool? isDarkMode, String? language}) {
    return ProfileState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
    );
  }
}