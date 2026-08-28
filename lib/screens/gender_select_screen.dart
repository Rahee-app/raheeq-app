import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_avatar.dart';
import '../services/haptic_service.dart';
import 'main_navigation_screen.dart';

class GenderSelectScreen extends StatefulWidget {
  const GenderSelectScreen({super.key});

  @override
  State<GenderSelectScreen> createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  Gender _selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Title
              Text(
                'أهلاً بك يا ${authProvider.userName} 🌸',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'اختر لون أيقونة ملفك الشخصي الرمزية:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Live Avatar Preview
              ProfileAvatar(
                gender: _selectedGender,
                radius: 46,
              ),

              const SizedBox(height: 36),

              // Option 1: Male (Blue)
              GestureDetector(
                onTap: () {
                  HapticService.selection();
                  setState(() => _selectedGender = Gender.male);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGender == Gender.male
                        ? AppColors.maleAvatar.withOpacity(0.12)
                        : (isDark ? AppColors.darkCard : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGender == Gender.male
                          ? AppColors.maleAvatar
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: _selectedGender == Gender.male ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.maleAvatar,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.maleAr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'أيقونة بروفايل زرقاء هادئة 👤',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedGender == Gender.male)
                        const Icon(Icons.check_circle_rounded, color: AppColors.maleAvatar, size: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Option 2: Female (Pink)
              GestureDetector(
                onTap: () {
                  HapticService.selection();
                  setState(() => _selectedGender = Gender.female);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedGender == Gender.female
                        ? AppColors.femaleAvatar.withOpacity(0.12)
                        : (isDark ? AppColors.darkCard : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGender == Gender.female
                          ? AppColors.femaleAvatar
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: _selectedGender == Gender.female ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.femaleAvatar,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.femaleAr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'أيقونة بروفايل وردية هادئة 👤',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedGender == Gender.female)
                        const Icon(Icons.check_circle_rounded, color: AppColors.femaleAvatar, size: 24),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Continue Button
              CustomButton(
                text: 'ابدأ يومك ببركة',
                onPressed: () async {
                  await authProvider.updateGender(_selectedGender);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    );
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
