import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import '../models/history_entry.dart';
import '../services/storage_service.dart';
import '../services/haptic_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService;

  List<TaskItem> _tasks = [];
  String _currentDateKey = '';
  int _currentStreak = 0;
  List<HistoryEntry> _historyEntries = [];
  bool _justCompletedAllTasks = false;

  TaskProvider(this._storageService) {
    _initTasks();
  }

  List<TaskItem> get tasks => _tasks;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get totalCount => _tasks.length;
  double get progressPercentage => totalCount > 0 ? completedCount / totalCount : 0.0;
  bool get isAllCompleted => completedCount == totalCount && totalCount > 0;
  int get currentStreak => _currentStreak;
  List<HistoryEntry> get historyEntries => _historyEntries;
  bool get justCompletedAllTasks => _justCompletedAllTasks;

  void dismissCompletedNotice() {
    _justCompletedAllTasks = false;
    notifyListeners();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  void _initTasks() {
    _currentDateKey = _getTodayKey();
    _currentStreak = _storageService.getCurrentStreak();
    _historyEntries = _storageService.getHistoryEntries();

    final lastActiveDate = _storageService.getLastActiveDate();

    if (lastActiveDate != null && lastActiveDate != _currentDateKey) {
      // Date changed! Archive previous day if needed
      _archivePreviousDay(lastActiveDate);
      _tasks = _getDefaultTasks();
      _saveCurrentTasks();
    } else {
      final savedTasks = _storageService.getDailyTasks(_currentDateKey);
      if (savedTasks != null && savedTasks.isNotEmpty) {
        _tasks = savedTasks;
      } else {
        _tasks = _getDefaultTasks();
        _saveCurrentTasks();
      }
    }

    _storageService.saveLastActiveDate(_currentDateKey);
    notifyListeners();
  }

  List<TaskItem> _getDefaultTasks() {
    return [
      TaskItem(
        id: 'fajr',
        title: 'صلاة الفجر',
        subtitle: 'أولى صلوات اليوم وبركة الصباح',
        type: TaskType.prayer,
      ),
      TaskItem(
        id: 'quran',
        title: 'ورد القرآن (صفحتين)',
        subtitle: 'نور لقلبك ويومك',
        type: TaskType.quran,
      ),
      TaskItem(
        id: 'morning_adhkar',
        title: 'أذكار الصباح',
        subtitle: 'حصن المسلم وبركة اليوم',
        type: TaskType.morningAdhkar,
        actionRoute: '/adhkar',
      ),
      TaskItem(
        id: 'dhuhr',
        title: 'صلاة الظهر',
        subtitle: 'سكينة منتصف اليوم',
        type: TaskType.prayer,
      ),
      TaskItem(
        id: 'asr',
        title: 'صلاة العصر',
        subtitle: 'الصلاة الوسطى',
        type: TaskType.prayer,
      ),
      TaskItem(
        id: 'maghrib',
        title: 'صلاة المغرب',
        subtitle: 'غروب الشمس وافتتاح المساء',
        type: TaskType.prayer,
      ),
      TaskItem(
        id: 'isha',
        title: 'صلاة العشاء',
        subtitle: 'ختام صلوات الفريضة',
        type: TaskType.prayer,
      ),
      TaskItem(
        id: 'tasbeeh_minute',
        title: 'تسبيح لمدة دقيقة',
        subtitle: 'دقيقة ذكر هادئة مع العداد',
        type: TaskType.tasbeeh,
        actionRoute: '/tasbeeh',
      ),
    ];
  }

  Future<void> toggleTask(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    await HapticService.light();
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    await _saveCurrentTasks();

    // Check if user just completed all 8 tasks
    if (isAllCompleted) {
      await _handleAllCompleted();
    }

    notifyListeners();
  }

  Future<void> markTaskCompleted(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    if (!_tasks[index].isCompleted) {
      _tasks[index].isCompleted = true;
      await HapticService.light();
      await _saveCurrentTasks();

      if (isAllCompleted) {
        await _handleAllCompleted();
      }

      notifyListeners();
    }
  }

  Future<void> _handleAllCompleted() async {
    await HapticService.medium();
    _justCompletedAllTasks = true;

    // Record in history
    final entry = HistoryEntry(
      dateKey: _currentDateKey,
      date: DateTime.now(),
      completedTasksCount: 8,
      totalTasksCount: 8,
      isFullyCompleted: true,
    );

    // Update streak
    _currentStreak += 1;
    await _storageService.saveCurrentStreak(_currentStreak);

    // Add or update history entry
    _historyEntries.removeWhere((e) => e.dateKey == _currentDateKey);
    _historyEntries.insert(0, entry);
    await _storageService.saveHistoryEntries(_historyEntries);

    // Prepare clean restart for next cycle after short delay/toast
    notifyListeners();
  }

  Future<void> resetDailyTasksManually() async {
    await HapticService.light();
    _tasks = _getDefaultTasks();
    await _saveCurrentTasks();
    notifyListeners();
  }

  void _archivePreviousDay(String oldDateKey) {
    final oldTasks = _storageService.getDailyTasks(oldDateKey);
    if (oldTasks != null && oldTasks.isNotEmpty) {
      final completed = oldTasks.where((t) => t.isCompleted).length;
      final isFull = completed == oldTasks.length;

      final entry = HistoryEntry(
        dateKey: oldDateKey,
        date: DateTime.tryParse(oldDateKey) ?? DateTime.now().subtract(const Duration(days: 1)),
        completedTasksCount: completed,
        totalTasksCount: oldTasks.length,
        isFullyCompleted: isFull,
      );

      _historyEntries.removeWhere((e) => e.dateKey == oldDateKey);
      _historyEntries.insert(0, entry);
      _storageService.saveHistoryEntries(_historyEntries);

      if (!isFull) {
        // Reset or maintain streak
      }
    }
  }

  Future<void> _saveCurrentTasks() async {
    await _storageService.saveDailyTasks(_currentDateKey, _tasks);
  }
}
