import 'package:flutter/material.dart';

class AdvancedSearchState {
  final String query;
  final String selectedCategory;
  final List<Map<String, dynamic>> allResults; // كل البيانات
  final List<Map<String, dynamic>> filteredResults; // البيانات المفلترة حالياً

  AdvancedSearchState({
    this.query = '',
    this.selectedCategory = 'الكل',
    this.allResults = const [
      {'title': 'شقة 104', 'sub': 'أحمد الزهراني', 'phone': '0501234567', 'type': 'الشقق', 'icon': Icons.apartment, 'tag': 'ساكن'},
      {'title': 'ABC 1234', 'sub': 'محمد العمري', 'phone': '', 'type': 'السيارات', 'icon': Icons.directions_car, 'tag': 'زائر'},
      {'title': 'شقة 217', 'sub': 'سارة المطيري', 'phone': '0557891234', 'type': 'الشقق', 'icon': Icons.apartment, 'tag': 'ساكن'},
      {'title': 'XYZ 5678', 'sub': 'ليلى الشهري', 'phone': '', 'type': 'السيارات', 'icon': Icons.directions_car, 'tag': 'ساكن'},
      {'title': 'زيارة عائلية', 'sub': 'فهد المساعد', 'phone': '0561112223', 'type': 'الزوار', 'icon': Icons.person_add, 'tag': 'زائر'},
    ],
    this.filteredResults = const [], // ستبدأ فارغة ثم تملأ في الـ Bloc
  });

  AdvancedSearchState copyWith({
    String? query,
    String? selectedCategory,
    List<Map<String, dynamic>>? filteredResults,
  }) {
    return AdvancedSearchState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allResults: this.allResults,
      filteredResults: filteredResults ?? this.filteredResults,
    );
  }
}