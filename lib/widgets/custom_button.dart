import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/haptic_service.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isOutlined;
  final bool isSecondary;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isSecondary = false,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    if (isOutlined) {
      bgColor = Colors.transparent;
      textColor = isDark ? AppColors.accentLime : AppColors.primaryGreen;
      borderSide = BorderSide(color: textColor, width: 1.5);
    } else if (isSecondary) {
      bgColor = isDark ? AppColors.darkCard : AppColors.lightCardBorder;
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else {
      bgColor = AppColors.primaryGreen;
      textColor = Colors.white;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading || onPressed == null
              ? null
              : () {
                  HapticService.light();
                  onPressed!();
                },
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 10),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
