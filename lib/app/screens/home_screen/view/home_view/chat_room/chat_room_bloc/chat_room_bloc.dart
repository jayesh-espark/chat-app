import 'dart:async';
import 'dart:developer';

import 'package:chating_app/app/core/config/app_config.dart';
import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:chating_app/app/model/chat_model.dart';
import 'package:chating_app/app/network_calls/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  List<ChatMessageModel> chatMessages = [];
  int roomId = 0;
  String roomName = "";
  IO.Socket? socket;

  final ChatServices _chatServices = ChatServices();

  ChatRoomBloc() : super(ChatRoomInitial()) {
    on<LoadChatMessagesEvent>(_handleLoadChatMessages);
    on<SendMessageEvent>(_handleSendMessage);
    on<MessageReceivedEvent>(_handleMessageReceived);
  }

  Future<void> _handleLoadChatMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    roomId = event.roomId;
    roomName = event.roomName;

    emit(ChatRoomLoadingState());

    final currentUserId = await LocalStorageApp().getUserId();
    final token = await LocalStorageApp().getAuthToken();

    // 1. Load message history from REST API
    chatMessages = await _chatServices.getExistingChats(
      roomId.toString(),
      currentUserId,
    );
    emit(ChatMessagesLoadedState());

    // 2. Connect to Socket.IO
    _initializeSocket(token, currentUserId);
  }

  void _initializeSocket(String token, String currentUserId) {
    // Disconnect existing socket if any
    socket?.disconnect();
    socket?.dispose();

    final socketUrl = AppConfig.baseUrl;
    log("Connecting to Socket.IO server at: $socketUrl");

    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );

    socket?.onConnect((_) {
      log("Socket.IO connected successfully for Room: $roomId");
      socket?.emit('join_room', {'roomId': roomId});
    });

    socket?.onDisconnect((_) {
      log("Socket.IO disconnected");
    });

    socket?.on('new_message', (data) {
      log("Socket.IO new_message received: $data");
      try {
        if (data is Map<String, dynamic>) {
          final message = ChatMessageModel.fromJson(data, currentUserId);
          add(MessageReceivedEvent(message));
        }
      } catch (e) {
        log("Error parsing new_message: $e");
      }
    });

    socket?.on('user_joined', (data) {
      log("Socket.IO user_joined: $data");
      // Optional: Add a system message or notify UI
    });

    socket?.on('error', (data) {
      log("Socket.IO error: $data");
    });
  }

  FutureOr<void> _handleMessageReceived(
    MessageReceivedEvent event,
    Emitter<ChatRoomState> emit,
  ) {
    // Append message to the list
    chatMessages = List.from(chatMessages)..add(event.message);
    emit(ChatMessagesLoadedState());
  }

  Future<void> _handleSendMessage(
    SendMessageEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (socket != null && socket!.connected) {
      log("Sending Socket.IO message in Room: ${event.roomId}");
      socket!.emit('send_message', {
        'roomId': event.roomId,
        'message': event.message,
      });
      emit(MessageSentState());
    } else {
      log("Socket not connected, cannot send message");
    }
  }

  @override
  Future<void> close() {
    log("Disconnecting socket in ChatRoomBloc close");
    socket?.disconnect();
    socket?.dispose();
    return super.close();
  }
}
