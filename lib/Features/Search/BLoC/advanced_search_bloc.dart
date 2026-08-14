import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Repository/advanced_search_repository.dart';
import '../../../Data/Models/resident_model.dart';
import 'advanced_search_event.dart';
import 'advanced_search_state.dart';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  final AdvancedSearchRepository repository;

  AdvancedSearchBloc({required this.repository}) : super( AdvancedSearchState()) {
    on<InitializeSearch>(_onInitializeSearch);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<CategoryChanged>(_onCategoryChanged);

    add(InitializeSearch());
  }

  Future<void> _onInitializeSearch(
      InitializeSearch event, Emitter<AdvancedSearchState> emit) async {
    await _performSearch(emit, query: state.query, category: state.selectedCategory);
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<AdvancedSearchState> emit) async {
    emit(state.copyWith(query: event.query));
    await _performSearch(emit, query: event.query, category: state.selectedCategory);
  }

  Future<void> _onCategoryChanged(
      CategoryChanged event, Emitter<AdvancedSearchState> emit
      ) async {
    emit(state.copyWith(selectedCategory: event.category));

    List<ResidentModel> filtered = [];
    final all = state.allResults ?? [];

    if (event.category == "الكل") {
      filtered = all;
    } else {
      filtered = all.where((resident) {
        if (event.category == "السيارات") {
          return resident.vehicles.isNotEmpty;
        }
        else if (event.category == "أفراد العائلة") {
          return resident.familyMembers.isNotEmpty;
        }
        else if (event.category == "جهات الطوارئ") {
          return resident.emergencyContactName != null &&
              resident.emergencyContactName!.isNotEmpty;
        }
        else if (event.category == "الشقق") {
          return true;
        }
        return false;
      }).toList();
    }

    emit(state.copyWith(filteredResults: filtered));
  }

  Future<void> _performSearch(
      Emitter<AdvancedSearchState> emit, {
        required String query,
        String? category,
      }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final String token = await CacheManager.getToken() ?? "";
      final List<ResidentModel> results = await repository.searchResidents(
        token: token,
        search: query,
      );

      List<ResidentModel> filtered = results;
      if (category != null && category != "الكل") {
        filtered = results.where((resident) {
          if (category == "السيارات") {
            return resident.vehicles.isNotEmpty;
          } else if (category == "أفراد العائلة") {
            return resident.familyMembers.isNotEmpty;
          } else if (category == "جهات الطوارئ") {
            return resident.emergencyContactName != null &&
                resident.emergencyContactName!.isNotEmpty;
          } else if (category == "الشقق") {
            return true;
          }
          return false;
        }).toList();
      }

      emit(state.copyWith(
        isLoading: false,
        allResults: results,
        filteredResults: filtered,
        query: query,
      ));

    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: "حدث خطأ أثناء البحث: ${e.toString()}"
      ));
    }
  }
}