import 'dart:async';
import 'dart:developer';
import 'package:chating_app/app/network_calls/services/auth_services.dart';
import 'package:chating_app/app/network_calls/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../model/user_model.dart';

part 'new_chat_event.dart';
part 'new_chat_state.dart';

class NewChatBloc extends Bloc<NewChatEvent, NewChatState> {
  List<UserModel>? userList = [];
  NewChatBloc() : super(NewChatInitial()) {
    on<InitializeNewChatEvent>(_handleInitializeNewChat);
    on<CreateRoomEvent>(_handleCreateRoom);
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

  Future<void> _handleCreateRoom(
    CreateRoomEvent event,
    Emitter<NewChatState> emit,
  ) async {
    try {
      emit(NoAction(isLoading: true));
      log("Creating chat room with name: ${event.name}");
      final room = await ChatServices().createChatRoom(event.name);
      emit(NoAction(isLoading: false));
      if (room != null) {
        emit(
          OpenChatState(
            roomId: room.id,
            roomName: room.name,
          ),
        );
      }
    } catch (e) {
      log("Error in creating room: $e");
      emit(NoAction(isLoading: false));
    }
  }
}
