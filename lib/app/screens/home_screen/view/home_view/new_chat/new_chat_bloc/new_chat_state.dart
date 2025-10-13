part of 'new_chat_bloc.dart';

sealed class NewChatState {}

final class NewChatInitial extends NewChatState {}

class LoadingState extends NewChatState {}

class ErrorOccurredState extends NewChatState {
  final String message;
  ErrorOccurredState({required this.message});
}

class GotUsersSuccessState extends NewChatState {
  GotUsersSuccessState();
}

class NoAction extends NewChatState {
  bool isSearch;
  bool isLoading;
  NoAction({this.isSearch = false, this.isLoading = false});
}

class OpenChatState extends NewChatState {
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
