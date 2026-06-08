part of 'current_chats_bloc.dart';

sealed class CurrentChatsState {}

final class CurrentChatListInitial extends CurrentChatsState {}

final class GetAllChatsState extends CurrentChatsState {}

final class LoadingCurrentChatsState extends CurrentChatsState {}

class OpenChatState extends CurrentChatsState {
  final int roomId;
  final String roomName;
  OpenChatState({
    required this.roomId,
    required this.roomName,
  });
}

class NoAction extends CurrentChatsState {
  bool isLoading;
  NoAction({this.isLoading = false});
}
