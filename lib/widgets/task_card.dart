import 'package:flutter/material.dart';
import '../models/task_item.dart';
import '../constants/app_colors.dart';
import '../services/haptic_service.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback? onNavigate;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    this.onNavigate,
  });

  IconData _getIconForType(TaskType type) {
    switch (type) {
      case TaskType.prayer:
        return Icons.access_time_rounded;
      case TaskType.quran:
        return Icons.auto_stories_rounded;
      case TaskType.morningAdhkar:
        return Icons.wb_sunny_outlined;
      case TaskType.tasbeeh:
        return Icons.timer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = task.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? (isDark
                ? AppColors.primaryGreenDark.withOpacity(0.3)
                : AppColors.primaryGreen.withOpacity(0.06))
            : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.primaryGreen.withOpacity(0.4)
              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (task.actionRoute != null && onNavigate != null && !isCompleted) {
              onNavigate!();
            } else {
              onToggle();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Custom Checkbox
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
                const SizedBox(width: 14),

                // Icon Badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primaryGreen.withOpacity(0.15)
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.primaryGreen.withOpacity(0.08)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconForType(task.type),
                    size: 20,
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : (isDark ? AppColors.accentLime : AppColors.primaryGreen),
                  ),
                ),
                const SizedBox(width: 14),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w700,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          color: isCompleted
                              ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                      if (task.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          task.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing Action Arrow if navigation exists
                if (task.actionRoute != null && !isCompleted)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    onPressed: onNavigate,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
