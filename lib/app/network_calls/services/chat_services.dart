import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/storage/local_storage.dart';
import '../../model/chat_model.dart';
import '../../model/chat_room_model.dart';

class ChatServices {
  ChatServices._();
  static final ChatServices _instance = ChatServices._();
  factory ChatServices() => _instance;

  // ---------- CREATE ROOM ----------
  Future<ChatRoomModel?> createChatRoom(String name) async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) return null;

      final url = Uri.parse('${AppConfig.apiBaseUrl}/chat/rooms');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name}),
      );

      log("Create room response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          return ChatRoomModel.fromJson(body['data']['room']);
        }
      }
      return null;
    } catch (e) {
      log("Error creating room: $e");
      return null;
    }
  }

  // ---------- GET USER CHATS / ALL ROOMS ----------
  Future<List<ChatRoomModel>> getUserChats(String userId) async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) return [];

      final url = Uri.parse('${AppConfig.apiBaseUrl}/chat/rooms');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Get user rooms response: ${response.body}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final list = body['data']['rooms'] as List<dynamic>;
          return list.map((e) => ChatRoomModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      log("Error fetching rooms: $e");
      return [];
    }
  }

  // ---------- GET ROOM MESSAGES HISTORY ----------
  Future<List<ChatMessageModel>> getExistingChats(
    String roomId,
    String currentUserId,
  ) async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) return [];

      final url = Uri.parse('${AppConfig.apiBaseUrl}/chat/rooms/$roomId/messages');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Get room messages response: ${response.body}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final list = body['data']['messages'] as List<dynamic>;
          return list
              .map((e) => ChatMessageModel.fromJson(e, currentUserId))
              .toList();
        }
      }
      return [];
    } catch (e) {
      log("Error loading room messages: $e");
      return [];
    }
  }

  // ---------- CREATE OR GET DM ROOM ----------
  Future<ChatRoomModel?> createOrGetDirectMessageRoom(String receiverId) async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) return null;

      final url = Uri.parse('${AppConfig.apiBaseUrl}/chat/rooms/dm');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'receiverId': receiverId}),
      );

      log("Create DM room response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          return ChatRoomModel.fromJson(body['data']['room']);
        }
      }
      return null;
    } catch (e) {
      log("Error creating/getting DM room: $e");
      return null;
    }
  }
}
