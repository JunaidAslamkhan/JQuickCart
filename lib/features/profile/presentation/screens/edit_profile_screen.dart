import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isProfileLoaded = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillProfileData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    if (_isProfileLoaded) return;

    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _emailController.text = email;
    _phoneController.text = phone;

    _isProfileLoaded = true;
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSizes.md),
      ),
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Image', style: AppTextStyles.headingSmall),
              const SizedBox(height: AppSizes.md),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                ),
                title: Text('Take Photo', style: AppTextStyles.bodyMedium),
                onTap: () async {
                  Navigator.pop(context);

                  final image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );

                  if (image != null && mounted) {
                    setState(() => _selectedImage = File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );

                  if (image != null && mounted) {
                    setState(() => _selectedImage = File(image.path));
                  }
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: AppColors.error,
                  ),
                  title: Text(
                    'Remove Photo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _showSnackBar(
        message: 'Session expired. Please login again.',
        backgroundColor: AppColors.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();

      final firestoreService = ref.read(profileFirestoreServiceProvider);

      await firestoreService.updateUserProfile(
        uid: firebaseUser.uid,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'fullName': '$firstName $lastName',
          'phone': phone,
        },
      );

      ref.invalidate(currentUserProfileProvider);

      if (!mounted) return;

      _showSnackBar(
        message: 'Profile updated successfully.',
        backgroundColor: AppColors.success,
      );

      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showSnackBar(
        message: 'Failed to update profile. Please try again.',
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw >= 600;
    final hp = isTablet ? sw * 0.08 : AppSizes.screenPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: profileAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Text(
                'Failed to load profile. Please try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          );
        },
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Text(
                  'No profile found. Please login again.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            );
          }

          _fillProfileData(
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            phone: profile.phone,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: hp,
              vertical: AppSizes.lg,
            ),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _isLoading ? null : _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: AppSizes.avatarXl,
                            height: AppSizes.avatarXl,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: AppSizes.avatarXl,
                                      height: AppSizes.avatarXl,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hintText: 'First Name',
                          controller: _firstNameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: AppTextField(
                          hintText: 'Last Name',
                          controller: _lastNameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  AbsorbPointer(
                    child: AppTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(
                        Icons.alternate_email,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email cannot be changed from here.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppTextField(
                    hintText: 'Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AppButton(
                    label: 'Save Changes',
                    onPressed: _isLoading ? null : _onSavePressed,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppSizes.md),
                  TextButton(
                    onPressed: _isLoading ? null : () {},
                    child: Text(
                      'Close Account',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
