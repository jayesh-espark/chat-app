part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class LoadUserProfileState extends ProfileState {}

final class LogoutUserState extends ProfileState {}
