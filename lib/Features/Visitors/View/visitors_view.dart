import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../Core/Colors/app_colors.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorsView extends StatelessWidget {
  const VisitorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) => VisitorsBloc(
        MobileScannerController(
          autoStart: false,
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 3,
          initialIndex: 2,
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: _buildAppBar(colors, context),
            body: TabBarView(
              children: [
                _buildQRScannerTab(colors),
                _buildAddVisitorForm(colors),
                _buildVisitorsList(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColors colors, BuildContext context) {
    return AppBar(
      backgroundColor: colors.scaffoldBackground,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة الزوار",
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * .5,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.group_outlined,
              color: colors.accentBlue,
              size: 22,
            ),
          ),
        ),
      ],
      bottom: TabBar(
        indicatorColor: colors.primary,
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: "مسح QR"),
          Tab(text: "إضافة زائر"),
          Tab(text: "القائمة (3)"),
        ],
      ),
    );
  }

  Widget _buildQRScannerTab(AppColors colors) {
    return BlocBuilder<VisitorsBloc, VisitorsState>(
      builder: (context, state) {
        final bloc = context.read<VisitorsBloc>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    state.isScanning
                        ? MobileScanner(
                            controller: bloc.cameraController,
                            onDetect: (capture) {
                              if (capture.barcodes.isNotEmpty) {
                                bloc.add(
                                  QRDetectedEvent(
                                    capture.barcodes.first.rawValue ?? "",
                                  ),
                                );
                              }
                            },
                          )
                        : _buildPlaceholderUI(),
                    _buildScannerCorners(colors),
                    if (state.isScanning)
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.flashlight_on_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => bloc.cameraController.toggleTorch(),
                        ),
                      ),
                    _buildScannerStatusText(state.isScanning),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _buildToggleButton(state, bloc, colors),
              const SizedBox(height: 25),
              _buildManualInputSection(colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddVisitorForm(AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePickerBox(colors),
          const SizedBox(height: 25),
          _buildSectionHeader("البيانات الشخصية", colors),
          _buildCustomField(
            "الاسم الكامل *",
            "أدخل اسم الزائر",
            Icons.person_outline,
            colors,
          ),
          _buildCustomField(
            "رقم الهاتف",
            "05XXXXXXXX",
            Icons.phone_android_outlined,
            colors,
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("بيانات الزيارة", colors),
          _buildCustomField(
            "رقم الشقة *",
            "مثال: 104",
            Icons.apartment_outlined,
            colors,
            helper: "الشقة التي يتوجه إليها الزائر",
          ),
          _buildCustomField(
            "رقم لوحة السيارة",
            "مثال: ABC 1234",
            Icons.directions_car_filled_outlined,
            colors,
          ),
          _buildCustomField(
            "سبب الزيارة",
            "مثال: بمناسبة العيد",
            Icons.notes_rounded,
            colors,
          ),
          const SizedBox(height: 30),
          _buildSaveButton(colors),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImagePickerBox(AppColors colors) {
    return BlocBuilder<VisitorsBloc, VisitorsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<VisitorsBloc>().add(PickIdImageEvent()),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: state.visitorIdImage != null
                  ? Colors.black12
                  : colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.visitorIdImage != null
                    ? colors.primary
                    : colors.primary.withOpacity(0.1),
                width: 2,
              ),
              image: state.visitorIdImage != null
                  ? DecorationImage(
                      image: FileImage(state.visitorIdImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: state.visitorIdImage == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: colors.primary,
                        size: 35,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تصوير هوية الزائر",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                          Text(
                            "انقر لفتح الكاميرا وتوثيق الهوية",
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      _actionButton(
                        "مطلوب",
                        Icons.camera_enhance,
                        colors.primary,
                        isSmall: true,
                      ),
                    ],
                  )
                : const Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 15,
                      child: Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildVisitorsList(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الزوار داخل المجمع حالياً",
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _visitorCard(
                  "محمد العمري",
                  "ABC 1234",
                  "104",
                  "4:10 م",
                  "م",
                  colors.visitorAvatarBlue,
                  colors,
                ),
                _visitorCard(
                  "ليلى الشهري",
                  "XYZ 5678",
                  "217",
                  "3:45 م",
                  "ل",
                  colors.visitorAvatarIndigo,
                  colors,
                ),
                _visitorCard(
                  "عبدالله الغامدي",
                  "DEF 9012",
                  "312",
                  "3:20 م",
                  "ع",
                  colors.visitorAvatarTeal,
                  colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderUI() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF1A1F2B),
      child: CustomPaint(painter: GridPainter()),
    );
  }

  Widget _buildScannerStatusText(bool isScanning) {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isScanning ? "وجّه الكاميرا نحو رمز QR" : "المسح متوقف حالياً",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    VisitorsState state,
    VisitorsBloc bloc,
    AppColors colors,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () => bloc.add(ToggleScannerEvent()),
        icon: Icon(
          state.isScanning
              ? Icons.stop_circle_outlined
              : Icons.qr_code_scanner_rounded,
          color: Colors.white,
        ),
        label: Text(
          state.isScanning ? "إيقاف الماسح" : "تشغيل الماسح",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: state.isScanning ? colors.accentRed : colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildManualInputSection(AppColors colors) {
    return Column(
      children: [
        Text(
          "أو أدخل الرمز يدوياً",
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "أدخل رمز التصريح...",
                  filled: true,
                  fillColor: colors.cardBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colors.borderColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildSearchButton(colors),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton(AppColors colors) {
    return Container(
      height: 55,
      width: 75,
      decoration: BoxDecoration(
        color: colors.borderColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          "بحث",
          style: TextStyle(
            color: colors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(AppColors colors) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "حفظ بيانات الزائر",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildScannerCorners(AppColors colors) {
    return Container(
      width: 240,
      height: 240,
      child: Stack(
        children: [
          _corner(top: 0, left: 0, isTop: true, isLeft: true),
          _corner(top: 0, right: 0, isTop: true, isLeft: false),
          _corner(bottom: 0, left: 0, isTop: false, isLeft: true),
          _corner(bottom: 0, right: 0, isTop: false, isLeft: false),
        ],
      ),
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Colors.orange, width: 4)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Colors.orange, width: 4)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Colors.orange, width: 4)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Colors.orange, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _visitorCard(
    String name,
    String carPlate,
    String apartment,
    String time,
    String initial,
    Color avatarColor,
    AppColors colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: avatarColor.withOpacity(0.1),
            child: Text(
              initial,
              style: TextStyle(
                color: avatarColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.textMain,
                  fontSize: 16,
                ),
              ),
              Text(
                "شقة $apartment · $carPlate",
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              Text(
                "دخل: $time",
                style: TextStyle(color: colors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              _actionButton("خروج", Icons.logout, colors.accentRed),
              const SizedBox(height: 8),
              _actionButton(
                "تنبيه",
                Icons.notifications_none,
                colors.accentBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String title,
    IconData icon,
    Color color, {
    bool isSmall = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 10 : 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, color: color, size: 14),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCustomField(
    String label,
    String hint,
    IconData icon,
    AppColors colors, {
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: colors.textSecondary, size: 20),
            filled: true,
            fillColor: colors.cardBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        if (helper != null)
          Text(
            helper,
            style: TextStyle(color: colors.textSecondary, fontSize: 10),
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildAppBarTitle(AppColors colors, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        "إدارة الزوار",
        style: TextStyle(
          color: colors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildAppBarAction(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(Icons.group_outlined, color: colors.accentBlue),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0;
    const double step = 30.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
