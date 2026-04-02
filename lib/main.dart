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
  runApp(const MyApp());
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
