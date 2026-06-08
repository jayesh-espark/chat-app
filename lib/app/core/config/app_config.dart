class AppConfig {
  AppConfig._();

  /// Dynamically determines the base URL.
  /// Uses 'http://10.0.2.2:5000' for Android Emulators, and 'http://localhost:5000' otherwise.
  static String get baseUrl {
    return "https://my-backend-2e0v.onrender.com";
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
