import 'dart:developer';

import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/base_response.dart';
import '../../model/user_model.dart';

class AuthServices {
  AuthServices._();
  static final AuthServices _instance = AuthServices._();
  factory AuthServices() => _instance;

  var client = Supabase.instance.client;
  // ---------- SIGNUP ----------
  Future<BaseResponseModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DateTime dateOfBirth,
    required String avatar, // optional
  }) async {
    try {
      log("response entry 1");

      // Create account
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      log("response entry 2 ${response.user?.toJson()}");
      log("response entry 2 ${response.session?.toJson()}");

      final user = response.user;
      final session = response.session;
      log("response entry 3");

      if (user == null || session == null) {
        return BaseResponseModel(
          success: false,
          message: "User or session is null",
        );
      }

      log("response entry 4");

      // Save session locally
      await LocalStorageApp().saveAuthData(session.accessToken, user.id);
      log("response entry 5");

      // Store user profile in 'profiles' table
      await client.from('users').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'avatar_url': avatar,
      });
      UserModel? userNew = await getUserData();
      if (userNew != null) {
        await LocalStorageApp().saveUser(userNew);
      }

      return BaseResponseModel(
        success: true,
        message: "Sign up successful",
        data: userNew,
      );
    } catch (e) {
      print('SignUp error: $e');
      if (e is AuthApiException) {
        log("SignUp error: ${e.message}");
        return BaseResponseModel(success: false, message: e.message);
      }
      return BaseResponseModel(success: false, message: e.toString());
    }
  }

  // ---------- LOGIN ----------
  Future<BaseResponseModel> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        return BaseResponseModel(
          success: false,
          message: "User or session is null",
        );
      }

      await LocalStorageApp().saveAuthData(session.accessToken, user.id);
      log("user => ${user.toJson()}");
      UserModel? userNew = await getUserData();
      if (userNew != null) {
        await LocalStorageApp().saveUser(userNew);
      }

      return BaseResponseModel(
        success: true,
        message: "Login successful",
        data: userNew,
      );
    } catch (e) {
      print('Login error: $e');
      if (e is AuthApiException) {
        log("Login error: ${e.message}");
        return BaseResponseModel(success: false, message: e.message);
      }
      return BaseResponseModel(success: false, message: e.toString());
    }
  }

  // ---------- get User data ----------

  Future<UserModel?> getUserData() async {
    try {
      var userid = await LocalStorageApp().getUserId();
      final response = await client.from('users').select().eq('id', userid);
      log("user data => $response");
      log("user data => ${response.single}");
      return UserModel.fromJson(response.single);
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // ---------- get All Users data ----------
  Future<List<UserModel>?> getAllUsers() async {
    try {
      var userId = await LocalStorageApp().getUserId();
      log("my user id => $userId");
      final response = await client
          .from('users')
          .select()
          .neq('id', userId); // Exclude current user;

      return (response as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      print('Get user data error: $e');
      return [];
    }
  }

  // ---------- LOGOUT ----------
  Future<void> logout() async {
    await client.auth.signOut();
    await LocalStorageApp().clearAuthData();
  }
}
