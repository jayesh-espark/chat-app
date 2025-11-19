import 'package:chating_app/app/app_services/biomatric_services.dart';
import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  bool _biomatricsEnabled = false;
  bool _biomatricsAvailable = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isAvailable = await BiometricAuthService().isBiometricAvailable();
      _biomatricsEnabled = await LocalStorageApp().isAppLocked();
      setState(() {
        _biomatricsAvailable = isAvailable;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // Animated App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
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
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child:
                        Icon(
                          Icons.settings,
                          size: 60,
                          color: Colors.white.withOpacity(0.3),
                        ).animate().scale(
                          delay: 100.ms,
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Settings Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Account Section
                  _buildSectionHeader('Account', delay: 100),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',
                        onTap: () {
                          // Navigate to edit profile
                        },
                        delay: 200,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        subtitle: 'Update your password',
                        onTap: () {
                          // Navigate to change password
                        },
                        delay: 250,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.shield_outlined,
                        title: 'Privacy',
                        subtitle: 'Manage your privacy settings',
                        onTap: () {
                          // Navigate to privacy settings
                        },
                        delay: 300,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notifications Section
                  _buildSectionHeader('Notifications', delay: 350),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.notifications_outlined,
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        delay: 400,
                      ),
                      if (_biomatricsAvailable)
                        _buildSwitchTile(
                          icon: Icons.fingerprint,
                          title: 'Biometric Authentication',
                          subtitle: 'Use fingerprint or face ID',
                          value: _biomatricsEnabled,
                          onChanged: (value) async {
                            setState(() {
                              _biomatricsEnabled = value;
                            });
                            await LocalStorageApp().saveAppLocked(value);
                          },
                          delay: 400,
                        ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.volume_up_outlined,
                        title: 'Sound',
                        subtitle: 'Play sound for notifications',
                        value: _soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            _soundEnabled = value;
                          });
                        },
                        delay: 450,
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.vibration_outlined,
                        title: 'Vibration',
                        subtitle: 'Vibrate for notifications',
                        value: _vibrationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _vibrationEnabled = value;
                          });
                        },
                        delay: 500,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Appearance Section
                  _buildSectionHeader('Appearance', delay: 550),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Enable dark theme',
                        value: _darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                        },
                        delay: 600,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.language_outlined,
                        title: 'Language',
                        subtitle: _selectedLanguage,
                        onTap: () {
                          _showLanguageDialog();
                        },
                        delay: 650,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // More Section
                  _buildSectionHeader('More', delay: 700),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get help and support',
                        onTap: () {
                          // Navigate to help
                        },
                        delay: 750,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'App version and information',
                        onTap: () {
                          // Show about dialog
                        },
                        delay: 800,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        subtitle: 'Read our terms',
                        onTap: () {
                          // Navigate to terms
                        },
                        delay: 850,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.policy_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: () {
                          // Navigate to privacy policy
                        },
                        delay: 900,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Danger Zone
                  _buildSectionHeader(
                    'Danger Zone',
                    delay: 950,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.delete_outline,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                        iconColor: Colors.red,
                        titleColor: Colors.red,
                        delay: 1000,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // App Version
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ).animate().fadeIn(delay: 1100.ms, duration: 500.ms),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required int delay, Color? color}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color ?? colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: -0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required int delay,
    Color? iconColor,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: titleColor ?? colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required int delay,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: colorScheme.primary,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _buildDivider() {
    final colorScheme = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: colorScheme.outline.withOpacity(0.1),
    );
  }

  void _showLanguageDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('Spanish'),
            _buildLanguageOption('French'),
            _buildLanguageOption('German'),
            _buildLanguageOption('Hindi'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final colorScheme = Theme.of(context).colorScheme;
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _selectedLanguage,
      activeColor: colorScheme.primary,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
