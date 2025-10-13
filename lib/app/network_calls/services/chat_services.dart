import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/storage/local_storage.dart';
import '../../model/chat_model.dart';
import '../../model/chat_room_model.dart';

class ChatServices {
  ChatServices._();
  static final ChatServices _instance = ChatServices._();
  factory ChatServices() => _instance;
  final _client = Supabase.instance.client;

  Future<String> createChatRoom(String user1Id, String user2Id) async {
    // Step 1: Check if chat already exists
    final existingChat = await _client
        .from('chats')
        .select()
        .or(
          'and(user1_id.eq.$user1Id,user2_id.eq.$user2Id),and(user1_id.eq.$user2Id,user2_id.eq.$user1Id)',
        )
        // .or('user1_id.eq.$user1Id,user2_id.eq.$user2Id')
        .limit(1)
        .maybeSingle();

    if (existingChat != null) {
      // Chat exists
      return existingChat['id'];
    }

    // Step 2: Create a new chat
    final newChat = await _client
        .from('chats')
        .insert({
          'user1_id': user1Id,
          'user2_id': user2Id,
          'last_message': '',
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return newChat['id']; // Return the chat id
  }

  Future<void> sendMessage(
    String chatId,
    String senderId,
    String message,
  ) async {
    // Step 1: Insert message into messages table
    await _client.from('chat_rooms').insert({
      'chat_id': chatId,
      'sender_id': senderId,
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Step 2: Update last message in chats table
    await _client
        .from('chats')
        .update({
          'last_message': message,
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .eq('id', chatId);
  }

  Future<List<ChatRoomModel>> getUserChats(String userId) async {
    try {
      final response = await _client
          .from('chats')
          .select('''
      id,
      user1_id,
      user2_id,
      last_message,
      last_message_at,
      user1:user1_id(first_name,last_name,avatar_url),
      user2:user2_id(first_name,last_name,avatar_url)
    ''')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('last_message_at', ascending: false);

      // Now map to show the "other user" clearly

      var data = response.map((e) {
        final isUser1 = e['user1_id'] != userId;
        final modifiedData = Map<String, dynamic>.from(e);
        modifiedData['user'] = isUser1 ? e['user1'] : e['user2'];
        modifiedData['user_id'] = isUser1 ? e['user1_id'] : e['user2_id'];
        return ChatRoomModel.fromJson(modifiedData);
      }).toList();
      return data;
    } catch (e) {
      log("Error fetching user chats: $e");
      return [];
    }
  }

  Future<Stream<List<ChatMessageModel>>> getChatMessagesStream(
    String chatRoomId,
  ) async {
    final userId = await LocalStorageApp().getUserId();
    return _client
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatRoomId)
        .order('created_at')
        .map(
          (maps) => maps.map((row) {
            return ChatMessageModel(
              text: row['message'] ?? "",
              isMe: row['sender_id'] == userId,
              timestamp: DateTime.parse(row['created_at'] as String),
            );
          }).toList(),
        );
  }

  Future<List<ChatMessageModel>> getExistingChats(
    String chatRoomId,
    String userAId,
    String userBId,
  ) async {
    final userId = await LocalStorageApp().getUserId();

    final List<dynamic> list = await _client
        .from('chat_rooms')
        .select()
        .eq('chat_id', chatRoomId)
        .order('created_at');
    log("list => $list");
    return list.map((row) {
      return ChatMessageModel(
        text: row['message'] as String? ?? "",
        isMe: row['sender_id'] == userId,
        timestamp: DateTime.parse(row['created_at'] as String),
      );
    }).toList();
  }
}
