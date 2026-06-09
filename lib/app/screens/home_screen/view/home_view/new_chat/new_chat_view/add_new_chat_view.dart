import 'package:chating_app/app/core/utills/navigation_utils.dart';
import 'package:chating_app/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../widgets/chat_widget.dart';
import '../../profile_screen/profile_view/profile_view.dart';
import '../new_chat_bloc/new_chat_bloc.dart';

class AddNewChatView extends StatefulWidget {
  const AddNewChatView({super.key});

  @override
  State<AddNewChatView> createState() => _AddNewChatViewState();
}

class _AddNewChatViewState extends State<AddNewChatView> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewChatBloc>().add(InitializeNewChatEvent());
    });
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  void _onCreateRoom() {
    final name = _roomNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a room name')),
      );
      return;
    }
    context.read<NewChatBloc>().add(CreateRoomEvent(name));
    _roomNameController.clear();
  }

  void _onJoinRoom() {
    final idStr = _roomIdController.text.trim();
    final roomId = int.tryParse(idStr);
    if (roomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric Room ID')),
      );
      return;
    }
    _roomIdController.clear();
    navigateToNamed(
      context,
      AppRoutes.chatBubbleScreen,
      arguments: {
        "roomId": roomId,
        "roomName": "Room $roomId",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bloc = context.read<NewChatBloc>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Join / Create Room',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<NewChatBloc, NewChatState>(
        listener: (context, state) {
          if (state is NoAction) {
            if (state.isLoading == false) {
              context.loaderOverlay.hide();
            } else {
              context.loaderOverlay.show();
            }
          }

          if (state is OpenChatState) {
            navigateToNamed(
              context,
              AppRoutes.chatBubbleScreen,
              arguments: {
                "roomId": state.roomId,
                "roomName": state.roomName,
              },
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Create Room Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.surface.withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a New Room',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _roomNameController,
                          decoration: const InputDecoration(
                            labelText: 'Room Name',
                            hintText: 'e.g. Flutter Developers',
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Create Room'),
                            onPressed: _onCreateRoom,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 20),

                // 2. Join Room by ID Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.surface.withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join Room by ID',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _roomIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Room ID',
                            hintText: 'e.g. 1',
                            prefixIcon: Icon(Icons.tag),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text('Join Room'),
                            onPressed: _onJoinRoom,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // 3. User Directory list
                Text(
                  'Available Users',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                const SizedBox(height: 10),

                if (bloc.userList == null || bloc.userList!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No other users registered',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bloc.userList?.length,
                    itemBuilder: (context, index) {
                      final user = bloc.userList![index];
                      return ChatTile(
                        userModel: user,
                        onTap: () {
                          navigateTo(context, ProfileView(otherUser: user));
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                      .slideY(begin: 0.1, end: 0);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
