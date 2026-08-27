import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/profile_bloc.dart';
import '../BLoC/profile_event.dart';
import '../BLoC/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchShiftData());
  }

  String _calculateShiftDuration(String startStr, String endStr) {
    try {
      final start = DateTime.parse(startStr);
      final end = DateTime.parse(endStr);
      final duration = end.difference(start);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return "$hours س ${minutes > 0 ? '$minutes د' : ''}";
    } catch (e) {
      return "غير متوفرة";
    }
  }

  String _formatTime(String datetimeStr) {
    try {
      final dt = DateTime.parse(datetimeStr);
      int hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'م' : 'ص';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return "$hour:$minute $period";
    } catch (e) {
      return datetimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final colors = AppColors();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: colors.scaffoldBackground,
              title: Text(
                "الــمــلــف الــشــخــصــي",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.textMain,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              automaticallyImplyActions: false,
              leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationView()),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: colors.textMain,
                    size: AppIconSizes.md,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: AppSpacing.allMd,
                child: Column(
                  children: [
                    _buildHeader(colors, state),
                    const SizedBox(height: AppSpacing.xl),
                    _buildShiftManagementCard(colors, state),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSettingsCard(colors, state, context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildInfoCard(colors, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors, ProfileState state) {
    final shift = state.shifts.isNotEmpty ? state.shifts.first : null;
    final staff = shift?.gate?.securityStaff.isNotEmpty == true
        ? shift!.gate!.securityStaff.first
        : null;

    final guardName = staff?.name ?? "";
    final buildingName = shift?.gate?.buildingName ?? "";
    final buildingCode = shift?.gate?.buildingCode ?? "";
    final initials = guardName.length >= 2 ? guardName.substring(0, 2) : "أ ش";
    final isActive = staff?.active ?? true;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: colors.primary.withOpacity(0.2)),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: AppFontSizes.displaySmall,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guardName,
              style: TextStyle(
                fontSize: AppFontSizes.headingLarge,
                fontWeight: FontWeight.bold,
                color: colors.textMain,
              ),
            ),
            Text(
              "$buildingName ($buildingCode)",
              style: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.bodySmall),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isActive ? colors.accentGreen : Colors.red,
                  radius: 4,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  isActive ? "نشط" : "غير نشط",
                  style: TextStyle(
                    color: isActive ? colors.accentGreen : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),


              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShiftManagementCard(AppColors colors, ProfileState state) {
    final shift = state.shifts.isNotEmpty ? state.shifts.first : null;
    final gate = shift?.gate;

    final startTime = shift != null && shift.startDatetime.isNotEmpty
        ? _formatTime(shift.startDatetime)
        : "---";

    final duration = shift != null && shift.startDatetime.isNotEmpty && shift.endDatetime.isNotEmpty
        ? _calculateShiftDuration(shift.startDatetime, shift.endDatetime)
        : "---";

    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF4),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: colors.profileCardBorderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.access_time, color: colors.profileCardIconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  "إدارة الشفت: ${shift?.name ?? ''} (${gate?.name ?? 'بوابة'}) - [${gate?.code ?? ''}]",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.profileCardTextColor,
                    fontSize: AppFontSizes.bodySmall,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _shiftInfoBox("مدة الشفت", duration, colors),
              const SizedBox(width: AppSpacing.sm),
              _shiftInfoBox("بداية الشفت", startTime, colors),
              const SizedBox(width: AppSpacing.sm),
              _shiftInfoBox("حالة الشفت", shift?.state.toUpperCase() ?? 'OPEN', colors),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(15),
          //     border: Border.all(color: Colors.red.withOpacity(0.2)),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.stop_circle, color: Colors.red, size: 20),
          //       const SizedBox(width: 8),
          //       Text("إنهاء الوردية", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _shiftInfoBox(String label, String value, AppColors colors) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.caption),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: TextStyle(
                color: colors.profileInfoCardTextColor,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.bodySmall,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      AppColors colors,
      ProfileState state,
      BuildContext context,
      ) {
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الإعدادات",
            style: TextStyle(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _settingRow(
            colors,
            "المظهر",
            state.isDarkMode ? "الوضع الداكن" : "الوضع الفاتح",
            Icons.wb_sunny_outlined,
            CupertinoSwitch(
              value: state.isDarkMode,
              activeColor: colors.primary,
              onChanged: (val) =>
                  context.read<ProfileBloc>().add(ToggleTheme(val)),
            ),
          ),
          // التحكم باللغة
          // _settingRow(
          // colors, "اللغة", "Language", Icons.language,
          // Row(
          // children: [
          // _langBtn("English", state.language == 'en', colors, context, 'en'),
          // const SizedBox(width: 5),
          // _langBtn("العربية", state.language == 'ar', colors, context, 'ar'),
          // ],
          // ),
          // ),
        ],
      ),
    );
  }

  Widget _settingRow(
      AppColors colors,
      String title,
      String sub,
      IconData icon,
      Widget action,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.allSm,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.05),
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(icon, color: colors.primary, size: AppIconSizes.md),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.textMain,
                ),
              ),
              Text(
                sub,
                style: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.bodySmall),
              ),
            ],
          ),
          const Spacer(),
          action,
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppColors colors, ProfileState state) {
    final shift = state.shifts.isNotEmpty ? state.shifts.first : null;
    final gate = shift?.gate;

    final staff = gate?.securityStaff.isNotEmpty == true ? gate!.securityStaff.first : null;
    final staffId = staff != null ? "SEC-${staff.id}" : "SEC-2024-047";
    final buildingName = gate?.buildingName ?? "";
    final buildingCode = gate?.buildingCode ?? "";
    final gateName = gate?.name ?? "";
    final gateCode = gate?.code ?? "";
    final shiftDate = shift?.date ?? "";

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        children: [
          // _infoRow("رقم الموظف", staffId, colors),
          // const Divider(height: 1),
          _infoRow("المبنى", "$buildingName ($buildingCode)", colors),
          const Divider(height: 0.4),
          _infoRow("البوابة", "$gateName ($gateCode)", colors),
          // const Divider(height: 1),
          // _infoRow("تاريخ الشفت", shiftDate, colors),
          const Divider(height: 0.4),
          _infoRow("إصدار التطبيق", "v1.0.0", colors),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, AppColors colors) {
    return Padding(
      padding: AppSpacing.allMd,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}