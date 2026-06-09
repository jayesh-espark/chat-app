import 'package:chating_app/app/model/chat_room_model.dart';
import 'package:chating_app/app/model/user_model.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final ChatRoomModel? chat;
  final UserModel? userModel;
  final VoidCallback onTap;

  const ChatTile({super.key, this.chat, this.userModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (chat == null && userModel == null) {
      return const SizedBox();
    }

    // User Model Presentation (e.g. in Available Users directory list)
    if (userModel != null) {
      final hasUserImage = userModel?.profileImageUrl.isNotEmpty ?? false;
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.05),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: hasUserImage
                      ? null
                      : LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  shape: BoxShape.circle,
                  image: hasUserImage
                      ? DecorationImage(
                          image: NetworkImage(userModel!.profileImageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasUserImage
                    ? Center(
                        child: Text(
                          (userModel?.username.isNotEmpty ?? false)
                              ? userModel!.username[0].toUpperCase()
                              : 'U',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel?.name.isNotEmpty ?? false
                          ? userModel!.name
                          : userModel?.username ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (userModel?.name.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        '@${userModel?.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 2),
                      Text(
                        userModel?.email ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      );
    }

    // Chat Room Model Presentation (e.g. in Chat List)
    final isGroup = chat?.isGroup ?? true;
    final roomName = chat?.name ?? (isGroup ? 'General Room' : 'User');
    final hasRoomImage = chat?.profileImageUrl.isNotEmpty ?? false;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Room Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: hasRoomImage ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                image: hasRoomImage
                    ? DecorationImage(
                        image: NetworkImage(chat!.profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasRoomImage
                  ? Icon(
                      isGroup ? Icons.groups : Icons.person,
                      color: colorScheme.primary,
                      size: 26,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGroup ? 'Group Room ID: ${chat?.id ?? 0}' : 'Direct Message',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
