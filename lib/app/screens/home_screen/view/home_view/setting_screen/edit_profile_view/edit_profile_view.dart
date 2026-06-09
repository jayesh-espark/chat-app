import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/storage/local_storage.dart';
import '../../../../../../model/user_model.dart';
import '../../../../../../network_calls/services/auth_services.dart';
import '../../../../../../network_calls/services/upload_service.dart';
import '../../profile_screen/profile_bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  
  File? _selectedImage;
  String _currentProfileImageUrl = "";
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await LocalStorageApp().getUser();
      if (user != null) {
        setState(() {
          _nameController.text = user.name;
          _usernameController.text = user.username;
          _emailController.text = user.email;
          _currentProfileImageUrl = user.profileImageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      log("Error loading user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 500,
        maxHeight: 500,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      log("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _showImageSourceActionSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Profile Photo Source',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _buildSourceButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      String profileImageUrl = _currentProfileImageUrl;

      // 1. Upload image if selected
      if (_selectedImage != null) {
        final uploadedUrl = await UploadService().uploadImage(_selectedImage!);
        if (uploadedUrl == null) {
          setState(() {
            _isSaving = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload image. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        profileImageUrl = uploadedUrl;
      }

      // 2. Update profile data on backend
      final name = _nameController.text.trim();
      final response = await AuthServices().updateProfile(name, profileImageUrl);

      setState(() {
        _isSaving = false;
      });

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Notify ProfileBloc to refresh profile screen
        try {
          context.read<ProfileBloc>().add(LoadUserProfileEvent());
        } catch (e) {
          log("Could not find ProfileBloc in context to reload user: $e");
        }

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Animated App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Edit Profile',
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
                    top: 40,
                    left: 130,
                    right: 130,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: colorScheme.surface,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : (_currentProfileImageUrl.isNotEmpty
                                    ? NetworkImage(_currentProfileImageUrl) as ImageProvider
                                    : null),
                            child: _selectedImage == null && _currentProfileImageUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 55,
                                    color: colorScheme.onSurface.withOpacity(0.5),
                                  )
                                : null,
                          ),
                        ).animate().scale(
                              delay: 100.ms,
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: InkWell(
                            onTap: _showImageSourceActionSheet,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Display Name (mapped to name API field)
                    _buildTextField(
                      controller: _nameController,
                      label: 'Display Name',
                      icon: Icons.badge_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your display name';
                        }
                        return null;
                      },
                      delay: 150,
                    ),

                    const SizedBox(height: 16),

                    // Username Field (disabled/read-only or informative)
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person_outline,
                      enabled: false,
                      delay: 250,
                    ),

                    const SizedBox(height: 16),

                    // Email Field (read-only)
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: false,
                      delay: 350,
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 500.ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int delay,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? colorScheme.primary : colorScheme.outline),
        filled: true,
        fillColor: enabled ? colorScheme.surface : colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: -0.2, end: 0, curve: Curves.easeOut);
  }
}
