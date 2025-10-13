import 'package:chating_app/app/core/utills/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utills/app_strings.dart';
import '../../../core/utills/navigation_utils.dart';
import '../../../core/widgets/common_svg_container.dart';
import '../../../router/app_routes.dart';
import '../bloc/splash/splash_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is NavigateToHomeState) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (context.mounted) {
              navigateToNamedKillAll(context, AppRoutes.homeScreen);
            }
          });
        } else if (state is NavigateToLoginState) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (context.mounted) {
              navigateToNamedKillAll(context, AppRoutes.loginScreen);
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated SVG Container
              CommonSvgContainer(
                    assetName: AppImages.splashIcon,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderRadius: 12,
                  )
                  .animate(
                    onComplete: (controller) {
                      if (context.mounted) {
                        // Trigger BLoC event to navigate to home
                        context.read<SplashBloc>().add(NavigateToHomeEvent());
                      }
                    },
                  )
                  .scale(
                    duration: 2000.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1.0, 1.0),
                  )
                  .fadeIn(duration: 1800.ms, curve: Curves.easeOut)
                  .slideY(
                    duration: 2200.ms,
                    begin: -0.5,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  ),

              // Animated Title Text
              Text(
                    AppStrings.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate(
                    delay: 1200.ms,
                  ) // Longer delay for more visible stagger
                  .fadeIn(duration: 2000.ms, curve: Curves.easeOut)
                  .slideY(
                    duration: 1800.ms,
                    begin: 0.8,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  ) // Permanent shimmer
                  .shimmer(
                    duration: 2500.ms,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.4),
                    colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
              Text(
                    AppStrings.appDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  .animate(delay: 2000.ms)
                  .fadeIn(duration: 1800.ms, curve: Curves.easeOut)
                  .slideY(
                    duration: 1800.ms,
                    begin: 0.5,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
