abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final Map<String, dynamic> data;
  DashboardSuccess(this.data);
}

class DashboardFailure extends DashboardState {
  final String errorMessage;
  DashboardFailure(this.errorMessage);
}