import 'dart:io';

import 'package:chating_app/app/core/utills/navigation_utils.dart';
import 'package:chating_app/app/network_calls/services/auth_services.dart';
import 'package:chating_app/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Text("Exit App?", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to exit the application?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style!,
                      onPressed: () => exit(0),
                      child: const Text("Exit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        // 👇 animate the dialog appearance
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Text("Log Out?", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to Log out from the application?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style!,
                      onPressed: () async {
                        await AuthServices().logout();
                        if (context.mounted) {
                          navigateToNamedKillAll(
                            context,
                            AppRoutes.loginScreen,
                          );
                        }
                      },
                      child: const Text("Log Out"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        // 👇 animate the dialog appearance
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}
