import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/progress_ring.dart';
import '../widgets/task_card.dart';
import '../widgets/profile_avatar.dart';
import '../services/haptic_service.dart';
import 'adhkar_screen.dart';
import 'tasbeeh_timer_screen.dart';
import 'edit_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar / Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // App Logo (Horizontal)
                    Image.asset(
                      isDark ? AppAssets.logo4 : AppAssets.logo2,
                      height: 38,
                      fit: BoxFit.contain,
                    ),

                    // Greeting and User Avatar
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppStrings.greetingAr}${authProvider.userName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'طاب يومك بذكر الله',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        ProfileAvatar(
                          gender: authProvider.gender,
                          radius: 20,
                          onTap: () {
                            HapticService.selection();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Daily Progress Card
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: DailyProgressCard(
                  completed: taskProvider.completedCount,
                  total: taskProvider.totalCount,
                  percentage: taskProvider.progressPercentage,
                  isAllCompleted: taskProvider.isAllCompleted,
                ),
              ),
            ),

            // Completion Celebration Banner if just completed
            if (taskProvider.isAllCompleted)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.primaryGreen, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'مبارك إتمام جميع مهام اليوم! تم حفظ الإنجاز في سجلك وسيعود النظام للتصفير تلقائياً.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Section Title
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الورد والعبادات اليومية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'مرتبة زمنياً',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 8 Chronological Daily Tasks
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = taskProvider.tasks[index];
                    return TaskCard(
                      task: task,
                      onToggle: () => taskProvider.toggleTask(task.id),
                      onNavigate: () {
                        if (task.id == 'morning_adhkar') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AdhkarScreen(initialTabIndex: 0),
                            ),
                          );
                        } else if (task.id == 'tasbeeh_minute') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TasbeehTimerScreen(),
                            ),
                          );
                        }
                      },
                    );
                  },
                  childCount: taskProvider.tasks.length,
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
