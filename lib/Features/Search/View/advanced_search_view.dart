import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/Search/View/residential_profile.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Repository/advanced_search_repository.dart';
import '../../../../Data/Models/resident_model.dart';
import '../../Notification/View/notification_view.dart';
import '../BLoC/advanced_search_bloc.dart';
import '../BLoC/advanced_search_event.dart';
import '../BLoC/advanced_search_state.dart';

class AdvancedSearchView extends StatelessWidget {
  const AdvancedSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) => AdvancedSearchBloc(
        repository: AdvancedSearchRepository(),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: colors.scaffoldBackground,
            title: Text(
              "الــبــحــث الــمــتــقــدم",
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
          body: Column(
            children: [
              _buildSearchBar(colors),
              Expanded(
                child: ListView(
                  padding: AppSpacing.symmetricH,
                  children: [
                   // const SizedBox(height: AppSpacing.sm),
                   // _buildSectionTitle("النتائج", colors),
                    _buildResultsList(colors),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppColors colors) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: AppSpacing.allMd,
          child: TextField(
            onChanged: (value) {
              context.read<AdvancedSearchBloc>().add(SearchQueryChanged(value));
            },
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: "ابحث بالاسم، رقم الشقة، أو البناية...",
              prefixIcon: Icon(Icons.search, color: colors.iconColor),
              fillColor: colors.inputFill,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: AppRadius.mdRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsList(AppColors colors) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(state.errorMessage!, style: TextStyle(color: colors.accentRed)),
            ),
          );
        }

        final List<ResidentModel> displayList = (state.filteredResults as List<ResidentModel>?) ?? [];

        if (displayList.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text("لا توجد نتائج مطابقة", style: TextStyle(color: colors.textSecondary)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final ResidentModel resident = displayList[index];

            // اعتماد البيانات الأساسية الخاصة بالسكان بشكل مباشر
            String mainTitle = resident.name;
            String subTitle = resident.unitName;
            IconData icon = Icons.person;
            Color iconColor = colors.primary;

            return _buildResultItem(
              context: context,
              colors: colors,
              resident: resident,
              title: mainTitle,
              subTitle: subTitle,
              phone: resident.phone,
              icon: icon,
              iconColor: iconColor,
              tag: resident.tag,
            );
          },
        );
      },
    );
  }

  Widget _buildResultItem({
    required BuildContext context,
    required AppColors colors,
    required ResidentModel resident,
    required String title,
    required String subTitle,
    required String phone,
    required IconData icon,
    required Color iconColor,
    required String tag,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResidentProfilePage(resident: resident),
          ),
        );
      },
      borderRadius: AppRadius.mdRadius,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.sm),
        padding: AppSpacing.allSm,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.allSm,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: AppRadius.smRadius,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    phone,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildBadge(tag, tag == "مالك" ? Colors.orange : Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.circularRadius,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: AppFontSizes.caption,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          color: colors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}