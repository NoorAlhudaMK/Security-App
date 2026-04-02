import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/FormattedDateTime/get_arabic_date.dart';
import '../BLoC/dashboard_bloc.dart';
import '../BLoC/dashboard_event.dart';
import '../BLoC/dashboard_state.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return SafeArea(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardSuccess) {
            return _buildDashboardContent(context, colors, state.data);
          }

          if (state is DashboardFailure) {
            return _buildErrorWidget(state.errorMessage, context, colors);
          }

          return const Center(child: Text("ابدأ بتحميل البيانات"));
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, AppColors colors, Map<String, dynamic> apiData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [


          _buildTopBar(colors),
          const SizedBox(height: 20),
          _buildWelcomeHeader(colors),
          const SizedBox(height: 20),
          Row(
            children: [
              _statCard(apiData['visitors']?.toString() ?? "0", "زوار اليوم", Icons.people_alt_outlined, colors.primary, colors),
              const SizedBox(width: 12),
              _statCard(apiData['apartments']?.toString() ?? "0", "الشقق", Icons.apartment, Colors.teal, colors),
              const SizedBox(width: 12),
              _statCard(apiData['alerts']?.toString() ?? "0", "تنبيهات", Icons.warning_amber_rounded, colors.accentRed, colors),
            ],
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionTitle("إجراءات سريعة", colors),
                const SizedBox(height: 15),
                _buildActionTile(colors, "تسجيل زائر جديد", Icons.person_add_alt_1, colors.primary),
                _buildActionTile(colors, "فتح بوابة الطوارئ", Icons.door_front_door_outlined, colors.accentRed),
                _buildActionTile(colors, "سجل الدخول/الخروج", Icons.fact_check_outlined, Colors.teal),
                const SizedBox(height: 25),
                _buildRecentActivityHeader(colors),
                _buildActivityList(colors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.security, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("بوابة الأمن", style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain)),
                  Text("شفت الصباح", style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                ],
              ),


            ],
          ),
          Icon(Icons.notifications_none_outlined, color: colors.textMain, size: 28),

        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(AppColors colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("مساء الخير، أشرف", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.textMain)),
              const SizedBox(width: 8),
              const Text("👋", style: TextStyle(fontSize: 22)),
            ],
          ),
          Text(getArabicFormattedDate(), style: TextStyle(color: colors.textSecondary)),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color, AppColors colors) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.textSecondary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textMain)),
            Text(label, style: TextStyle(fontSize: 10, color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textMain)),
    );
  }

  Widget _buildActionTile(AppColors colors, String title, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: colors.textMain)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_outlined, size: 14, color: colors.textSecondary.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("آخر النشاطات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textMain)),
        TextButton(onPressed: () {}, child: Text("عرض الكل", style: TextStyle(color: colors.primary))),
      ],
    );
  }

  Widget _buildActivityList(AppColors colors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        bool isEntry = index == 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isEntry ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(isEntry ? Icons.login : Icons.logout, color: isEntry ? Colors.green : Colors.red, size: 18),
          ),
          title: Text(isEntry ? "أحمد الزهراني" : "سارة المطيري", style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain), textAlign: TextAlign.right),
          subtitle: Text(isEntry ? "شقة 104 - زائر" : "شقة 205 - ساكن", style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
          trailing: Text(isEntry ? "4:30 م" : "4:15 م", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message, BuildContext context, AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: colors.accentRed, size: 60),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: colors.textMain)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<DashboardBloc>().add(FetchDashboardData()),
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}