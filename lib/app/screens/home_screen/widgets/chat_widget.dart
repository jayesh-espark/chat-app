import 'package:chating_app/app/model/chat_room_model.dart';
import 'package:chating_app/app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatTile extends StatelessWidget {
  final ChatRoomModel? chat;
  final UserModel? userModel;
  final VoidCallback onTap;

  const ChatTile({super.key, this.chat, this.userModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (chat == null && userModel == null) {
      return const SizedBox();
    }

    if (userModel != null) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Avatar with shimmer & pulse effect
              Stack(
                children: [
                  Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // rounding the image
                            child: Image.asset(
                              userModel?.avatarUrl ?? 'assets/placeholder.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: Offset(0.95, 1),
                        end: Offset(1.05, 1),
                        duration: 1000.ms,
                      )
                      .then()
                      .scale(
                        begin: Offset(1.05, 1),
                        end: Offset(0.95, 1),
                        duration: 1000.ms,
                      ),
                ],
              ),
              const SizedBox(width: 12),
              // Content with shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          "${userModel?.firstName ?? ""} ${userModel?.lastName ?? ""}",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1500.ms, color: Colors.white38),
                    Text(
                          "Dob : ${userModel?.dateOfBirth ?? ""}",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1500.ms, color: Colors.white38),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar with shimmer & pulse effect
            ClipRRect(
                  borderRadius: BorderRadius.circular(50), // rounding the image
                  child: Image.asset(
                    chat?.user?.avatarUrl ?? 'assets/placeholder.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: Offset(0.95, 1),
                  end: Offset(1.05, 1),
                  duration: 1000.ms,
                )
                .then()
                .scale(
                  begin: Offset(1.05, 1),
                  end: Offset(0.95, 1),
                  duration: 1000.ms,
                ),

            const SizedBox(width: 12),
            // Content with shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        '${chat?.user?.firstName ?? ""} ${chat?.user?.lastName ?? ""}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1500.ms, color: Colors.white38),
                  Text(
                        chat?.lastMessage ?? "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1500.ms, color: Colors.white38),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
