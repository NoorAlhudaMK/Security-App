import 'package:flutter/material.dart';

import '../../../Core/Colors/app_colors.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: _buildAppBar(colors),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmergencyCard(colors),
              const SizedBox(height: 20),
              _buildIntercomCard(colors),
              const SizedBox(height: 25),
              _buildSectionTitle("التنبيهات النشطة", colors),
              _buildAlertTile(colors, "تنبيه ضجيج", "شقة 302 • منذ 5 دقائق", Colors.orange, true),
              _buildAlertTile(colors, "باب مفتوح", "بوابة B • منذ 12 دقيقة", Colors.red, false),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColors colors) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("الطوارئ والتنبيهات",
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text("Emergency & Alerts", style: TextStyle(color: colors.textSecondary, fontSize: 14)),
        ],
      ),
      actions:  [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5.0,),
          child: _buildNotificationBadge("2 تنبيه"),
        ),
      ],
    );
  }

  Widget _buildEmergencyCard(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        children: [
          Text("زر الإنذار العام", style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain, fontSize: 18)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 5),
            ),
            child: Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
          ),
          const SizedBox(height: 15),
          Text("اضغط لتفعيل الإنذار العام", style: TextStyle(color: colors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  // بطاقة الاتصال الداخلي
  Widget _buildIntercomCard(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("الاتصال الداخلي", style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "رقم الشقة...",
                    fillColor: colors.inputFill,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildCallButton(colors),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickActionChip("بوابة A", colors),
              _quickActionChip("شقة 302", colors),
              _quickActionChip("شقة 104", colors),
            ],
          )
        ],
      ),
    );
  }

  // عناصر التنبيهات (الضجيج والباب المفتوح)
  Widget _buildAlertTile(AppColors colors, String title, String sub, Color color, bool isOrange) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain)),
              Text(sub, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isOrange ? Colors.orange[800] : Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("تعامل", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          CircleAvatar(backgroundColor: Colors.red, radius: 4),
        ],
      ),
    );
  }

  Widget _buildCallButton(AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text("اتصال", style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.mic_none, color: colors.primary, size: 20),
        ],
      ),
    );
  }

  Widget _quickActionChip(String label, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(color: colors.textMain, fontSize: 12)),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain, fontSize: 16));
  }
}