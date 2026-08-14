import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Repository/visitors_repository.dart';
import '../../../../Data/Repository/advanced_search_repository.dart';
import 'add_visitors_event.dart';
import 'add_visitors_state.dart';

class AddVisitorBloc extends Bloc<AddVisitorEvent, AddVisitorState> {
  final VisitorsRepository repository;
  final AdvancedSearchRepository searchRepository;

  AddVisitorBloc({
    required this.repository,
    required this.searchRepository,
  }) : super(AddVisitorState()) {
    on<NextStepEvent>((event, emit) {
      if (state.currentStep < 3) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 1) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SearchResidentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingResidents: true));
      try {
        final residents = await searchRepository.searchResidents(
          token: event.token,
          search: event.query,
        );
        emit(state.copyWith(residentsList: residents, isLoadingResidents: false));
      } catch (e) {
        emit(state.copyWith(isLoadingResidents: false, errorMessage: "خطأ في البحث عن السكان"));
      }
    });

    on<SelectResidentEvent>((event, emit) {
      emit(state.copyWith(
        selectedResidentId: event.residentId,
        selectedResidentName: event.residentName,
        selectedUnitId: event.unitId,
      ));
    });

    on<CreateVisitor>((event, emit) async {
      emit(
        state.copyWith(
          isGenerating: true,
          lastCreatedVisitor: null,
          errorMessage: null,
        ),
      );

      try {
        if (state.selectedResidentId == null || state.selectedUnitId == null) {
          emit(
            state.copyWith(
              isGenerating: false,
              errorMessage: "الرجاء اختيار الساكن المستهدف من القائمة",
            ),
          );
          return;
        }

        final token = await CacheManager.getToken();
        if (token == null) {
          emit(
            state.copyWith(
              isGenerating: false,
              errorMessage: "التوكن غير صالح، يرجى إعادة تسجيل الدخول",
            ),
          );
          return;
        }

        final visitorData = {
          "visitor_name": event.name,
          "visitor_phone": event.phone,
          "unit_id": state.selectedUnitId,
          "valid_from": event.validFrom,
          "valid_to": event.validTo,
          "has_car": event.hasCar,
          "car_plate": event.carPlate,
          "resident_id": state.selectedResidentId,
          "national_id": event.nationalId,
          "companions_count": event.companionsCount,
          "reason": event.reason,
        };

        final createdVisitor = await repository.addVisitor(token, visitorData);

        emit(
          state.copyWith(
            isGenerating: false,
            currentStep: 1,
            lastCreatedVisitor: createdVisitor,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isGenerating: false, errorMessage: e.toString()));
      }
    });

    on<UpdateHasCar>((event, emit) => emit(state.copyWith(hasCar: event.value)));
    on<UpdateIsTimeSelected>((event, emit) => emit(state.copyWith(isTimeSelected: event.isSelected)));
    on<UpdateDate>((event, emit) => emit(state.copyWith(selectedDate: event.date, isTimeSelected: false)));
  }
}