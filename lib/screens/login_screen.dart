import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/privacy_dialog.dart';
import '../widgets/custom_button.dart';
import 'gender_select_screen.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Centered App Logo
              Image.asset(
                isDark ? AppAssets.logo3 : AppAssets.logo1,
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              // Title & Subtitle
              Text(
                AppStrings.appNameAr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'واجهتك الهادئة لتنظيم عبادتك وأذكارك اليومية بصفاء تام',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),

              const Spacer(flex: 3),

              // Google Sign-In Button
              CustomButton(
                text: AppStrings.loginWithGoogleAr,
                isLoading: authProvider.isLoading,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.g_mobiledata_rounded,
                    color: Color(0xFF4285F4),
                    size: 24,
                  ),
                ),
                onPressed: () async {
                  final success = await authProvider.signInWithGoogle();
                  if (success && context.mounted) {
                    if (authProvider.isFirstTimeLogin) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const GenderSelectScreen()),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: 20),

              // Legal & Reassuring Privacy Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'تطبيق آمن بالكامل وبدون أي أذونات حساسة',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Privacy Policy Dialog Trigger Link
              GestureDetector(
                onTap: () => PrivacyDialog.show(context),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    'عرض تفاصيل سياسة الخصوصية التامة',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.accentLime : AppColors.primaryGreen,
                      decoration: TextDecoration.underline,
                      decorationColor: isDark ? AppColors.accentLime : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
