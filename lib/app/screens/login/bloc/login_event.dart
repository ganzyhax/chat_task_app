part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginLogin extends LoginEvent {
  final String username;
  final String password;
  LoginLogin({required this.password, required this.username});
}

final class LoginLoad extends LoginEvent {}
