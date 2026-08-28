import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dhikr_item.dart';
import '../services/adhkar_data_service.dart';
import '../services/storage_service.dart';
import '../services/haptic_service.dart';

class AdhkarProvider with ChangeNotifier {
  final StorageService _storageService;

  List<DhikrItem> _morningAdhkar = [];
  List<DhikrItem> _eveningAdhkar = [];
  String _currentDateKey = '';

  AdhkarProvider(this._storageService) {
    _initAdhkar();
  }

  List<DhikrItem> get morningAdhkar => _morningAdhkar;
  List<DhikrItem> get eveningAdhkar => _eveningAdhkar;

  int get morningCompletedCount => _morningAdhkar.where((d) => d.isCompleted).length;
  int get morningTotalCount => _morningAdhkar.length;
  double get morningProgress => morningTotalCount > 0 ? morningCompletedCount / morningTotalCount : 0.0;
  bool get isMorningAllCompleted => morningCompletedCount == morningTotalCount && morningTotalCount > 0;

  int get eveningCompletedCount => _eveningAdhkar.where((d) => d.isCompleted).length;
  int get eveningTotalCount => _eveningAdhkar.length;
  double get eveningProgress => eveningTotalCount > 0 ? eveningCompletedCount / eveningTotalCount : 0.0;
  bool get isEveningAllCompleted => eveningCompletedCount == eveningTotalCount && eveningTotalCount > 0;

  void _initAdhkar() {
    final now = DateTime.now();
    _currentDateKey = DateFormat('yyyy-MM-dd').format(now);

    _morningAdhkar = AdhkarDataService.getMorningAdhkar();
    _eveningAdhkar = AdhkarDataService.getEveningAdhkar();

    // Restore today's progress
    final morningProgressMap = _storageService.getMorningAdhkarProgress(_currentDateKey);
    for (var item in _morningAdhkar) {
      if (morningProgressMap.containsKey(item.id)) {
        item.currentCount = morningProgressMap[item.id]!;
        item.isCompleted = item.currentCount >= item.targetCount;
      }
    }

    final eveningProgressMap = _storageService.getEveningAdhkarProgress(_currentDateKey);
    for (var item in _eveningAdhkar) {
      if (eveningProgressMap.containsKey(item.id)) {
        item.currentCount = eveningProgressMap[item.id]!;
        item.isCompleted = item.currentCount >= item.targetCount;
      }
    }

    notifyListeners();
  }

  Future<void> incrementMorningDhikr(String id) async {
    final item = _morningAdhkar.firstWhere((d) => d.id == id);
    item.increment();
    await HapticService.light();
    await _saveMorningProgress();
    notifyListeners();
  }

  Future<void> toggleMorningDhikr(String id) async {
    final item = _morningAdhkar.firstWhere((d) => d.id == id);
    item.toggleComplete();
    await HapticService.light();
    await _saveMorningProgress();
    notifyListeners();
  }

  Future<void> resetMorningAdhkar() async {
    for (var item in _morningAdhkar) {
      item.reset();
    }
    await HapticService.selection();
    await _saveMorningProgress();
    notifyListeners();
  }

  Future<void> incrementEveningDhikr(String id) async {
    final item = _eveningAdhkar.firstWhere((d) => d.id == id);
    item.increment();
    await HapticService.light();
    await _saveEveningProgress();
    notifyListeners();
  }

  Future<void> toggleEveningDhikr(String id) async {
    final item = _eveningAdhkar.firstWhere((d) => d.id == id);
    item.toggleComplete();
    await HapticService.light();
    await _saveEveningProgress();
    notifyListeners();
  }

  Future<void> resetEveningAdhkar() async {
    for (var item in _eveningAdhkar) {
      item.reset();
    }
    await HapticService.selection();
    await _saveEveningProgress();
    notifyListeners();
  }

  Future<void> _saveMorningProgress() async {
    final map = {for (var d in _morningAdhkar) d.id: d.currentCount};
    await _storageService.saveMorningAdhkarProgress(_currentDateKey, map);
  }

  Future<void> _saveEveningProgress() async {
    final map = {for (var d in _eveningAdhkar) d.id: d.currentCount};
    await _storageService.saveEveningAdhkarProgress(_currentDateKey, map);
  }
}
