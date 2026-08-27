import 'package:flutter/material.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';

class AboutSecurityAppPage extends StatelessWidget {
  AboutSecurityAppPage({super.key});

  final AppColors colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.scaffoldBackground,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          title: Text(
            "عــن الــتــطــبــيــق",
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.headingSmall,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: AppIconSizes.md,
              color: colors.textMain,
            ),
          ),
        ),
        backgroundColor: AppColors().scaffoldBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        size: 50,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أيفيو - الأمن والحراسة (AIVIO)',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'نظام الرقابة، التحقق، وإدارة البوابات الذكية',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // نبذة تعريفيّة
              _buildSectionCard(
                title: 'نبذة تعريفيّة',
                content:
                'تطبيق الأمن والحراسة من أيفيو (AIVIO) هو النظام الميداني المتخصص لفرق الأمن والبوابات. يتيح مراقبة وتحقق واستجابة موثقة لإدارة دخول السكان، الزوار، والمركبات بدقة عالية مع تنبيهات لحظية وسجل كامل للأحداث.',
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16),

              // الرؤية والأهداف
              _buildSectionCard(
                title: 'رؤيتنا الأمنية',
                content:
                'مجمع أكثر أمانًا واستقراراً. نسعى لتمكين طواقم الأمن من إدارة الأبواب والحركات اليومية بكفاءة عالية، عبر أتمتة إجراءات التحقق والحد من الثغرات التشغيلية.',
                icon: Icons.visibility_outlined,
              ),
              const SizedBox(height: 16),

              // أبرز المميزات الأمنية
              const Text(
                'أبرز مهام ومميزات التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                title: 'التحكم بالبوابات',
                description:
                'فتح وإغلاق البوابات تلقائياً أو يدويّاً مع توثيق كامل لكل عملية.',
                icon: Icons.door_sliding_outlined,
              ),
              _buildFeatureItem(
                title: 'إدارة الزوار والمركبات',
                description:
                'التحقق من تصاريح الزيارة الرقمية عبر رمز الاستجابة السريعة (QR) وتسجيل الدخول والخروج.',
                icon: Icons.people_alt_outlined,
              ),
              _buildFeatureItem(
                title: 'التنبيهات الأمنية الفورية',
                description:
                'إشعارات لحظية لمحاولات الدخول غير المصرّح بها أو الحالات غير الاعتيادية.',
                icon: Icons.notification_important_outlined,
              ),
              _buildFeatureItem(
                title: 'سجل الأحداث والتدقيق',
                description:
                'سجل رقمي شامل وقابل للبحث للتدقيق في جميع الحركات والتحركات الأمنية.',
                icon: Icons.history_edu_rounded,
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'الإصدار 1.0.0 • 2026',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}