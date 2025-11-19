import 'package:chating_app/app/core/utills/app_constants.dart';
import 'package:chating_app/app/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalStorageApp {
  static final LocalStorageApp _instance = LocalStorageApp._internal();
  factory LocalStorageApp() => _instance;
  LocalStorageApp._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  Future<void> saveAuthData(String token, String userId) async {
    await _storage.write(key: AppConstants.keyUserToken, value: token);
    await _storage.write(key: AppConstants.keyUserId, value: userId);
  }

  // Save User
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: AppConstants.keyUserData, value: userJson);
  }

  // Get User
  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: AppConstants.keyUserData);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<String> getAuthToken() async {
    try {
      return await _storage.read(key: AppConstants.keyUserToken) ?? "";
    } catch (E) {
      return "";
    }
  }

  Future<bool> isAppLocked() async {
    try {
      return bool.parse(
        await _storage.read(key: AppConstants.keyBioMatricAuth) ?? "false",
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> saveAppLocked(bool user) async {
    await _storage.write(
      key: AppConstants.keyBioMatricAuth,
      value: user.toString(),
    );
  }

  Future<String> getUserId() async {
    try {
      return await _storage.read(key: AppConstants.keyUserId) ?? "";
    } catch (e) {
      return "";
    }
  }

  Future<void> clearAuthData() async {
    await _storage.deleteAll();
  }
}
