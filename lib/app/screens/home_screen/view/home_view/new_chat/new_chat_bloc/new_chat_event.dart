part of 'new_chat_bloc.dart';

sealed class NewChatEvent {}

final class InitializeNewChatEvent extends NewChatEvent {}

final class OpenChatEvent extends NewChatEvent {
  final String userId;
  final String avatar;
  final String userName;
  OpenChatEvent({
    required this.userId,
    required this.avatar,
    required this.userName,
  });
}
