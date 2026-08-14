import '../../../Data/Models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {
  final bool isPasswordVisible;

  AuthInitial({this.isPasswordVisible = true});
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}
