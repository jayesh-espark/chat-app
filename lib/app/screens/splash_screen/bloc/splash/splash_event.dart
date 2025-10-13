part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {}

class NavigateToHomeEvent extends SplashEvent {}

class NavigateToLoginEvent extends SplashEvent {}
