import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/FormattedDateTime/get_arabic_date.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Repository/visitors_repository.dart';
import '../../Notification/View/notification_view.dart';
import '../../Visitors/AddNewVisitor/View/add_new_visitor.dart';
import '../../Visitors/CheckInQRScanner/BLoC/visitor_check_in_bloc.dart';
import '../../Visitors/CheckInQRScanner/View/check_in_qr_scanner_page.dart';
import '../../Visitors/CheckOutQRScanner/BLoC/visitor_check_out_bloc.dart';
import '../../Visitors/CheckOutQRScanner/View/check_out_qr_scanner_page.dart';
import '../../Visitors/ViewVisitors/BLoC/visitors_bloc.dart';
import '../../Visitors/ViewVisitors/BLoC/visitors_event.dart';
import '../../Visitors/ViewVisitors/BLoC/visitors_state.dart';
import '../BLoC/dashboard_bloc.dart';
import '../BLoC/dashboard_event.dart';
import '../BLoC/dashboard_state.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc()..add(FetchDashboardData()),
        ),
        BlocProvider(
          create: (context) =>
              VisitorsBloc(VisitorsRepository())..add(FetchVisitors()),
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: colors.scaffoldBackground,
          title: Text(
            "بــوابــة الأمــن",
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
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, dashboardState) {
              if (dashboardState is DashboardLoading ||
                  dashboardState is DashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (dashboardState is DashboardFailure) {
                return _buildErrorWidget(
                  dashboardState.errorMessage,
                  context,
                  colors,
                );
              }

              if (dashboardState is DashboardSuccess) {
                final user = dashboardState.user;
                final userName = user.name;
                final gatesValue = user.assignedGates.length.toString();
                final buildingValue = user.buildings.length.toString();

                return BlocBuilder<VisitorsBloc, VisitorsState>(
                  builder: (context, visitorsState) {
                    int visitorsCount = 0;
                    if (visitorsState is VisitorsLoaded) {
                      visitorsCount = visitorsState.visitors.length;
                    }

                    return _buildDashboardContent(
                      context,
                      colors,
                      gatesValue,
                      buildingValue,
                      visitorsCount,
                      userName,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    AppColors colors,
    String gates,
    String building,
    int visitorsCount,
    String username,
  ) {
    return Padding(
      padding: AppSpacing.symmetricH,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildWelcomeHeader(colors, username),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _statCard(
                gates,
                "البوابات",
                Icons.door_sliding_outlined,
                colors.accentRed,
                colors,
              ),
              const SizedBox(width: AppSpacing.md),
              _statCard(
                building,
                "البنايات",
                Icons.business,
                colors.visitorAvatarTeal,
                colors,
              ),
              const SizedBox(width: AppSpacing.md),
              _statCard(
                visitorsCount.toString(),
                "زوار اليوم",
                Icons.people_alt_outlined,
                colors.primary,
                colors,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionTitle("إجراءات سريعة", colors),
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewVisitorView(),
                      ),
                    );
                  },
                  child: _buildActionTile(
                    colors,
                    "تسجيل زائر جديد",
                    Icons.person_add_alt_1,
                    colors.primary,
                  ),
                ),
                GestureDetector(
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
                  child: _buildActionTile(
                    colors,
                    "سجل الدخول",
                    Icons.fact_check_outlined,
                    colors.visitorAvatarTeal,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              VisitorCheckOutBloc(VisitorsRepository()),
                          child: CheckOutQrScannerPage(gateId: 1),
                        ),
                      ),
                    );
                  },
                  child: _buildActionTile(
                    colors,
                    "سجل الخروج",
                    Icons.fact_check_outlined,
                    colors.accentRed,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(AppColors colors, String userName) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Container(
            padding: AppSpacing.allSm,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: AppRadius.mdRadius,
            ),
            child: const Icon(Icons.security, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "مساء الخير، $userName",
                    style: TextStyle(
                      fontSize: AppFontSizes.headingLarge,
                      fontWeight: FontWeight.bold,
                      color: colors.textMain,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    "👋",
                    style: TextStyle(fontSize: AppFontSizes.headingLarge),
                  ),
                ],
              ),
              Text(
                getArabicFormattedDate(),
                style: TextStyle(color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String val,
    String label,
    IconData icon,
    Color color,
    AppColors colors,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: colors.textSecondary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppIconSizes.lg),
            const SizedBox(height: AppSpacing.sm),
            Text(
              val,
              style: TextStyle(
                fontSize: AppFontSizes.headingMedium,
                fontWeight: FontWeight.bold,
                color: colors.textMain,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSizes.headingSmall,
          fontWeight: FontWeight.bold,
          color: colors.textMain,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    AppColors colors,
    String title,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.lgRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.allSm,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: AppRadius.mdRadius,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.textMain,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_outlined,
            size: AppIconSizes.xs,
            color: colors.textSecondary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(
    String message,
    BuildContext context,
    AppColors colors,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: colors.accentRed,
            size: AppIconSizes.xl,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: TextStyle(color: colors.textMain)),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () =>
                context.read<DashboardBloc>().add(FetchDashboardData()),
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}
