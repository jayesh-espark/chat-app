part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthAction extends AuthState {
  bool isBirthDate;
  AuthAction(this.isBirthDate);
}

final class LoadingState extends AuthState {}

class LoginErrorOccurredState extends AuthState {
  final String message;
  LoginErrorOccurredState({required this.message});
}

class LoginSuccessState extends AuthState {
  final String message;
  LoginSuccessState({required this.message});
}

class SignUpErrorOccurredState extends AuthState {
  final String message;
  SignUpErrorOccurredState({required this.message});
}

class SignUpSuccessState extends AuthState {
  final String message;
  SignUpSuccessState({required this.message});
}

class BirthDateSelectState extends AuthState {
  final DateTime birthDate;
  BirthDateSelectState({required this.birthDate});
}

class ImageSelectionState extends AuthState {
  final String avatar;
  ImageSelectionState({required this.avatar});
}

class ChangeAvatarCategoryState extends AuthState {
  final String avatarCat;
  ChangeAvatarCategoryState({required this.avatarCat});
}
