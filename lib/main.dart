import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:security_app/Core/CacheManager/cache_manager.dart';
import 'package:security_app/Data/Models/user_model.dart';
import 'package:security_app/Data/Repository/auth_repository.dart';
import 'package:security_app/Data/Repository/shift_repository.dart';
import 'package:security_app/Data/Repository/visitors_repository.dart';

import 'Core/Colors/app_colors.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Dashboard/BLoC/dashboard_bloc.dart';
import 'Features/Introduction/View/introduction_view.dart';
import 'Features/MainPage/BLoC/home_bloc.dart';
import 'Features/MainPage/View/main_home_page.dart';
import 'Features/Profile/BLoC/profile_bloc.dart';
import 'Features/Visitors/ViewVisitors/BLoC/visitors_bloc.dart';
import 'Features/Visitors/ViewVisitors/BLoC/visitors_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await requestNotificationPermission();

  try {
    await FirebaseMessaging.instance.subscribeToTopic('security_guards');
  } catch (e) {
    if (kDebugMode) {
      print("⚠️ خطأ أثناء الاشتراك في التوبيك: $e");
    }
  }

  String? token = await CacheManager.getToken();
  bool isValidSession = false;

  if (token != null) {
    try {
      await AuthRepository().fetchAndCacheUserProfile(token);
      bool hasAccess = await AuthRepository().checkUserAccess(token);
      isValidSession = hasAccess;
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في التحقق من الجلسة عند التشغيل: $e");
      }
      await CacheManager.clearAll();
      isValidSession = false;
    }
  }

  initializeDateFormatting('ar').then((_) {
    runApp(MyApp(isLoggedIn: token != null));
    FlutterNativeSplash.remove();
  });
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? fcmToken = await messaging.getToken();
    if (kDebugMode) {
      print("✅ تم منح صلاحية الإشعارات بنجاح.");
      print("🔔 FCM Token: $fcmToken");
    }
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    if (kDebugMode) print("✅ تم منح صلاحية مؤقتة للإشعارات.");
  } else {
    if (kDebugMode) print("⚠️ تم رفض صلاحية الإشعارات.");
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(shiftRepository: ShiftRepository()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider<VisitorsBloc>(
          create: (context) => VisitorsBloc(VisitorsRepository())..add(FetchVisitors()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Security App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors().textMain),
            bodyMedium: TextStyle(color: AppColors().textMain),
            titleLarge: TextStyle(
              color: AppColors().textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors().textMain),
            bodyMedium: TextStyle(color: AppColors().textMain),
            titleLarge: TextStyle(
              color: AppColors().textMain,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: isLoggedIn
            ? FutureBuilder<UserModel>(
          future: CacheManager.getUserModel(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return LoginView();
            }
            return MainHomePage(user: snapshot.data!);
          },
        )
            : SecurityIntroScreen(),
      ),
    );
  }
}