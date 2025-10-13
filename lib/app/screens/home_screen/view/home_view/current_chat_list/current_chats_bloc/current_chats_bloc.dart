import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/storage/local_storage.dart';
import '../../../../../../model/chat_room_model.dart';
import '../../../../../../network_calls/services/chat_services.dart';

part 'current_chats_event.dart';
part 'current_chats_state.dart';

class CurrentChatsBloc extends Bloc<CurrentChatsEvent, CurrentChatsState> {
  List<ChatRoomModel> chats = [];

  CurrentChatsBloc() : super(CurrentChatListInitial()) {
    on<GetAllChatsEvent>(_handleGetAllChats);
    on<OpenChatEvent>(_handleOpenChatEventNewChat);
  }
  FutureOr<void> _handleGetAllChats(
    GetAllChatsEvent event,
    Emitter<CurrentChatsState> emit,
  ) async {
    var userId = await LocalStorageApp().getUserId();
    chats = await ChatServices().getUserChats(userId);
    log("chats --> $chats");

    emit(GetAllChatsState());
  }

  Future<void> _handleOpenChatEventNewChat(
    OpenChatEvent event,
    Emitter<CurrentChatsState> emit,
  ) async {
    try {
      emit(
        OpenChatState(
          chatId: event.chatId,
          userId: event.userId,
          avatar: event.avatar,
          userName: event.userName,
        ),
      );
    } catch (e) {
      log("Error in creating chat room: $e");
      emit(NoAction(isLoading: false));
    }
  }
}
