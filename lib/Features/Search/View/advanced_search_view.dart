import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Repository/advanced_search_repository.dart';
import '../../../../Data/Models/resident_model.dart';
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
            elevation: 0,
            centerTitle: false,
            title: Text(
              "البحث المتقدم",
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.headingSmall,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(colors),
              _buildCategoryFilter(colors),
              Expanded(
                child: ListView(
                  padding: AppSpacing.symmetricH,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    _buildSectionTitle("النتائج", colors),
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
                borderRadius: AppRadius.xlRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(AppColors colors) {
    final List<String> categories = ["الكل", "الشقق", "السيارات", "أفراد العائلة", "جهات الطوارئ"];

    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        final String currentCategory = categories.contains(state.selectedCategory)
            ? state.selectedCategory
            : "الكل";

        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryName = categories[index];
              bool isSelected = currentCategory == categoryName;

              return GestureDetector(
                onTap: () {
                  context.read<AdvancedSearchBloc>().add(CategoryChanged(categoryName));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : Colors.transparent,
                    borderRadius: AppRadius.circularRadius,
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.inputBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : colors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
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

            String mainTitle = resident.name;
            String subTitle = resident.unitName;
            IconData icon = Icons.person;
            Color iconColor = colors.primary;

            if (state.selectedCategory == 'الشقق') {
              mainTitle = resident.unitName;
              subTitle = resident.name;
              icon = Icons.apartment;
              iconColor = colors.apartmentIconColor;
            } else if (state.selectedCategory == 'السيارات') {
              mainTitle = resident.carPlate;
              subTitle = resident.name;
              icon = Icons.directions_car;
              iconColor = Colors.orange;
            } else if (state.selectedCategory == 'أفراد العائلة') {
              mainTitle = resident.familyMembers.isNotEmpty
                  ? (resident.familyMembers[0]['name'] ?? 'بدون اسم')
                  : resident.name;
              subTitle = "عائلة: ${resident.name}";
              icon = Icons.group;
              iconColor = Colors.purple;
            } else if (state.selectedCategory == 'جهات الطوارئ') {
              mainTitle = resident.emergencyContactName ?? 'لا توجد جهة اتصال';
              subTitle = "${resident.name} (${resident.emergencyContactPhone ?? ''})";
              icon = Icons.emergency;
              iconColor = Colors.red;
            }

            return _buildResultItem(
              colors,
              mainTitle,
              subTitle,
              resident.phone,
              icon,
              iconColor,
              resident.tag,
            );
          },
        );
      },
    );
  }

  Widget _buildResultItem(
      AppColors colors,
      String title,
      String subTitle,
      String phone,
      IconData icon,
      Color iconColor,
      String tag,
      ) {
    return Container(
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
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildBadge(tag, tag == "مالك" ? Colors.orange : Colors.green),
        ],
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