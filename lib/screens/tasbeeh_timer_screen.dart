import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/timer_provider.dart';
import '../providers/task_provider.dart';
import '../services/haptic_service.dart';

class TasbeehTimerScreen extends StatelessWidget {
  const TasbeehTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timerProvider = Provider.of<TimerProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(AppStrings.tasbeehTitleAr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'إعادة العداد',
            onPressed: () => timerProvider.resetTimer(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Dhikr Selector Chips Carousel
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: timerProvider.adhkarPhrases.length,
                itemBuilder: (context, index) {
                  final phrase = timerProvider.adhkarPhrases[index];
                  final isSelected = phrase == timerProvider.currentPhrase;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        phrase,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          timerProvider.selectPhrase(index);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Active Selected Dhikr Text Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    timerProvider.currentPhrase,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'دقيقة هادئة من الذكر والاستغفار',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Big Comfortable Tactile Touch Zone with Circular Progress & Countdown
            GestureDetector(
              onTap: () {
                timerProvider.incrementTap();
                if (timerProvider.isCompleted) {
                  taskProvider.markTaskCompleted('tasbeeh_minute');
                }
              },
              child: CircularPercentIndicator(
                radius: 130.0,
                lineWidth: 12.0,
                percent: timerProvider.progress.clamp(0.0, 1.0),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.primaryGreen.withOpacity(0.1),
                progressColor: timerProvider.isCompleted
                    ? AppColors.accentLime
                    : AppColors.primaryGreen,
                center: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(isDark ? 0.25 : 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: timerProvider.isRunning
                          ? AppColors.primaryGreen.withOpacity(0.6)
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Countdown Seconds
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 18,
                            color: isDark ? AppColors.accentLime : AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '00:${timerProvider.remainingSeconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.accentLime : AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Large Tap Counter
                      Text(
                        '${timerProvider.counter}',
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تسبيحة',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Bottom Instructions & Timer Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    timerProvider.isCompleted
                        ? '✨ تقبل الله طاعتك! تم إنجاز دقيقة التسبيح.'
                        : (timerProvider.isRunning
                            ? 'المس الدائرة مع كل تسبيحة بهدوء'
                            : 'المس الدائرة لبدء العد والدقيقة'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: timerProvider.isCompleted
                          ? AppColors.primaryGreen
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Timer Control Buttons (Start / Pause / Reset)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (timerProvider.state == TimerState.idle)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                          label: const Text('ابدأ الدقيقة', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            timerProvider.startTimer(
                              onComplete: () => taskProvider.markTaskCompleted('tasbeeh_minute'),
                            );
                          },
                        ),
                      if (timerProvider.state == TimerState.running)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.pause_rounded),
                          label: const Text('إيقاف مؤقت'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => timerProvider.pauseTimer(),
                        ),
                      if (timerProvider.state == TimerState.paused) ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                          label: const Text('استئناف', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            timerProvider.startTimer(
                              onComplete: () => taskProvider.markTaskCompleted('tasbeeh_minute'),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('إعادة'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => timerProvider.resetTimer(),
                        ),
                      ],
                      if (timerProvider.state == TimerState.completed)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          label: const Text('دقيقة أخرى', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => timerProvider.resetTimer(),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
