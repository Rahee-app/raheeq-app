import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/task_item.dart';
import '../models/history_entry.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Storage Keys
  static const String keyUserProfile = 'raheeq_user_profile';
  static const String keyIsLoggedIn = 'raheeq_is_logged_in';
  static const String keyLastActiveDate = 'raheeq_last_active_date';
  static const String keyDailyTasks = 'raheeq_daily_tasks';
  static const String keyHistoryEntries = 'raheeq_history_entries';
  static const String keyCurrentStreak = 'raheeq_current_streak';
  static const String keyMorningAdhkar = 'raheeq_morning_adhkar';
  static const String keyEveningAdhkar = 'raheeq_evening_adhkar';
  static const String keyIsDarkMode = 'raheeq_is_dark_mode';
  static const String keyLanguageCode = 'raheeq_language_code';

  // --- Auth & User Profile ---
  Future<void> saveUserProfile(UserProfile profile) async {
    final jsonStr = jsonEncode(profile.toJson());
    await _prefs?.setString(keyUserProfile, jsonStr);
    await _prefs?.setBool(keyIsLoggedIn, true);
  }

  UserProfile? getUserProfile() {
    final jsonStr = _prefs?.getString(keyUserProfile);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  bool isLoggedIn() {
    return _prefs?.getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> clearAuth() async {
    await _prefs?.remove(keyUserProfile);
    await _prefs?.setBool(keyIsLoggedIn, false);
  }

  // --- Date & Daily Tasks ---
  Future<void> saveLastActiveDate(String dateKey) async {
    await _prefs?.setString(keyLastActiveDate, dateKey);
  }

  String? getLastActiveDate() {
    return _prefs?.getString(keyLastActiveDate);
  }

  Future<void> saveDailyTasks(String dateKey, List<TaskItem> tasks) async {
    final list = tasks.map((t) => t.toJson()).toList();
    await _prefs?.setString('${keyDailyTasks}_$dateKey', jsonEncode(list));
  }

  List<TaskItem>? getDailyTasks(String dateKey) {
    final jsonStr = _prefs?.getString('${keyDailyTasks}_$dateKey');
    if (jsonStr == null) return null;
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((item) => TaskItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // --- History & Streak ---
  Future<void> saveHistoryEntries(List<HistoryEntry> entries) async {
    final list = entries.map((e) => e.toJson()).toList();
    await _prefs?.setString(keyHistoryEntries, jsonEncode(list));
  }

  List<HistoryEntry> getHistoryEntries() {
    final jsonStr = _prefs?.getString(keyHistoryEntries);
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((item) => HistoryEntry.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCurrentStreak(int streak) async {
    await _prefs?.setInt(keyCurrentStreak, streak);
  }

  int getCurrentStreak() {
    return _prefs?.getInt(keyCurrentStreak) ?? 0;
  }

  // --- Adhkar Progress ---
  Future<void> saveMorningAdhkarProgress(String dateKey, Map<String, int> progress) async {
    await _prefs?.setString('${keyMorningAdhkar}_$dateKey', jsonEncode(progress));
  }

  Map<String, int> getMorningAdhkarProgress(String dateKey) {
    final jsonStr = _prefs?.getString('${keyMorningAdhkar}_$dateKey');
    if (jsonStr == null) return {};
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveEveningAdhkarProgress(String dateKey, Map<String, int> progress) async {
    await _prefs?.setString('${keyEveningAdhkar}_$dateKey', jsonEncode(progress));
  }

  Map<String, int> getEveningAdhkarProgress(String dateKey) {
    final jsonStr = _prefs?.getString('${keyEveningAdhkar}_$dateKey');
    if (jsonStr == null) return {};
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  // --- Settings (Dark Mode & Language) ---
  Future<void> saveIsDarkMode(bool isDark) async {
    await _prefs?.setBool(keyIsDarkMode, isDark);
  }

  bool? getIsDarkMode() {
    return _prefs?.getBool(keyIsDarkMode);
  }

  Future<void> saveLanguageCode(String code) async {
    await _prefs?.setString(keyLanguageCode, code);
  }

  String getLanguageCode() {
    return _prefs?.getString(keyLanguageCode) ?? 'ar';
  }
}
