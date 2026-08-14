import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/Repository/visitors_repository.dart';
import 'visitor_check_out_event.dart';
import 'visitor_check_out_state.dart';

class VisitorCheckOutBloc
    extends Bloc<VisitorCheckOutEvent, VisitorCheckOutState> {
  final VisitorsRepository visitorsRepository;
  VisitorCheckOutBloc(this.visitorsRepository)
    : super(VisitorCheckOutInitialState()) {
    on<SubmitVisitorCheckOutEvent>((event, emit) async {
      emit(VisitorCheckOutLoadingState());
      try {
        final visitor = await visitorsRepository.checkOutVisitor(
          event.token,
          event.qrToken,
          event.gateId,
        );
        emit(VisitorCheckOutSuccessState(visitor));
      } catch (e) {
        emit(
          VisitorCheckOutFailureState(
            e.toString().replaceAll("Exception: ", ""),
          ),
        );
      }
    });
  }
}
