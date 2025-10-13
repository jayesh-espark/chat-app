import 'dart:async';
import 'dart:developer';
import 'package:chating_app/app/network_calls/services/auth_services.dart';
import 'package:chating_app/app/network_calls/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/storage/local_storage.dart';
import '../../../../../../model/user_model.dart';

part 'new_chat_event.dart';
part 'new_chat_state.dart';

class NewChatBloc extends Bloc<NewChatEvent, NewChatState> {
  List<UserModel>? userList = [];
  NewChatBloc() : super(NewChatInitial()) {
    on<InitializeNewChatEvent>(_handleInitializeNewChat);
    on<OpenChatEvent>(_handleOpenChatEventNewChat);
  }

  Future<void> _handleInitializeNewChat(
    InitializeNewChatEvent event,
    Emitter<NewChatState> emit,
  ) async {
    try {
      emit(NoAction(isLoading: true));
      userList = await AuthServices().getAllUsers();
    } catch (e) {
      log("Error in fetching users: $e");
      userList = [];
    }
    emit(NoAction(isLoading: false));
    emit(GotUsersSuccessState());
  }

  Future<void> _handleOpenChatEventNewChat(
    OpenChatEvent event,
    Emitter<NewChatState> emit,
  ) async {
    try {
      var userId = await LocalStorageApp().getUserId();
      emit(NoAction(isLoading: true));
      log("Creating chat room with user ID: ${event.userId}");
      var chatRoomId = await ChatServices().createChatRoom(
        userId,
        event.userId,
      );
      log("Chat Room ID: $chatRoomId");
      emit(NoAction(isLoading: false));
      emit(
        OpenChatState(
          chatId: chatRoomId,
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
