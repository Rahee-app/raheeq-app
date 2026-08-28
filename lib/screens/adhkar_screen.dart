import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/adhkar_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/dhikr_card.dart';
import '../services/haptic_service.dart';

class AdhkarScreen extends StatefulWidget {
  final int initialTabIndex;

  const AdhkarScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticService.selection();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adhkarProvider = Provider.of<AdhkarProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(AppStrings.adhkarTitleAr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            tooltip: 'إعادة ضبط الأذكار',
            onPressed: () {
              HapticService.selection();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  title: const Text('إعادة ضبط الأذكار'),
                  content: Text(
                    _tabController.index == 0
                        ? 'هل تريد تصفير عداد أذكار الصباح؟'
                        : 'هل تريد تصفير عداد أذكار المساء؟',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                      onPressed: () {
                        if (_tabController.index == 0) {
                          adhkarProvider.resetMorningAdhkar();
                        } else {
                          adhkarProvider.resetEveningAdhkar();
                        }
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('تصفير', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightCardBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wb_sunny_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text('أذكار الصباح (${adhkarProvider.morningCompletedCount}/${adhkarProvider.morningTotalCount})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.nights_stay_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text('أذكار المساء (${adhkarProvider.eveningCompletedCount}/${adhkarProvider.eveningTotalCount})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Morning Adhkar List
          _buildAdhkarList(
            context: context,
            items: adhkarProvider.morningAdhkar,
            isMorning: true,
            completedCount: adhkarProvider.morningCompletedCount,
            totalCount: adhkarProvider.morningTotalCount,
            progress: adhkarProvider.morningProgress,
            onIncrement: (id) async {
              await adhkarProvider.incrementMorningDhikr(id);
              if (adhkarProvider.isMorningAllCompleted) {
                await taskProvider.markTaskCompleted('morning_adhkar');
              }
            },
            onToggle: (id) async {
              await adhkarProvider.toggleMorningDhikr(id);
              if (adhkarProvider.isMorningAllCompleted) {
                await taskProvider.markTaskCompleted('morning_adhkar');
              }
            },
          ),

          // Evening Adhkar List
          _buildAdhkarList(
            context: context,
            items: adhkarProvider.eveningAdhkar,
            isMorning: false,
            completedCount: adhkarProvider.eveningCompletedCount,
            totalCount: adhkarProvider.eveningTotalCount,
            progress: adhkarProvider.eveningProgress,
            onIncrement: (id) => adhkarProvider.incrementEveningDhikr(id),
            onToggle: (id) => adhkarProvider.toggleEveningDhikr(id),
          ),
        ],
      ),
    );
  }

  Widget _buildAdhkarList({
    required BuildContext context,
    required List<dynamic> items,
    required bool isMorning,
    required int completedCount,
    required int totalCount,
    required double progress,
    required Function(String) onIncrement,
    required Function(String) onToggle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAllDone = completedCount == totalCount && totalCount > 0;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      children: [
        // Progress Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isAllDone
                ? AppColors.primaryGreen.withOpacity(0.15)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isAllDone
                  ? AppColors.primaryGreen
                  : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isAllDone ? Icons.verified_rounded : (isMorning ? Icons.wb_sunny_rounded : Icons.bedtime_rounded),
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAllDone
                          ? 'أتممت جميع ${isMorning ? "أذكار الصباح" : "أذكار المساء"} بحمد الله ✨'
                          : 'إنجاز القراءة: $completedCount من أصل $totalCount',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightDivider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isAllDone ? AppColors.accentLime : AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dhikr Items
        ...items.map(
          (item) => DhikrCard(
            item: item,
            onIncrement: () => onIncrement(item.id),
            onToggle: () => onToggle(item.id),
          ),
        ),
      ],
    );
  }
}
