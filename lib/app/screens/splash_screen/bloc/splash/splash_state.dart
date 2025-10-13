part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class NavigateToHomeState extends SplashState {}

final class NavigateToLoginState extends SplashState {}
