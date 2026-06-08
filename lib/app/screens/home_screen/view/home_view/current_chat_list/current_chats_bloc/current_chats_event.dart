part of 'current_chats_bloc.dart';

sealed class CurrentChatsEvent {}

final class GetAllChatsEvent extends CurrentChatsEvent {}

final class OpenChatEvent extends CurrentChatsEvent {
  final int roomId;
  final String roomName;
  OpenChatEvent({
    required this.roomId,
    required this.roomName,
  });
}
