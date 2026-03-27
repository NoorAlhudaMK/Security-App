import 'package:flutter/material.dart';

import '../../../Core/Colors/app_colors.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BLoC/advanced_search_bloc.dart';
import '../BLoC/advanced_search_event.dart';
import '../BLoC/advanced_search_state.dart';

class AdvancedSearchView extends StatelessWidget {
  const AdvancedSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) => AdvancedSearchBloc(),
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
                fontSize: 18,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(colors),
              _buildCategoryFilter(colors),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 20),
                    _buildQuickSearchSection(colors),
                    const SizedBox(height: 20),
                    _buildSectionTitle("النتائج الأخيرة", colors),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: "ابحث بالاسم، رقم الشقة، أو السيارة...",
          prefixIcon: Icon(Icons.search, color: colors.iconColor),
          fillColor: colors.inputFill,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(AppColors colors) {
    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        if (state.filteredResults.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("لا توجد نتائج لـ ${state.selectedCategory}", style: TextStyle(color: colors.textSecondary)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true, // لأنها داخل ListView أخرى أو Column
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.filteredResults.length,
          itemBuilder: (context, index) {
            final item = state.filteredResults[index];
            return _buildResultItem(
              colors,
              item['title'],
              item['sub'],
              item['phone'],
              item['icon'],
              item['type'] == 'الشقق' ? colors.apartmentIconColor : Colors.blue,
              item['tag'],
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryFilter(AppColors colors) {
    List<String> categories = ["الكل", "الشقق", "السيارات", "الزوار", "اليوم"];

    return BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
      builder: (context, state) {
        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              // التحقق هل هذا العنصر هو المختار حالياً في الـ State
              bool isSelected = state.selectedCategory == categories[index];

              return GestureDetector(
                onTap: () {
                  // إرسال الحدث للـ Bloc عند الضغط
                  context.read<AdvancedSearchBloc>().add(CategoryChanged(categories[index]));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // تأثير ناعم عند الانتقال
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // إذا كان مختاراً يأخذ اللون الأساسي، وإذا لا يكون شفافاً أو بلون خفيف
                    color: isSelected ? colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.inputBorder,
                      width: 1.5,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
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

  Widget _buildQuickSearchSection(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("بحث سريع", colors),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickSearchCard(colors, "رقم شقة", Icons.apartment, colors.apartmentIconBg, colors.apartmentIconColor),
            _quickSearchCard(colors, "رقم سيارة", Icons.directions_car, colors.carIconBg, colors.carIconColor),
            _quickSearchCard(colors, "هاتف ساكن", Icons.phone, colors.phoneIconBg, colors.phoneIconColor),
          ],
        ),
      ],
    );
  }

  Widget _quickSearchCard(AppColors colors, String title, IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: colors.textMain, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildResultItem(AppColors colors, String title, String subTitle, String phone, IconData icon, Color iconColor, String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: colors.textMain, fontWeight: FontWeight.bold)),
              Text(subTitle, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
              if (phone.isNotEmpty) Text(phone, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
            ],
          ),
          const Spacer(),
          _buildBadge(tag, tag == "ساكن" ? colors.accentGreen : Colors.orange),
          const SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios_outlined, size: 14, color: colors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.bold)),
    );
  }
}
