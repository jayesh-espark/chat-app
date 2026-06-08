part of 'chat_room_bloc.dart';

sealed class ChatRoomEvent {}

class LoadChatMessagesEvent extends ChatRoomEvent {
  final int roomId;
  final String roomName;
  LoadChatMessagesEvent({
    required this.roomId,
    required this.roomName,
  });
}

class SendMessageEvent extends ChatRoomEvent {
  final int roomId;
  final String message;
  SendMessageEvent({
    required this.roomId,
    required this.message,
  });
}

class MessageReceivedEvent extends ChatRoomEvent {
  final ChatMessageModel message;
  MessageReceivedEvent(this.message);
}
