import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Models/visitor_model.dart';
import '../../../../Data/Repository/visitors_repository.dart';
import '../../../Notification/View/notification_view.dart';
import '../../AddNewVisitor/View/add_new_visitor.dart';
import '../../CheckInQRScanner/BLoC/visitor_check_in_bloc.dart';
import '../../CheckInQRScanner/View/check_in_qr_scanner_page.dart';
import '../../CheckOutQRScanner/BLoC/visitor_check_out_bloc.dart';
import '../../CheckOutQRScanner/View/check_out_qr_scanner_page.dart';
import '../../VisitorPermitView/visitor_permit_view.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorsView extends StatefulWidget {
  const VisitorsView({super.key});

  @override
  State<VisitorsView> createState() => _VisitorsViewState();
}

class _VisitorsViewState extends State<VisitorsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  final String? _selectedStatus = null;
  String? _dateFrom;
  String? _dateTo;
  final Map<String, dynamic> _extraFilters = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  void _fetchData({int page = 1, bool isPagination = false}) {
    context.read<VisitorsBloc>().add(
      FetchVisitors(
        page: page,
        filters: {
          if (_selectedStatus != null) 'status': _selectedStatus!,
          if (_dateFrom != null) 'date_from': _dateFrom!,
          if (_dateTo != null) 'date_to': _dateTo!,
          ..._extraFilters,
        },
        isPagination: isPagination,
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<VisitorsBloc>().state;
      if (state is VisitorsLoaded && state.hasMore) {
        _fetchData(page: state.currentPage + 1, isPagination: true);
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _extraFilters.remove('search');
      } else {
        _extraFilters['search'] = query;
      }
      _fetchData(page: 1);
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: (_dateFrom != null && _dateTo != null)
          ? DateTimeRange(
        start: DateTime.parse(_dateFrom!),
        end: DateTime.parse(_dateTo!),
      )
          : null,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dateFrom = "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}";
      _dateTo = "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";

      _fetchData(page: 1);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
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
        body: Padding(
          padding: AppSpacing.allSm,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewVisitorView(),
                        ),
                      );
                    },
                    child: Container(
                      padding: AppSpacing.allSm,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Icon(
                        Icons.add,
                        color: colors.primary,
                        size: AppIconSizes.md,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildSearchField(colors),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: AppSpacing.allSm,
                      decoration: BoxDecoration(
                        color: (_dateFrom != null && _dateTo != null)
                            ? colors.primary.withOpacity(0.2)
                            : colors.cardBackground,
                        borderRadius: AppRadius.smRadius,
                        border: Border.all(
                          color: (_dateFrom != null && _dateTo != null)
                              ? colors.primary
                              : colors.borderColor,
                        ),
                      ),
                      child: Icon(
                        Icons.date_range,
                        color: (_dateFrom != null && _dateTo != null)
                            ? colors.primary
                            : colors.textSecondary,
                        size: AppIconSizes.md,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: BlocBuilder<VisitorsBloc, VisitorsState>(
                  builder: (context, state) {
                    if (state is VisitorsLoading && state is! VisitorsLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is VisitorsLoaded) {
                      if (state.visitors.isEmpty) {
                        return Center(
                          child: Text(
                            "لا يوجد زوار مطابقين للبحث",
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        );
                      }
                      return _buildVisitorsList(colors, state, context);
                    } else if (state is VisitorsError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColors colors, BuildContext context) {
    return AppBar(
      backgroundColor: colors.scaffoldBackground,
      title: Text(
        "إدارة الــزوار",
        style: TextStyle(fontWeight: FontWeight.bold, color: colors.textMain),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationView()),
            );
          },
          icon: Icon(
            Icons.notifications_none_outlined,
            color: colors.textMain,
            size: AppIconSizes.md,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(AppColors colors) {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: "بحث بالاسم، الهاتف، رقم السيارة، أو QR...",
        hintStyle: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.bodySmall),
        prefixIcon: Icon(Icons.search, color: colors.textSecondary),
        filled: true,
        fillColor: colors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: AppRadius.smRadius,
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.smRadius,
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.smRadius,
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }

  Widget _buildVisitorsList(AppColors colors, VisitorsLoaded state, BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.visitors.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.visitors.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final v = state.visitors[index];
        return _visitorCard(
          visitor: v,
          initial: v.visitorName.isNotEmpty ? v.visitorName[0] : "ز",
          avatarColor: colors.visitorAvatarBlue,
          colors: colors,
          context: context,
        );
      },
    );
  }

  Widget _visitorCard({
    required VisitorModel visitor,
    required String initial,
    required Color avatarColor,
    required AppColors colors,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        children: [
          Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor.visitorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.textMain,
                        fontSize: AppFontSizes.bodyLarge,
                      ),
                    ),
                    Text(
                      "الهاتف: ${visitor.visitorPhone} · السيارة: ${visitor.carPlate ?? "-"}",
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: AppFontSizes.bodySmall,
                      ),
                    ),
                    Text(
                      "الحالة: ${visitor.status}",
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              VisitorCheckInBloc(VisitorsRepository()),
                          child: const CheckInQrScannerPage(gateId: 1),
                        ),
                      ),
                    );
                  },
                  child: _actionButton("دخول", Icons.login, colors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: GestureDetector(
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
                  child: _actionButton("خروج", Icons.logout, colors.accentRed),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitorPermitView(
                          visitorName: visitor.name ?? visitor.visitorName,
                          qrToken: visitor.qrToken,
                        ),
                      ),
                    );
                  },
                  child: _actionButton("مشاركة", Icons.share_outlined, colors.accentBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.smRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppIconSizes.xs),
          const SizedBox(width: AppSpacing.xs),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: AppFontSizes.caption,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}