import '../../../Data/Models/user_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final UserModel user;
  DashboardSuccess({required this.user});
}

class DashboardFailure extends DashboardState {
  final String errorMessage;
  DashboardFailure(this.errorMessage);
}