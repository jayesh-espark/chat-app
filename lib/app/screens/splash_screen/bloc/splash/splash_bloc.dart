import 'dart:async';
import 'dart:developer';
import 'package:chating_app/app/app_services/biomatric_services.dart';
import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<NavigateToHomeEvent>(_handleNavigateToHome);
    on<NavigateToLoginEvent>(_handleNavigateToLogin);
  }

  FutureOr<void> _handleNavigateToLogin(
    NavigateToLoginEvent event,
    Emitter<SplashState> emit,
  ) {
    emit(NavigateToLoginState());
  }

  Future<void> _handleNavigateToHome(
    NavigateToHomeEvent event,
    Emitter<SplashState> emit,
  ) async {
    var userAuthToken = await LocalStorageApp().getAuthToken();
    if (userAuthToken.isEmpty) {
      emit(NavigateToLoginState());
      return;
    } else {
      if (await checkAppLocked()) {
        var didAuthenticate = await BiometricAuthService().authenticate();
        if (didAuthenticate) {
          emit(NavigateToHomeState());
          return;
        }
      } else {
        emit(NavigateToHomeState());
      }
    }
  }

  Future<bool> checkAppLocked() async {
    bool isAppLock = await LocalStorageApp().isAppLocked();
    bool isAvailable = await BiometricAuthService().isBiometricAvailable();
    return isAvailable && isAppLock;
  }
}
