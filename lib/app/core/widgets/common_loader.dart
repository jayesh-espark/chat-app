import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utills/app_images.dart';
import 'common_svg_container.dart';

class CommonLoaderScreen extends StatelessWidget {
  const CommonLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonSvgContainer(
                  assetName: AppImages.splashIcon,
                  size: 80,
                  color: colorScheme.onPrimary,
                  backgroundColor: Color(0xFF1D4E89),
                  borderRadius: 12,
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  duration: 1200.ms,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  curve: Curves.easeInOut,
                )
                .fadeIn(duration: 800.ms),
            Text(
              "Loading...",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 1200.ms),
          ],
        ),
      ),
    );
  }
}
