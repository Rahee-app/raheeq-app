import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_avatar.dart';
import '../services/haptic_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late Gender _selectedGender;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.userName);
    _selectedGender = authProvider.gender == Gender.unspecified ? Gender.male : authProvider.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(AppStrings.editProfileAr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Live Avatar Preview
              ProfileAvatar(
                gender: _selectedGender,
                radius: 44,
              ),

              const SizedBox(height: 28),

              // Name Input Field
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.nameAr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Gender Selection
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'رمز وأيقونة الملف الشخصي',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Male
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedGender = Gender.male);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedGender == Gender.male
                              ? AppColors.maleAvatar.withOpacity(0.15)
                              : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedGender == Gender.male
                                ? AppColors.maleAvatar
                                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                            width: _selectedGender == Gender.male ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: AppColors.maleAvatar,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              AppStrings.maleAr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Female
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedGender = Gender.female);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedGender == Gender.female
                              ? AppColors.femaleAvatar.withOpacity(0.15)
                              : (isDark ? AppColors.darkCard : AppColors.lightSurface),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedGender == Gender.female
                                ? AppColors.femaleAvatar
                                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                            width: _selectedGender == Gender.female ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: AppColors.femaleAvatar,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              AppStrings.femaleAr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Save Button
              CustomButton(
                text: AppStrings.saveAr,
                onPressed: () async {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    await authProvider.updateProfile(
                      name: name,
                      gender: _selectedGender,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
