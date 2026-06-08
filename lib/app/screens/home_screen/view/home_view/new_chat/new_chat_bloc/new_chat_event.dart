part of 'new_chat_bloc.dart';

sealed class NewChatEvent {}

final class InitializeNewChatEvent extends NewChatEvent {}

final class CreateRoomEvent extends NewChatEvent {
  final String name;
  CreateRoomEvent(this.name);
}
