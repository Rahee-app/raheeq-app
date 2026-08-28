import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService;
  bool _isDarkMode = false;
  Locale _locale = const Locale('ar');

  ThemeProvider(this._storageService) {
    _loadPreferences();
  }

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void _loadPreferences() {
    final savedDarkMode = _storageService.getIsDarkMode();
    if (savedDarkMode != null) {
      _isDarkMode = savedDarkMode;
    }
    final savedLang = _storageService.getLanguageCode();
    _locale = Locale(savedLang);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.saveIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    await _storageService.saveIsDarkMode(isDark);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final newCode = _locale.languageCode == 'ar' ? 'en' : 'ar';
    _locale = Locale(newCode);
    await _storageService.saveLanguageCode(newCode);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    await _storageService.saveLanguageCode(code);
    notifyListeners();
  }
}
