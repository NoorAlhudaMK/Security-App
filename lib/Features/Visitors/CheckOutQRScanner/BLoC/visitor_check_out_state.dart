import '../../../../Data/Models/visitor_model.dart';

abstract class VisitorCheckOutState {}

class VisitorCheckOutInitialState extends VisitorCheckOutState {}

class VisitorCheckOutLoadingState extends VisitorCheckOutState {}

class VisitorCheckOutSuccessState extends VisitorCheckOutState {
  final VisitorModel visitor;
  VisitorCheckOutSuccessState(this.visitor);
}

class VisitorCheckOutFailureState extends VisitorCheckOutState {
  final String errorMessage;
  VisitorCheckOutFailureState(this.errorMessage);
}
