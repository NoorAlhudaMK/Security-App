import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../BLoC/profile_bloc.dart';
import '../BLoC/profile_event.dart';
import '../BLoC/profile_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final colors = AppColors();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildHeader(colors),
                    const SizedBox(height: 25),
                    _buildShiftManagementCard(colors),
                    const SizedBox(height: 20),
                    _buildSettingsCard(colors, state, context),
                    const SizedBox(height: 20),
                    _buildInfoCard(colors),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.primary.withOpacity(0.2)),
          ),
          child: Center(
            child: Text("أ ش", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.primary)),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("أشرف شروفي", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.textMain)),
            Text("موظف أمن • المبنى A", style: TextStyle(color: colors.textSecondary)),
            Row(
              children: [
                Text("نشط", style: TextStyle(color: colors.accentGreen, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                CircleAvatar(backgroundColor: colors.accentGreen, radius: 4),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // بطاقة إدارة الوردية
  Widget _buildShiftManagementCard(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF4), // خلفية خضراء فاتحة جداً
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.access_time, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text("إدارة الشفت", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900])),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _shiftInfoBox("المدة", "8 س 35 د", colors),
              const SizedBox(width: 10),
              _shiftInfoBox("بداية الشفت", "8:00 ص", colors),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stop_circle, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text("إنهاء الوردية", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _shiftInfoBox(String label, String value, AppColors colors) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
            Text(value, style: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(AppColors colors, ProfileState state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("الإعدادات", style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          // التحكم بالمظهر
          _settingRow(
            colors, "المظهر", state.isDarkMode ? "الوضع الداكن" : "الوضع الفاتح", Icons.wb_sunny_outlined,
            CupertinoSwitch(
              value: state.isDarkMode,
              activeColor: colors.primary,
              onChanged: (val) => context.read<ProfileBloc>().add(ToggleTheme(val)),
            ),
          ),
          const Divider(),
          // التحكم باللغة
          _settingRow(
            colors, "اللغة", "Language", Icons.language,
            Row(
              children: [
                _langBtn("English", state.language == 'en', colors, context, 'en'),
                const SizedBox(width: 5),
                _langBtn("العربية", state.language == 'ar', colors, context, 'ar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingRow(AppColors colors, String title, String sub, IconData icon, Widget action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: colors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain)),
              Text(sub, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
            ],
          ),
          const Spacer(),
          action,
        ],
      ),
    );
  }

  Widget _langBtn(String label, bool isSelected, AppColors colors, BuildContext context, String langCode) {
    return GestureDetector(
      onTap: () => context.read<ProfileBloc>().add(ChangeLanguage(langCode)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? colors.primary : colors.inputBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? colors.primary : colors.textSecondary, fontSize: 12)),
      ),
    );
  }

  // بطاقة معلومات الموظف والإصدار
  Widget _buildInfoCard(AppColors colors) {
    return Container(
      decoration: BoxDecoration(color: colors.cardBackground, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _infoRow("رقم الموظف", "SEC-2024-047", colors),
          const Divider(height: 1),
          _infoRow("القسم", "أمن المجمع الشمالي", colors),
          const Divider(height: 1),
          _infoRow("إصدار التطبيق", "v1.0.0", colors),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textSecondary)),
          Text(value, style: TextStyle(color: colors.textMain, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}