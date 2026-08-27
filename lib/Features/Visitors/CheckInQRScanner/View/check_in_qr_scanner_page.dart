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
import '../BLoC/visitor_check_in_bloc.dart';
import '../BLoC/visitor_check_in_event.dart';
import '../BLoC/visitor_check_in_state.dart';

class CheckInQrScannerPage extends StatefulWidget {
  final int gateId;

  const CheckInQrScannerPage({Key? key, required this.gateId}) : super(key: key);

  @override
  State<CheckInQrScannerPage> createState() => _CheckInQrScannerPageState();
}

class _CheckInQrScannerPageState extends State<CheckInQrScannerPage> {
  final AppColors appColors = AppColors();
  final TextEditingController _manualCodeController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController(autoStart: false);
  final ValueNotifier<bool> isScanningActive = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _scannerController.dispose();
    isScanningActive.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: appColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "تــســجــيــل دخــول زائــر",
            style: TextStyle(
              color: appColors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.headingSmall,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppIconSizes.md,
              color: appColors.textMain,
            ),
          ),
        ),
        body: BlocConsumer<VisitorCheckInBloc, VisitorCheckInState>(
          listener: (context, state) {
            if (state is VisitorCheckInSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم تسجيل الدخول بنجاح: ${state.visitor.visitorName}"),
                  backgroundColor: Colors.green,
                ),
              );
              _scannerController.stop();
              Navigator.pop(context);
            } else if (state is VisitorCheckInFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: appColors.accentRed,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is VisitorCheckInLoadingState;

            return Padding(
              padding: AppSpacing.allMd,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E242B),
                        borderRadius: AppRadius.lgRadius,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: isScanningActive,
                            builder: (context, active, child) {
                              if (!active) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: const Color(0xFF1E242B),
                                  child: CustomPaint(painter: GridPainter()),
                                );
                              }
                              return MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) async {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if (barcode.rawValue != null && !isLoading) {
                                      final String code = barcode.rawValue!;
                                      _scannerController.stop();
                                      isScanningActive.value = false;

                                      final token = await CacheManager.getToken();
                                      if (token != null && context.mounted) {
                                        BlocProvider.of<VisitorCheckInBloc>(context).add(
                                          SubmitVisitorCheckInEvent(
                                            token: token,
                                            qrToken: code,
                                            gateId: widget.gateId,
                                          ),
                                        );
                                      }
                                      break;
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          _buildScannerCorners(),
                          Positioned(
                            bottom: 16,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: isScanningActive,
                              builder: (context, active, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: AppRadius.circularRadius,
                                  ),
                                  child: Text(
                                    active ? "جاري البحث عن رمز..." : "المسح متوقف حالياً",
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isScanningActive,
                        builder: (context, active, child) {
                          return ElevatedButton.icon(
                            onPressed: () {
                              isScanningActive.value = !isScanningActive.value;
                              if (isScanningActive.value) {
                                _scannerController.start();
                              } else {
                                _scannerController.stop();
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner),
                            label: Text(active ? "إيقاف الماسح" : "تشغيل الماسح"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text("أو أدخل الرمز يدوياً", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _manualCodeController,
                            decoration: InputDecoration(
                              hintText: "أدخل الرمز هنا...",
                              filled: true,
                              fillColor: appColors.cardBackground,
                              border: OutlineInputBorder(borderRadius: AppRadius.mdRadius, borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              final code = _manualCodeController.text.trim();
                              if (code.isNotEmpty) {
                                final token = await CacheManager.getToken();
                                if (token != null && context.mounted) {
                                  BlocProvider.of<VisitorCheckInBloc>(context).add(
                                    SubmitVisitorCheckInEvent(
                                      token: token,
                                      qrToken: code,
                                      gateId: widget.gateId,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.inputBorder,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                            ),
                            child: isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text("دخول"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScannerCorners() {
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

  Widget _corner({double? top, double? bottom, double? left, double? right, required bool isTop, required bool isLeft}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: Colors.orange, width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: Colors.orange, width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: Colors.orange, width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: Colors.orange, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}