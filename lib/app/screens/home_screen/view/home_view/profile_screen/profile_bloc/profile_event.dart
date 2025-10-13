part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class LoadUserProfileEvent extends ProfileEvent {}

class LogoutUserEvent extends ProfileEvent {}
