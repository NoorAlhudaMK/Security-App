import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Core/Repository/dashboard_repository.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Dashboard/BLoC/dashboard_bloc.dart';
import 'Features/Dashboard/BLoC/dashboard_event.dart';
import 'Features/MainPage/BLoC/home_bloc.dart';
import 'Features/MainPage/View/main_home_page.dart';
import 'Features/Profile/BLoC/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkUserToken();
  await FirebaseMessaging.instance.subscribeToTopic('security_guards');
  runApp(const MyApp());
}

void checkUserToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();

    if (token != null) {
      print("✅ تم إنشاء معرف الجهاز بنجاح:");
      print("FCM Token: $token");
    } else {
      print("❌ فشل الحصول على المعرف.");
    }
  } else {
    print("⚠️ المستخدم رفض إعطاء صلاحية الإشعارات.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),

        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),

        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),


        BlocProvider<DashboardBloc>(
          create: (context) =>
              DashboardBloc(DashboardRepository())..add(FetchDashboardData()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Security App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const MainHomePage(),
      ),
    );
  }
}
