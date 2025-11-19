import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if the device supports biometrics
  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      log(" canCheck: $canCheck, isDeviceSupported: $isDeviceSupported");
      return canCheck && isDeviceSupported;
    } on PlatformException catch (e) {
      print("Error checking biometrics: ${e.message}");
      return false;
    }
  }

  /// Get the list of available biometric types
  Future<List<BiometricType>> getAvailableBiometricTypes() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print("Error getting biometric types: ${e.message}");
      return [];
    }
  }

  /// Authenticate the user with biometrics
  Future<bool> authenticate({
    String localizedReason = 'Confirm your biometric',
    bool useBiometricOnly = false,
    bool stickyAuth = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: useBiometricOnly,
          stickyAuth: stickyAuth,
          useErrorDialogs: false,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == "NotEnrolled") {
        // ActionPopupFunction.showSecuritySettingsPopup();
      }
      return false;
    }
  }

  /// Check if the device supports biometric hardware
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print("Error checking device support: ${e.message}");
      return false;
    }
  }
}
