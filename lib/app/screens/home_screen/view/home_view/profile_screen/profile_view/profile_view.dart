import 'package:chating_app/app/core/widgets/exit_dialog.dart';
import 'package:chating_app/app/screens/home_screen/view/home_view/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(LoadUserProfileEvent());
    });
  }

  String _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return '';
    try {
      final now = DateTime.now();
      int age = now.year - dateOfBirth.year;
      if (now.month < dateOfBirth.month ||
          (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return '';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    try {
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  String _formatBirthday(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return '';
    try {
      return DateFormat('MMM dd').format(dateOfBirth);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bloc = context.read<ProfileBloc>();

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutUserState) {
            showDialog(
              context: context,
              builder: (builder) {
                return LogOutDialog();
              },
            );
          }
        },
        builder: (context, state) {
          // Get user data from bloc
          final userModel = bloc.userModel;
          final age = _calculateAge(userModel?.dateOfBirth);
          final birthday = _formatBirthday(userModel?.dateOfBirth);
          final joinDate = _formatDate(userModel?.createdAt);
          final email = userModel?.email ?? '';
          final firstName = userModel?.firstName ?? '';
          final lastName = userModel?.lastName ?? '';

          return CustomScrollView(
            slivers: [
              // Animated App Bar with gradient
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient Background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                              colorScheme.tertiary,
                            ],
                          ),
                        ),
                      ),
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Profile Avatar
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: bloc.avatar.isEmpty
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundColor: colorScheme.surface,
                                      child: Icon(
                                        Icons.person,
                                        color: colorScheme.onSurface,
                                        size: 70,
                                      ),
                                    )
                                  : ClipOval(
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: colorScheme.surface,
                                        child: Image.asset(
                                          bloc.avatar,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ).animate().scale(
                              delay: 200.ms,
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Name with animation
                    Text(
                          '${firstName} ${lastName}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                    const SizedBox(height: 8),

                    // Email with icon
                    if (email.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Info Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Age Card
                          if (age.isNotEmpty)
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                icon: Icons.cake_outlined,
                                label: 'Age',
                                value: age,
                                color: colorScheme.primary,
                                delay: 500,
                              ),
                            ),
                          if (age.isNotEmpty && birthday.isNotEmpty)
                            const SizedBox(width: 12),
                          // Birthday Card
                          if (birthday.isNotEmpty)
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                icon: Icons.celebration_outlined,
                                label: 'Birthday',
                                value: birthday,
                                color: colorScheme.secondary,
                                delay: 600,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Member Since Card
                    if (joinDate.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildFullWidthCard(
                          context,
                          icon: Icons.person_add_outlined,
                          label: 'Member Since',
                          value: joinDate,
                          delay: 700,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.edit_outlined,
                            label: 'Edit Profile',
                            onTap: () {
                              // Add edit profile action
                            },
                            delay: 800,
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            context,
                            icon: Icons.settings_outlined,
                            label: 'Settings',
                            onTap: () {
                              // Add settings action
                            },
                            delay: 900,
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            context,
                            icon: Icons.help_outline,
                            label: 'Help & Support',
                            onTap: () {
                              // Add help action
                            },
                            delay: 1000,
                          ),
                          const SizedBox(height: 12),

                          _buildActionButton(
                            context,
                            icon: Icons.logout,
                            label: 'Log Out',
                            onTap: () {
                              bloc.add(LogoutUserEvent());
                            },
                            delay: 900,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required int delay,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          curve: Curves.easeOut,
        );
  }

  Widget _buildFullWidthCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required int delay,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colorScheme.tertiary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: -0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int delay,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.onSurface, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
