part of 'current_chats_bloc.dart';

sealed class CurrentChatsEvent {}

final class GetAllChatsEvent extends CurrentChatsEvent {}

final class OpenChatEvent extends CurrentChatsEvent {
  final String userId;
  final String chatId;
  final String avatar;
  final String userName;
  OpenChatEvent({
    required this.userId,
    required this.chatId,
    required this.userName,
    required this.avatar,
  });
}
