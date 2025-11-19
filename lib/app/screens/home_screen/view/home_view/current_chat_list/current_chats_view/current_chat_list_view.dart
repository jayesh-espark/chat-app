import 'dart:developer';

import 'package:chating_app/app/core/utills/navigation_utils.dart';
import 'package:chating_app/app/router/app_routes.dart';
import 'package:chating_app/app/screens/home_screen/bloc/home_bloc/home_bloc.dart';
import 'package:chating_app/app/screens/home_screen/view/home_view/current_chat_list/current_chats_bloc/current_chats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../widgets/chat_widget.dart';

class CurrentChatsView extends StatefulWidget {
  const CurrentChatsView({super.key});

  @override
  State<CurrentChatsView> createState() => _CurrentChatsViewState();
}

class _CurrentChatsViewState extends State<CurrentChatsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrentChatsBloc>().add(GetAllChatsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats'), centerTitle: true),
      body: BlocConsumer<CurrentChatsBloc, CurrentChatsState>(
        listener: (context, state) {
          if (state is NoAction) {
            if (state.isLoading == false) {
              context.loaderOverlay.hide();
              return;
            } else if (state.isLoading == true) {
              context.loaderOverlay.show();
              return;
            }
          }

          if (state is OpenChatState) {
            navigateToNamed(
              context,
              AppRoutes.chatBubbleScreen,
              arguments: {
                "chatId": state.chatId,
                "userId": state.userId,
                "user_name": state.userName,
                "avatar": state.avatar,
              },
            );
          }
        },
        builder: (context, state) {
          var bloc = context.read<CurrentChatsBloc>();

          if (state is LoadingCurrentChatsState) {
            return ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ).animate().shimmer(duration: 1200.ms, delay: (index * 100).ms),
            );
          }

          if (bloc.chats.isEmpty) {
            return const Center(
              child: Text(
                "No chats yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bloc.chats.length,
            itemBuilder: (context, index) {
              final chat = bloc.chats[index];

              return ChatTile(
                    chat: chat,
                    onTap: () {
                      bloc.add(
                        OpenChatEvent(
                          userId: chat.userId,
                          chatId: chat.id,
                          avatar: chat.user?.avatarUrl ?? "",
                          userName:
                              "${chat.user?.firstName ?? ""} ${chat.user?.lastName ?? ""}",
                        ),
                      );
                    },
                  )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                  .slideY(begin: 0.2, end: 0);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToNamed(context, AppRoutes.addNewChat);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
