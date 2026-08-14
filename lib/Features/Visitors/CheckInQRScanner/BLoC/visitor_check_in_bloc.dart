import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Data/Repository/visitors_repository.dart';
import 'visitor_check_in_event.dart';
import 'visitor_check_in_state.dart';

class VisitorCheckInBloc extends Bloc<VisitorCheckInEvent, VisitorCheckInState> {
  final VisitorsRepository visitorsRepository;

  VisitorCheckInBloc(this.visitorsRepository) : super(VisitorCheckInInitialState()) {
    on<SubmitVisitorCheckInEvent>((event, emit) async {
      emit(VisitorCheckInLoadingState());
      try {
        final visitor = await visitorsRepository.checkInVisitor(
          event.token,
          event.qrToken,
          event.gateId,
        );
        emit(VisitorCheckInSuccessState(visitor));
      } catch (e) {
        emit(VisitorCheckInFailureState(e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}