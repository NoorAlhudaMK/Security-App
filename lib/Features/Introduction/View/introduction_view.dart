import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:security_app/Core/Colors/app_colors.dart';

import '../../Auth/View/login_view.dart';

class SecurityIntroScreen extends StatelessWidget {
  SecurityIntroScreen({super.key});

  AppColors colors = AppColors();
  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          pages: [
            PageViewModel(
              title: "تطبيق الأمن والحراسة (AIVIO)",
              body: "النظام الميداني المتخصص لفرق الأمن والبوابات؛ منصة رقمية متكاملة تضمن الرقابة الدقيقة والتحقق الفوري للحركات داخل المجمع.",
              image: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: 70,
                    color: colors.primary,
                  ),
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                bodyTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            // الصفحة الثانية: التحكم بالبوابات وإدارة الحركات
            PageViewModel(
              title: "التحكم بالبوابات وإدارة الحركات",
              bodyWidget: Column(
                children: const [
                  Text(
                    "• إدارة البوابات: فتح وإغلاق بوابات المجمع بمرونة وبأوامر مباشرة.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• التدقيق الميداني: تسجيل وتوثيق حركات الدخول والخروج بدقة متناهية.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
              image: Center(
                child: Icon(
                  Icons.door_sliding_outlined,
                  size: 80,
                  color: colors.primary,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            // الصفحة الثالثة: إدارة الزوار والتحقق الذكي
            PageViewModel(
              title: "التحقق السريع من الزوار والمركبات",
              body: "فحص ومسح تصاريح الزيارة الرقمية عبر رمز الاستجابة السريعة (QR) أو تقنيات التحقق المعتمدة لضمان أمان المجمع.",
              image: Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 80,
                  color: colors.primary,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                bodyTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            // الصفحة الرابعة: التنبيهات وسجل الأحداث
            PageViewModel(
              title: "التنبيهات الفورية وسجل التدقيق",
              bodyWidget: Column(
                children: const [
                  Text(
                    "• التنبيهات الأمنية: إشعارات لحظية بالحالات الاستثنائية والطارئة.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• سجل الأحداث: قاعدة بيانات مرنة للاستعلام عن كافة الحركات السابقة بسهولة.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
              image: Center(
                child: Icon(
                  Icons.history_edu_rounded,
                  size: 80,
                  color: colors.primary,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),
          ],
          showSkipButton: true,
          showNextButton: true,
          skip: const Text(
            "تخطي",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          next: Icon(Icons.arrow_forward_ios, color: colors.primary, size: 18),
          done: Text(
            "ابدأ الان",
            style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
          ),
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(22.0, 10.0),
            activeColor: colors.primary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 4.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}