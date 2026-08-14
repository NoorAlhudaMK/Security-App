abstract class ProfileEvent {}

class ToggleTheme extends ProfileEvent {
  final bool isDark;
  ToggleTheme(this.isDark);
}

class ChangeLanguage extends ProfileEvent {
  final String lang;
  ChangeLanguage(this.lang);
}

class FetchShiftData extends ProfileEvent {}