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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      log("ChatRoomView settings arguments: $args");

      final int roomId = args?['roomId'] is int
          ? args!['roomId'] as int
          : int.tryParse((args?['roomId'] ?? '1').toString()) ?? 1;
      final String roomName = args?['roomName'] ?? 'General Room';

      context.read<ChatRoomBloc>().add(
            LoadChatMessagesEvent(
              roomId: roomId,
              roomName: roomName,
            ),
          );
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final bloc = context.read<ChatRoomBloc>();
    bloc.add(
      SendMessageEvent(
        roomId: bloc.roomId,
        message: _controller.text.trim(),
      ),
    );
    _controller.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
        if (state is ChatMessagesLoadedState || state is MessageSentState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        final bloc = context.read<ChatRoomBloc>();
        final messages = bloc.chatMessages;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.secondary,
                  child: Icon(
                    Icons.forum_outlined,
                    color: colorScheme.onSecondary,
                  ),
                ).animate().scale(
                      delay: 200.ms,
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bloc.roomName.isEmpty ? 'General Room' : bloc.roomName,
                        style: theme.appBarTheme.titleTextStyle?.copyWith(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
                      Text(
                        'Room ID: ${bloc.roomId}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: state is ChatRoomLoadingState && messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            message: messages[index],
                            index: index,
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
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
            ),
            IconButton(
              icon: Icon(Icons.send, color: colorScheme.secondary),
              onPressed: _sendMessage,
            ).animate().fadeIn(delay: 300.ms).scale(curve: Curves.elasticOut),
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

    final displayName = message.name.isNotEmpty
        ? message.name
        : (message.username.isNotEmpty ? message.username : 'User');
    final hasImage = message.profileImageUrl.isNotEmpty;

    if (isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4),
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
                    color: colorScheme.onPrimary,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  _formatTime(message.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Incoming message: Render sender's profile picture and display name next to message
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Sender Avatar
            Container(
              margin: const EdgeInsets.only(top: 2, right: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: hasImage ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(message.profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasImage
                  ? Center(
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ).animate().scale(duration: 250.ms, curve: Curves.easeOut),

            // Message Bubble content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? colorScheme.surface
                          : Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(20),
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
                        color: theme.brightness == Brightness.dark
                            ? colorScheme.onSurface
                            : Colors.black87,
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _formatTime(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
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
