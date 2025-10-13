import 'package:chating_app/app/core/utills/navigation_utils.dart';
import 'package:chating_app/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../widgets/chat_widget.dart';
import '../new_chat_bloc/new_chat_bloc.dart';

class AddNewChatView extends StatefulWidget {
  const AddNewChatView({super.key});

  @override
  State<AddNewChatView> createState() => _AddNewChatViewState();
}

class _AddNewChatViewState extends State<AddNewChatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewChatBloc>().add(InitializeNewChatEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<NewChatBloc>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Users',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<NewChatBloc, NewChatState>(
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
                  if (bloc.userList == null || bloc.userList!.isEmpty) {
                    return Center(
                      child: Text(
                        'No users found',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bloc.userList?.length,
                    itemBuilder: (context, index) {
                      return ChatTile(
                            userModel: bloc.userList?[index],
                            onTap: () {
                              bloc.add(
                                OpenChatEvent(
                                  userId: bloc.userList?[index].id ?? "",
                                  userName:
                                      "${bloc.userList?[index].firstName ?? ""} ${bloc.userList?[index].lastName ?? ""}",
                                  avatar: bloc.userList?[index].avatarUrl ?? "",
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
            ),
          ],
        ),
      ),
    );
  }
}
