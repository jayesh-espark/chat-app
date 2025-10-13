part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class SignupRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final DateTime dateOfBirth;
  final String avatar;

  SignupRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.avatar,
  });
}

class AvatarSelectionEvent extends AuthEvent {}

class AvatarSelectedEvent extends AuthEvent {
  String avatar = "";
  AvatarSelectedEvent(this.avatar);
}

class ChangeAvatarCategoryEvent extends AuthEvent {
  String avatarCat = "";
  ChangeAvatarCategoryEvent(this.avatarCat);
}

class BirthDateSelectionEvent extends AuthEvent {}

class BirthDateSelectedEvent extends AuthEvent {
  DateTime dateTime;
  BirthDateSelectedEvent({required this.dateTime});
}
