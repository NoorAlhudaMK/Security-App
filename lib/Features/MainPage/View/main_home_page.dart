import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/Visitors/CheckOutQRScanner/View/check_out_qr_scanner_page.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Models/user_model.dart';
import '../../../Data/Repository/auth_repository.dart';
import '../../../Data/Repository/visitors_repository.dart';
import '../../Auth/Bloc/auth_bloc.dart';
import '../../Auth/Bloc/auth_event.dart';
import '../../Auth/Bloc/auth_state.dart';
import '../../Auth/View/login_view.dart';
import '../../Dashboard/View/dashboard_view.dart';
import '../../Profile/View/profile_view.dart';
import '../../Search/View/advanced_search_view.dart';
import '../../Visitors/CheckInQRScanner/BLoC/visitor_check_in_bloc.dart';
import '../../Visitors/CheckInQRScanner/View/check_in_qr_scanner_page.dart';
import '../../Visitors/ViewVisitors/View/visitors_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';
import '../../Visitors/CheckOutQRScanner/BLoC/visitor_check_out_bloc.dart';

class MainHomePage extends StatelessWidget {
  final UserModel user;

  MainHomePage({super.key, required this.user});

  final List<Widget> _pages = [
    const DashboardView(),
    VisitorsView(),
    const AdvancedSearchView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: colors.scaffoldBackground,
                  drawer: _buildDrawer(context, colors, user, state.currentIndex),
                  body: _pages[state.currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: state.currentIndex,
                    onTap: (index) {
                      context.read<HomeBloc>().add(ChangeTabEvent(index));
                    },
                    backgroundColor: colors.cardBackground,
                    selectedItemColor: colors.primary,
                    unselectedItemColor: colors.textSecondary,
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: "الرئيسية",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.people_outline_rounded),
                        label: "الزوار",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: "البحث",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings_outlined),
                        label: "الملف",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(
      BuildContext context, AppColors colors, UserModel user, int currentIndex) {
    return Drawer(
      backgroundColor: colors.scaffoldBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            accountName: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.login),
          ),

          // روابط صفحات التطبيق الرئيسية
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: currentIndex == 0 ? colors.primary : colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "الرئيسية",
              style: TextStyle(
                color: currentIndex == 0 ? colors.primary : colors.textSecondary,
                fontWeight: currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(ChangeTabEvent(0));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_outline_rounded,
              color: currentIndex == 1 ? colors.primary : colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "الزوار",
              style: TextStyle(
                color: currentIndex == 1 ? colors.primary : colors.textSecondary,
                fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(ChangeTabEvent(1));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: currentIndex == 2 ? colors.primary : colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "البحث المتقدم",
              style: TextStyle(
                color: currentIndex == 2 ? colors.primary : colors.textSecondary,
                fontWeight: currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(ChangeTabEvent(2));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "الملف الشخصي",
              style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.normal,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(ChangeTabEvent(3));
            },
          ),

          Divider(color: colors.textSecondary,),

          // صفحات أو عناصر إضافية (مثل سجل النشاطات)
          ListTile(
            leading: Icon(
              Icons.input,
              color: colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "سجل دخول زائر",
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        VisitorCheckInBloc(VisitorsRepository()),
                    child: CheckInQrScannerPage(
                      gateId: 1,

                      /// TODO: استبدل الرقم برقم البوابة الفعلي
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.output,
              color: colors.textSecondary,
              size: AppIconSizes.md,
            ),
            title: Text(
              "سجل خروج زائر",
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        VisitorCheckOutBloc(VisitorsRepository()),
                    child: CheckOutQrScannerPage(
                      gateId: 1,

                      /// TODO: استبدل الرقم برقم البوابة الفعلي
                    ),
                  ),
                ),
              );
            },
          ),

          Divider(color: colors.textSecondary,),

          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: AppIconSizes.md,
            ),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(
                color: Colors.red,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: const Text("تسجيل الخروج"),
        content: const Text("هل أنت متأكد من رغبتك في تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text("خروج", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}