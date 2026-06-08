part of 'new_chat_bloc.dart';

sealed class NewChatState {}

final class NewChatInitial extends NewChatState {}

final class GotUsersSuccessState extends NewChatState {}

class OpenChatState extends NewChatState {
  final int roomId;
  final String roomName;
  OpenChatState({
    required this.roomId,
    required this.roomName,
  });
}

class NoAction extends NewChatState {
  bool isLoading;
  NoAction({this.isLoading = false});
}
