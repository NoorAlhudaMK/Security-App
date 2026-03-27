import 'package:flutter_bloc/flutter_bloc.dart';

import 'advanced_search_event.dart';
import 'advanced_search_state.dart';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  AdvancedSearchBloc() : super(AdvancedSearchState()) {

    on<InitializeSearch>((event, emit) {
      emit(state.copyWith(filteredResults: state.allResults));
    });

    on<CategoryChanged>((event, emit) {
      List<Map<String, dynamic>> results;
      if (event.category == 'الكل') {
        results = state.allResults;
      } else {
        results = state.allResults.where((item) => item['type'] == event.category).toList();
      }
      emit(state.copyWith(
        selectedCategory: event.category,
        filteredResults: results,
      ));
    });
  }
}