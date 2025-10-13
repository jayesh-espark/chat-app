import 'package:chating_app/app/core/utills/app_strings.dart';
import 'package:chating_app/app/core/utills/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../core/utills/common_functions.dart';
import '../../../core/utills/navigation_utils.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../router/app_routes.dart';
import '../bloc/auth_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () => removeFocus(context),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is LoadingState) {
              context.loaderOverlay.show();
            }
            if (state is SignUpSuccessState) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  context.loaderOverlay.hide();
                  showAppSnackBar(context, message: "Sign Up SuccessFully");
                  navigateToNamedKillAll(context, AppRoutes.homeScreen);
                }
              });
            }
            if (state is SignUpErrorOccurredState) {
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

            var bloc = context.read<AuthBloc>();
            if (state is AuthAction) {
              if (state.isBirthDate) {
                final now = DateTime.now();
                final eighteenYearsAgo = DateTime(
                  now.year - 18,
                  now.month,
                  now.day,
                );

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: eighteenYearsAgo,
                  firstDate: DateTime(1900),
                  lastDate: eighteenYearsAgo,
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(colorScheme: colorScheme),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  bloc.add(BirthDateSelectedEvent(dateTime: picked));
                } else {
                  if (context.mounted) {
                    showAppSnackBar(
                      context,
                      message: AppStrings.selectDateOfBirth,
                    );
                  }
                }
              } else {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AvatarSelectionDialog(
                    onAvatarSelected: (String avatarPath) {
                      context.read<AuthBloc>().add(
                        AvatarSelectedEvent(avatarPath),
                      );
                      Navigator.pop(dialogContext);
                    },
                    signUpContext: context,
                  ),
                );
              }
            }
          },
          buildWhen: (_, current) {
            return current is! AuthAction;
          },
          builder: (context, state) {
            var bloc = context.read<AuthBloc>();
            return Container(
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
                    children: [
                      Text(
                        AppStrings.createAccount,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Avatar Selection
                      GestureDetector(
                        onTap: () => bloc.add(AvatarSelectionEvent()),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surface.withOpacity(0.3),
                                border: Border.all(
                                  color: colorScheme.onPrimary,
                                  width: 3,
                                ),
                              ),
                              child: bloc.avatar != null
                                  ? ClipOval(
                                      child: Image.asset(
                                        bloc.avatar!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_add,
                                      size: 50,
                                      color: colorScheme.onPrimary,
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bloc.avatar != null
                                  ? "Tap to change avatar"
                                  : "Tap to select avatar",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _firstNameController,
                        label: "First Name",
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _lastNameController,
                        label: "Last Name (Optional)",
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emailController,
                        label: "Email",
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => bloc.add(BirthDateSelectionEvent()),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surface.withOpacity(0.2),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                bloc.selectedDate == null
                                    ? "Select Date of Birth"
                                    : "${bloc.selectedDate?.day}/${bloc.selectedDate?.month}/${bloc.selectedDate?.year}",
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (bloc.selectedDate == null) {
                              showAppSnackBar(
                                context,
                                message: AppStrings.selectDateOfBirthRequest,
                                type: SnackType.error,
                              );
                              return;
                            }
                            removeFocus(context);
                            bloc.add(
                              SignupRequested(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                dateOfBirth: bloc.selectedDate!,
                                avatar: bloc.avatar,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surface,
                            foregroundColor: colorScheme.primary,
                            elevation: 4,
                          ),
                          child: Text(
                            "Sign Up",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: Text(
                          AppStrings.alreadyHaveAnAccount,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Avatar Selection Dialog
class AvatarSelectionDialog extends StatelessWidget {
  final Function(String) onAvatarSelected;
  final BuildContext signUpContext;

  const AvatarSelectionDialog({
    super.key,
    required this.onAvatarSelected,
    required this.signUpContext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    var bloc = signUpContext.read<AuthBloc>();
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: bloc,
          builder: (context, state) {
            String selectedCategory = bloc.selectedCategory;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Avatar',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Tabs
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: bloc.avatarCategories.keys.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            // setState(() {
                            selectedCategory = category;
                            bloc.add(ChangeAvatarCategoryEvent(category));
                            // });
                          },
                          selectedColor: colorScheme.primary,
                          backgroundColor: colorScheme.surface,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Avatar Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount:
                        bloc.avatarCategories[selectedCategory]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final avatarPath =
                          bloc.avatarCategories[selectedCategory]![index];
                      return GestureDetector(
                        onTap: () => onAvatarSelected(avatarPath),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.3),
                              width: 2,
                            ),
                            color: colorScheme.surface,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              avatarPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
