part of 'chat_room_bloc.dart';

sealed class ChatRoomEvent {}

class LoadChatMessagesEvent extends ChatRoomEvent {
  final String chatId;
  final String receiverId;
  final String name;
  final String avatar;
  LoadChatMessagesEvent({
    required this.chatId,
    required this.receiverId,
    required this.name,
    required this.avatar,
  });
}

class SendMessageEvent extends ChatRoomEvent {
  final String chatId;
  final String receiverId;
  final String message;
  SendMessageEvent({
    required this.chatId,
    required this.receiverId,
    required this.message,
  });
}
