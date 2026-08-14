import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/GridPainter/grid_painter.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Models/visitor_model.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorsView extends StatefulWidget {
  VisitorsView({super.key});

  @override
  State<VisitorsView> createState() => _VisitorsViewState();
}

class _VisitorsViewState extends State<VisitorsView>
    with SingleTickerProviderStateMixin {
  TextEditingController qrCodeText = TextEditingController(
    text: "wo2Bq19KKfkXppOd-Zg1C7AtZTP56QNt6wMrtAUDeis",
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController unitIdController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: _buildAppBar(colors, context),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildQRScannerTab(colors),
            _buildAddVisitorForm(context, colors),
            BlocBuilder<VisitorsBloc, VisitorsState>(
              builder: (context, state) {
                if (state is VisitorsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VisitorsLoaded) {
                  return _buildVisitorsList(colors, state.visitors);
                } else if (state is VisitorsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ],
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
                fontSize: AppFontSizes.headingMedium,
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
            padding: AppSpacing.allSm,
            decoration: BoxDecoration(
              color: colors.accentBlue.withOpacity(0.1),
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              Icons.group_outlined,
              color: colors.accentBlue,
              size: AppIconSizes.md,
            ),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: "مسح QR"),
          Tab(text: "إضافة زائر"),
          Tab(text: "القائمة"),
        ],
      ),
    );
  }

  Widget _buildQRScannerTab(AppColors colors) {
    return BlocBuilder<VisitorsBloc, VisitorsState>(
      builder: (context, state) {
        final bloc = context.read<VisitorsBloc>();
        return SingleChildScrollView(
          padding: AppSpacing.allLg,
          child: Column(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2B),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    state.isScanning
                        ? MobileScanner(
                      controller: bloc.cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String? code = barcodes.first.rawValue;
                          if (code != null) {
                            context.read<VisitorsBloc>().add(
                              ConfirmVisitEvent(code, 1),
                            );
                            _tabController.animateTo(2);
                          }
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
                          icon: Icon(
                            Icons.flashlight_on_rounded,
                            color: Colors.white,
                            size: AppIconSizes.md,
                          ),
                          onPressed: () => bloc.cameraController!.toggleTorch(),
                        ),
                      ),
                    _buildScannerStatusText(state.isScanning),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildToggleButton(state, bloc, colors),
              const SizedBox(height: AppSpacing.lg),
              _buildManualInputSection(colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddVisitorForm(BuildContext context, AppColors colors) {
    return SingleChildScrollView(
      padding: AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("البيانات الشخصية", colors),
          _buildCustomField(
            "الاسم الكامل *",
            "أدخل اسم الزائر",
            Icons.person_outline,
            colors,
            controller: nameController,
          ),
          _buildCustomField(
            "رقم الهاتف",
            "07XXXXXXXXX",
            Icons.phone_android_outlined,
            colors,
            controller: phoneController,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSectionHeader("بيانات الزيارة", colors),
          _buildCustomField(
            "رقم الشقة *",
            "مثال: 1",
            Icons.apartment_outlined,
            colors,
            controller: unitIdController,
          ),
          _buildCustomField(
            "رقم لوحة السيارة",
            "مثال: ABC123",
            Icons.directions_car_filled_outlined,
            colors,
            controller: plateController,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSaveButton(context, colors),
          const SizedBox(height: AppSpacing.md),
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
            padding: AppSpacing.allMd,
            decoration: BoxDecoration(
              color: state.visitorIdImage != null
                  ? Colors.black12
                  : colors.primary.withOpacity(0.05),
              borderRadius: AppRadius.mdRadius,
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
                  size: AppIconSizes.xl,
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
                        fontSize: AppFontSizes.caption,
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

  Widget _buildVisitorsList(AppColors colors, List<VisitorModel> visitors) {
    return Padding(
      padding: AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الزوار داخل المجمع حالياً (${visitors.length})",
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.bodySmall,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView.builder(
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                final v = visitors[index];
                return _visitorCard(
                  v.id,
                  1,
                  v.visitorName,
                  v.carPlate ?? "-",
                  v.unitName,
                  v.checkedInAt ?? "--:--",
                  v.visitorName.isNotEmpty ? v.visitorName[0] : "ز",
                  colors.visitorAvatarBlue,
                  colors,
                  context,
                );
              },
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
          borderRadius: AppRadius.circularRadius,
        ),
        child: Text(
          isScanning ? "وجّه الكاميرا نحو رمز QR" : "المسح متوقف حالياً",
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.bodySmall,
          ),
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
          size: AppIconSizes.md,
        ),
        label: Text(
          state.isScanning ? "إيقاف الماسح" : "تشغيل الماسح",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.bodyLarge,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: state.isScanning ? colors.accentRed : colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgRadius,
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
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: AppFontSizes.bodySmall,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: qrCodeText,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "أدخل رمز التصريح...",
                  filled: true,
                  fillColor: colors.cardBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.lgRadius,
                    borderSide: BorderSide(color: colors.borderColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildSearchButton(colors),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton(AppColors colors) {
    return GestureDetector(
      onTap: () {
        final String manualCode = qrCodeText.text;
        if (manualCode.isNotEmpty) {
          context.read<VisitorsBloc>().add(ConfirmVisitEvent(manualCode, 1));
          _tabController.animateTo(2);
        }
      },
      child: Container(
        height: 55,
        width: 75,
        decoration: BoxDecoration(
          color: colors.borderColor,
          borderRadius: AppRadius.lgRadius,
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
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AppColors colors) {
    return BlocBuilder<VisitorsBloc, VisitorsState>(
      builder: (context, state) {
        final isLoading = state is VisitorsLoading;

        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
              final data = {
                "resident_id": 1,
                "visitor_name": nameController.text,
                "visitor_phone": phoneController.text,
                "unit_id": int.tryParse(unitIdController.text) ?? 1,
                "valid_to": "2026-07-20 23:59:00",
                "has_car": plateController.text.isNotEmpty,
                "car_plate": plateController.text,
              };
              context.read<VisitorsBloc>().add(AddVisitorEvent(data));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.lgRadius,
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              "حفظ بيانات الزائر",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.bodyLarge,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerCorners(AppColors colors) {
    return SizedBox(
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
      String id,
      int gate,
      String name,
      String carPlate,
      String apartment,
      String time,
      String initial,
      Color avatarColor,
      AppColors colors,
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.mdRadius,
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
                fontSize: AppFontSizes.headingSmall,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.textMain,
                  fontSize: AppFontSizes.bodyLarge,
                ),
              ),
              Text(
                "شقة $apartment · $carPlate",
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppFontSizes.bodySmall,
                ),
              ),
              Text(
                "دخل: $time",
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  print("The deleted : $id , $gate");
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("تأكيد الخروج"),
                      content: const Text(
                        "هل أنت متأكد من تسجيل خروج هذا الزائر؟",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("إلغاء"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.read<VisitorsBloc>().add(
                              CheckoutVisitorEvent(int.parse(id), gate),
                            );
                          },
                          child: const Text("تأكيد"),
                        ),
                      ],
                    ),
                  );
                },
                child: _actionButton("خروج", Icons.logout, colors.accentRed),
              ),
              const SizedBox(height: AppSpacing.xs),
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
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.smRadius,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: AppFontSizes.caption,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, color: color, size: AppIconSizes.xs),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: AppFontSizes.bodySmall,
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
        required TextEditingController controller,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textMain,
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: colors.textSecondary,
              size: AppIconSizes.md,
            ),
            filled: true,
            fillColor: colors.cardBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.lgRadius,
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.lgRadius,
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        if (helper != null)
          Text(
            helper,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.caption,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
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
          fontSize: AppFontSizes.headingMedium,
        ),
      ),
    );
  }

  Widget _buildAppBarAction(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(
        Icons.group_outlined,
        color: colors.accentBlue,
        size: AppIconSizes.md,
      ),
    );
  }
}