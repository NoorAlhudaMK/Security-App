abstract class AdvancedSearchEvent {}

class InitializeSearch extends AdvancedSearchEvent {}

class SearchQueryChanged extends AdvancedSearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class CategoryChanged extends AdvancedSearchEvent {
  final String category;
  CategoryChanged(this.category);
}