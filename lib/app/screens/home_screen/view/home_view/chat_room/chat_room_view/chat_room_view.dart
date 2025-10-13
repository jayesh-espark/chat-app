import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../model/chat_model.dart';
import '../chat_room_bloc/chat_room_bloc.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  var _userId = '';
  var _chatId = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      log("args : $args");
      var userId = args?['userId'] ?? '';
      log("userId : $userId");
      var chatId = args?['chatId'] ?? '';
      log("chatId : $chatId");
      var name = args?['user_name'] ?? '';
      log("name : $name");
      var avatar = args?['avatar'] ?? '';
      log("avatar : $avatar");
      _userId = userId;
      _chatId = chatId;
      context.read<ChatRoomBloc>().add(
        LoadChatMessagesEvent(
          chatId: chatId,
          receiverId: userId,
          name: name,
          avatar: avatar,
        ),
      );
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    var bloc = context.read<ChatRoomBloc>();
    bloc.add(
      SendMessageEvent(
        chatId: _chatId,
        receiverId: _userId,
        message: _controller.text.trim(),
      ),
    );
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BlocConsumer<ChatRoomBloc, ChatRoomState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var bloc = context.read<ChatRoomBloc>();
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                bloc.avatar.isEmpty
                    ? CircleAvatar(
                        backgroundColor: colorScheme.secondary,
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onSecondary,
                        ),
                      ).animate().scale(
                        delay: 200.ms,
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      )
                    : ClipOval(
                        child:
                            CircleAvatar(
                              backgroundColor: colorScheme.secondary,
                              child: Image.asset(bloc.avatar),
                            ).animate().scale(
                              delay: 200.ms,
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            ),
                      ),
                const SizedBox(width: 12),
                Text(
                  bloc.userName.isEmpty ? 'John Doe' : bloc.userName,
                  style: theme.appBarTheme.titleTextStyle,
                ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatMessageModel>>(
                  stream: bloc.chatMessagesStream,
                  initialData: bloc.chatMessages,
                  builder: (context, snapshot) {
                    final messages = snapshot.data ?? [];
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        log(" messages.length : ${messages.length}");
                        return ChatBubble(
                          message: messages[index],
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(theme, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 8),

            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
            ),

            IconButton(
                  icon: Icon(Icons.send, color: colorScheme.secondary),
                  onPressed: _sendMessage,
                )
                .animate()
                .fadeIn(delay: 1100.ms)
                .scale(delay: 1100.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final int index;

  const ChatBubble({super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? colorScheme.primary
                        : (theme.brightness == Brightness.dark
                              ? colorScheme.surface
                              : Colors.grey[200]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isMe
                          ? colorScheme.onPrimary
                          : (theme.brightness == Brightness.dark
                                ? colorScheme.onSurface
                                : Colors.black87),
                    ),
                  ),
                )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                )
                .slideX(
                  begin: isMe ? 0.3 : -0.3,
                  end: 0,
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: theme.textTheme.bodySmall,
            ).animate().fadeIn(
              delay: Duration(milliseconds: 100 * index + 200),
              duration: 300.ms,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
