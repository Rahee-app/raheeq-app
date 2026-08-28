import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../constants/app_colors.dart';

class DailyProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double percentage;
  final bool isAllCompleted;

  const DailyProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.percentage,
    required this.isAllCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAllCompleted
              ? AppColors.primaryGreen.withOpacity(0.5)
              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
          width: isAllCompleted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 8.0,
            percent: percentage.clamp(0.0, 1.0),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.primaryGreen.withOpacity(0.08),
            progressColor: isAllCompleted ? AppColors.accentLime : AppColors.primaryGreen,
            center: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(width: 18),

          // Text & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإنجاز اليومي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAllCompleted
                            ? AppColors.primaryGreen
                            : (isDark
                                ? AppColors.darkSurface
                                : AppColors.primaryGreen.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$completed من $total',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isAllCompleted
                              ? Colors.white
                              : (isDark ? AppColors.accentLime : AppColors.primaryGreen),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isAllCompleted
                      ? 'ما شاء الله! اكتملت جميع مهام اليوم بنجاح ✨'
                      : 'واصل ببركة وهدوء لإتمام وردك اليومي',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 6.0,
                  percent: percentage.clamp(0.0, 1.0),
                  barRadius: const Radius.circular(3),
                  backgroundColor: isDark
                      ? AppColors.darkBackground
                      : AppColors.primaryGreen.withOpacity(0.08),
                  progressColor: isAllCompleted ? AppColors.accentLime : AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
