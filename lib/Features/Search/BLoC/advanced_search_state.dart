import 'package:security_app/Data/Models/resident_model.dart';

class AdvancedSearchState {
  final List<ResidentModel>? allResults;      // النتائج الكاملة من الـ API
  final List<ResidentModel>? filteredResults; // النتائج التي تعرض على الشاشة
  final String query;
  final String selectedCategory;
  final List<Map<String, dynamic>> results;
  final bool isLoading;
  final String? errorMessage;

  AdvancedSearchState({
    this.allResults,
    this.filteredResults,
    this.query = '',
    this.selectedCategory = 'الكل',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AdvancedSearchState copyWith({
    List<ResidentModel>? allResults,
    List<ResidentModel>? filteredResults,
    String? query,
    String? selectedCategory,
    List<Map<String, dynamic>>? results,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdvancedSearchState(
      allResults: allResults ?? this.allResults,
      filteredResults: filteredResults ?? this.filteredResults,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}