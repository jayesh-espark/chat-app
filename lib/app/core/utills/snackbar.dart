import 'package:flutter/material.dart';

enum SnackType { success, error }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackType type = SnackType.success,
  Duration duration = const Duration(seconds: 3),
}) {
  final colorScheme = Theme.of(context).colorScheme;

  // choose background based on type
  final backgroundColor = switch (type) {
    SnackType.success => Colors.green,
    SnackType.error => Colors.red,
  };

  final icon = switch (type) {
    SnackType.success => Icons.check_circle,
    SnackType.error => Icons.error,
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // prevent overlap
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      duration: duration,
      content: Row(
        children: [
          Icon(icon, color: colorScheme.onPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    ),
  );
}
