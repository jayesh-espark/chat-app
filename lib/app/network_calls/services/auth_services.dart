import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/storage/local_storage.dart';
import '../../model/base_response.dart';
import '../../model/user_model.dart';

class AuthServices {
  AuthServices._();
  static final AuthServices _instance = AuthServices._();
  factory AuthServices() => _instance;

  // ---------- LOGIN ----------
  Future<BaseResponseModel<UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}/auth/login');
      log("Logging in via URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      log("Login response status: ${response.statusCode}");
      log("Login response body: ${response.body}");

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['status'] == 'success') {
          final data = body['data'] as Map<String, dynamic>;
          final token = data['token'] as String;
          final userMap = data['user'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userMap);

          // Save auth data and user profile locally
          await LocalStorageApp().saveAuthData(token, user.id);
          await LocalStorageApp().saveUser(user);

          return BaseResponseModel(
            success: true,
            message: "Login successful",
            data: user,
          );
        }
      }

      final errorMsg = body['message'] ?? "Failed to login";
      return BaseResponseModel(success: false, message: errorMsg.toString());
    } catch (e) {
      log('Login exception: $e');
      return BaseResponseModel(success: false, message: e.toString());
    }
  }

  // ---------- REGISTER ----------
  Future<BaseResponseModel<UserModel>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}/auth/register');
      log("Registering via URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      log("Register response status: ${response.statusCode}");
      log("Register response body: ${response.body}");

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['status'] == 'success') {
          final data = body['data'] as Map<String, dynamic>;
          final token = data['token'] as String;
          final userMap = data['user'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userMap);

          // Save auth data and user profile locally
          await LocalStorageApp().saveAuthData(token, user.id);
          await LocalStorageApp().saveUser(user);

          return BaseResponseModel(
            success: true,
            message: "Registration successful",
            data: user,
          );
        }
      }

      final errorMsg = body['message'] ?? "Failed to register";
      return BaseResponseModel(success: false, message: errorMsg.toString());
    } catch (e) {
      log('Register exception: $e');
      return BaseResponseModel(success: false, message: e.toString());
    }
  }

  // ---------- GET USER PROFILE ----------
  Future<UserModel?> getUserData() async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) return null;

      final url = Uri.parse('${AppConfig.apiBaseUrl}/users/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final profileMap = body['data']['profile'] as Map<String, dynamic>;
          return UserModel.fromJson(profileMap);
        }
      }
      return null;
    } catch (e) {
      log('Get user profile error: $e');
      return null;
    }
  }

  // ---------- GET ALL USERS ----------
  Future<List<UserModel>> getAllUsers() async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      final currentUserId = await LocalStorageApp().getUserId();
      if (token.isEmpty) return [];

      final url = Uri.parse('${AppConfig.apiBaseUrl}/users');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final usersList = body['data']['users'] as List<dynamic>;
          final allUsers =
              usersList.map((e) => UserModel.fromJson(e)).toList();

          // Return list excluding current user
          return allUsers.where((user) => user.id != currentUserId).toList();
        }
      }
      return [];
    } catch (e) {
      log('Get all users error: $e');
      return [];
    }
  }

  // ---------- LOGOUT ----------
  Future<void> logout() async {
    await LocalStorageApp().clearAuthData();
  }
}
