import 'package:flutter/material.dart';
import '../models/dhikr_item.dart';
import '../constants/app_colors.dart';
import '../services/haptic_service.dart';

class DhikrCard extends StatelessWidget {
  final DhikrItem item;
  final VoidCallback onIncrement;
  final VoidCallback onToggle;

  const DhikrCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = item.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDark
                ? AppColors.primaryGreenDark.withOpacity(0.35)
                : AppColors.primaryGreen.withOpacity(0.06))
            : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted
              ? AppColors.primaryGreen.withOpacity(0.5)
              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            HapticService.light();
            onIncrement();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar: Checkbox, Target Badge, Counter Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Interactive Checkbox
                    GestureDetector(
                      onTap: () {
                        HapticService.light();
                        onToggle();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColors.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.primaryGreen
                                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            width: 1.8,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),

                    // Target Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.countText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.accentLime : AppColors.primaryGreen,
                        ),
                      ),
                    ),

                    // Counter Pill / Tap Button
                    InkWell(
                      onTap: () {
                        HapticService.light();
                        onIncrement();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primaryGreen
                              : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.accentLime.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.primaryGreen
                                : (isDark
                                    ? AppColors.accentLime.withOpacity(0.5)
                                    : AppColors.primaryGreen.withOpacity(0.2)),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted ? Icons.check_circle : Icons.touch_app_outlined,
                              size: 14,
                              color: isCompleted
                                  ? Colors.white
                                  : (isDark ? AppColors.accentLime : AppColors.primaryGreenDark),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item.currentCount} / ${item.targetCount}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? Colors.white
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Dhikr Arabic Text (Exclusively Arabic)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                      color: isCompleted
                          ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
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
