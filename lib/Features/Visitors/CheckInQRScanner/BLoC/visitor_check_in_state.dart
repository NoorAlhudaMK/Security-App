import '../../../../Data/Models/visitor_model.dart';

abstract class VisitorCheckInState {}

class VisitorCheckInInitialState extends VisitorCheckInState {}

class VisitorCheckInLoadingState extends VisitorCheckInState {}

class VisitorCheckInSuccessState extends VisitorCheckInState {
  final VisitorModel visitor;
  VisitorCheckInSuccessState(this.visitor);
}

class VisitorCheckInFailureState extends VisitorCheckInState {
  final String errorMessage;
  VisitorCheckInFailureState(this.errorMessage);
}