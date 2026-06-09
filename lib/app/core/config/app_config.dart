class AppConfig {
  AppConfig._();

  /// Dynamically determines the base URL.
  /// Uses 'http://10.0.2.2:5000' for Android Emulators, and 'http://localhost:5000' otherwise.
  static String get baseUrl {
    return "http://192.168.42.40:5000";
    // if (kIsWeb) {
    //   return "http://localhost:5000";
    // }
    // try {
    //   if (Platform.isAndroid) {
    //     return "http://10.0.2.2:5000";
    //   }
    // } catch (_) {}
    // return "http://localhost:5000";
  }

  static String get apiBaseUrl => "$baseUrl/api/v1";
}
