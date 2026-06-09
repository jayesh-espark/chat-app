import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../core/storage/local_storage.dart';

class FcmService {
  FcmService._();
  static final FcmService _instance = FcmService._();
  factory FcmService() => _instance;

  FirebaseMessaging? get _messaging {
    try {
      return FirebaseMessaging.instance;
    } catch (_) {
      return null;
    }
  }

  /// Initialize FCM, request permissions, and set up listeners.
  /// Wrapped in try-catch to allow app execution even if Firebase config is missing.
  Future<void> initialize() async {
    try {
      // Initialize Firebase Core
      await Firebase.initializeApp();
      log("Firebase initialized successfully");

      // Request notification permissions
      await requestPermissions();

      // Get initial token and register it
      await registerToken();

      // Listen for token refreshes
      _messaging?.onTokenRefresh.listen((newToken) async {
        log("FCM Token refreshed: $newToken");
        await LocalStorageApp().saveFcmToken(newToken);
        await sendTokenToBackend(newToken);
      });
    } catch (e) {
      log("FCM initialization skipped or failed: $e");
    }
  }

  /// Request permissions for push notifications
  Future<void> requestPermissions() async {
    try {
      final msg = _messaging;
      if (msg == null) return;
      
      NotificationSettings settings = await msg.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      log("User granted notification permission: ${settings.authorizationStatus}");
    } catch (e) {
      log("Error requesting notification permissions: $e");
    }
  }

  /// Fetch token from FCM SDK and register it with the backend if logged in
  Future<void> registerToken() async {
    try {
      final msg = _messaging;
      if (msg == null) return;

      String? token = await msg.getToken();
      if (token != null) {
        log("Fetched FCM Token: $token");
        await LocalStorageApp().saveFcmToken(token);
        await sendTokenToBackend(token);
      }
    } catch (e) {
      log("Error retrieving FCM token: $e");
    }
  }

  /// Send FCM token to the backend server
  Future<void> sendTokenToBackend(String token) async {
    try {
      final authToken = await LocalStorageApp().getAuthToken();
      if (authToken.isEmpty) {
        log("Cannot send FCM token: User not logged in");
        return;
      }

      final url = Uri.parse('${AppConfig.apiBaseUrl}/users/fcm-tokens');
      log("Registering FCM token to backend: $url");
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'token': token}),
      );

      log("FCM token registration response status: ${response.statusCode}");
      log("FCM token registration response body: ${response.body}");
    } catch (e) {
      log("Error sending FCM token to backend: $e");
    }
  }

  /// Delete FCM token from backend server
  Future<void> unregisterTokenFromBackend() async {
    try {
      final token = await LocalStorageApp().getFcmToken();
      final authToken = await LocalStorageApp().getAuthToken();
      
      if (token.isEmpty) {
        log("No FCM token found to unregister");
        return;
      }
      if (authToken.isEmpty) {
        log("Cannot unregister FCM token: Auth token is empty");
        return;
      }

      final url = Uri.parse('${AppConfig.apiBaseUrl}/users/fcm-tokens/$token');
      log("Deleting FCM token from backend: $url");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      log("FCM token deletion response status: ${response.statusCode}");
      log("FCM token deletion response body: ${response.body}");
    } catch (e) {
      log("Error unregistering FCM token from backend: $e");
    }
  }
}
