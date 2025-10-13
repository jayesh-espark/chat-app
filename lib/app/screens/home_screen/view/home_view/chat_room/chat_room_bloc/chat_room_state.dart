part of 'chat_room_bloc.dart';

sealed class ChatRoomState {}

final class ChatRoomInitial extends ChatRoomState {}

class LoadingChatMessagesState extends ChatRoomState {}

class SendMessageSuccessState extends ChatRoomState {}

class ChatMessagesLoadedState extends ChatRoomState {}

class MessageSentState extends ChatRoomState {}
