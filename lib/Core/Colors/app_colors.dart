import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  Color get scaffoldBackground => isDark
      ? const Color(0xFF0D1117)
      : const Color(0xFFF8FAFC);

  Color get cardBackground => isDark
      ? const Color(0xFF0F172A)
      : Colors.white;

  Color get primary => isDark
      ? const Color(0xFFEA8E1B)
      : const Color(0xFF1D4ED8);

  Color get textMain => isDark
      ? Colors.white
      : const Color(0xFF0F172A);

  Color get textSecondary => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B);

  Color get inputFill => isDark
      ? const Color(0x33000000)
      : const Color(0xFFF1F5F9);

  Color get inputBorder => isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFE2E8F0);

  Color get iconColor => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  Color get iconBlue => const Color(0xFFE0E7FF);
  Color get iconRed => const Color(0xFFFEE2E2);
  Color get iconGreen => const Color(0xFFDCFCE7);

  Color get accentRed => const Color(0xFFEF4444);

  Color get accentGreen => const Color(0xFF55E6C1);
  Color get accentBlue => const Color(0xFF74b9ff);

  Color get visitorAvatarBlue => const Color(0xFF0984e3);
  Color get visitorAvatarIndigo => const Color(0xFF6c5ce7);
  Color get visitorAvatarTeal => const Color(0xFF00cec9);

  Color get borderColor => isDark ? Colors.white10 : const Color(0x0D000000);

  Color get apartmentIconBg => const Color(0xFFE6FFFA);
  Color get carIconBg => const Color(0xFFFFF7ED);
  Color get phoneIconBg => const Color(0xFFEEF2FF);

  Color get apartmentIconColor => const Color(0xFF38B2AC);
  Color get carIconColor => const Color(0xFFF6AD55);
  Color get phoneIconColor => const Color(0xFF6366F1);

  Color get profileCardBorderColor => const Color(0x334C3B27);
  Color get profileCardIconColor => const Color(0xFF388E3C);
  Color get profileCardTextColor => const Color(0xFF1B5E20);
  Color get profileInfoCardTextColor => const Color(0xFF00796B);
}