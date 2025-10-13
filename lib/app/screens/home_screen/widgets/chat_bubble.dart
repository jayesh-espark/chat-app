import 'package:chating_app/app/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
