part of 'current_chats_bloc.dart';

sealed class CurrentChatsState {}

final class CurrentChatListInitial extends CurrentChatsState {}

final class GetAllChatsState extends CurrentChatsState {}

class OpenChatState extends CurrentChatsState {
  final String chatId;
  final String userId;
  final String avatar;
  final String userName;
  OpenChatState({
    required this.chatId,
    required this.userId,
    required this.avatar,
    required this.userName,
  });
}

class NoAction extends CurrentChatsState {
  bool isLoading;
  NoAction({this.isLoading = false});
}
