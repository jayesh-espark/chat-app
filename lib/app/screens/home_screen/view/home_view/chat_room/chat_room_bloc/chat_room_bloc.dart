import 'dart:async';

import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:chating_app/app/model/chat_model.dart';
import 'package:chating_app/app/network_calls/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  Stream<List<ChatMessageModel>>? chatMessagesStream = const Stream.empty();
  List<ChatMessageModel> chatMessages = [];
  String userName = "";
  String avatar = "";
  final ChatServices _chatServices = ChatServices();

  ChatRoomBloc() : super(ChatRoomInitial()) {
    on<LoadChatMessagesEvent>(_handleLoadChatMessages);
    on<SendMessageEvent>(_handleSendMessage);
  }

  Future<void> _handleLoadChatMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    // Here you would typically load messages from a backend or database
    // For demonstration, we'll just emit an empty list
    var userId = await LocalStorageApp().getUserId();
    chatMessages = await _chatServices.getExistingChats(
      event.chatId,
      userId,
      event.receiverId,
    );
    chatMessagesStream = await _chatServices.getChatMessagesStream(
      event.chatId,
    );
    userName = event.name;
    avatar = event.avatar;
    emit(ChatMessagesLoadedState());
  }

  Future<void> _handleSendMessage(
    SendMessageEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    var senderId = await LocalStorageApp().getUserId();
    _chatServices.sendMessage(event.chatId, senderId, event.message);
    emit(MessageSentState());
  }
}
