import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/Visitors/View/visitors_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../Alerts/View/alerts_view.dart';
import '../../Dashboard/View/dashboard_view.dart';
import '../../Profile/View/profile_view.dart';
import '../../Search/View/advanced_search_view.dart';
import '../BLoC/home_bloc.dart';
import '../BLoC/home_event.dart';
import '../BLoC/home_state.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  final List<Widget> _pages = const [
    DashboardView(),
    VisitorsView(),
    AdvancedSearchView(),
    AlertsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
            
              drawer: _buildDrawer(context, colors),
            
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
                  BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), label: "الزوار"),
                  BottomNavigationBarItem(icon: Icon(Icons.search), label: "البحث"),
                  BottomNavigationBarItem(icon: Icon(Icons.warning_amber), label: "التنبيهات"),
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
    );
  }

  Widget _buildDrawer(BuildContext context, AppColors colors) {
    return Drawer(
      backgroundColor: colors.scaffoldBackground,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            accountName: const Text(
              "أشرف",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("ashraf@security.iq"),
          ),
          ListTile(
            leading: Icon(Icons.history, color: colors.textMain),
            title: Text(
              "سجل النشاطات",
              style: TextStyle(color: colors.textMain),
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // منطق تسجيل الخروج هنا
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
