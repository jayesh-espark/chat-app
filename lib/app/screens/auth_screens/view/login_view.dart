import 'package:chating_app/app/core/utills/app_images.dart';
import 'package:chating_app/app/core/utills/navigation_utils.dart';
import 'package:chating_app/app/core/utills/snackbar.dart';
import 'package:chating_app/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../core/utills/common_functions.dart';
import '../../../core/widgets/common_lottie_container.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoadingState) {
            context.loaderOverlay.show();
          }
          if (state is LoginSuccessState) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.loaderOverlay.hide();
                showAppSnackBar(context, message: "Logged In SuccessFully");
                navigateToNamedKillAll(context, AppRoutes.homeScreen);
              }
            });
          }
          if (state is LoginErrorOccurredState) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.loaderOverlay.hide();
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackType.error,
                );
              }
            });
          }
        },
        child: GestureDetector(
          onTap: () => removeFocus(context),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo or Icon (Optional)
                    CommonLottieContainer(
                      assetName: AppImages.welcomeLottie,
                      fromNetwork: false,
                      animate: true,
                      size: 250,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Welcome Back",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 48),

                    CustomTextField(
                      controller: emailController,
                      label: "Email",
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: passwordController,
                      label: "Password",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          removeFocus(context);
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          foregroundColor: colorScheme.primary,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Sign In",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider with text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: colorScheme.onPrimary.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: colorScheme.onPrimary.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    TextButton(
                      onPressed: () =>
                          navigateToNamed(context, AppRoutes.signUpScreen),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.9),
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
