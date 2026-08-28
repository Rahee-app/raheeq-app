import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/haptic_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService;
  final AuthService _authService = AuthService();

  UserProfile? _userProfile;
  bool _isLoading = false;
  bool _isFirstTimeLogin = false;

  AuthProvider(this._storageService) {
    _loadUser();
  }

  UserProfile? get userProfile => _userProfile;
  bool get isLoggedIn => _userProfile != null;
  bool get isLoading => _isLoading;
  bool get isFirstTimeLogin => _isFirstTimeLogin;
  String get userName => _userProfile?.name ?? 'مستخدم رَحيق';
  Gender get gender => _userProfile?.gender ?? Gender.unspecified;
  Color get avatarColor => _userProfile?.avatarColor ?? const Color(0xFF16652B);

  void _loadUser() {
    _userProfile = _storageService.getUserProfile();
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    await HapticService.light();

    try {
      final profile = await _authService.signInWithGoogle();
      if (profile != null) {
        _userProfile = profile;
        await _storageService.saveUserProfile(profile);
        _isFirstTimeLogin = (profile.gender == Gender.unspecified);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> updateGender(Gender gender) async {
    if (_userProfile == null) return;
    _userProfile = _userProfile!.copyWith(gender: gender);
    await _storageService.saveUserProfile(_userProfile!);
    _isFirstTimeLogin = false;
    await HapticService.light();
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required Gender gender}) async {
    if (_userProfile == null) return;
    _userProfile = _userProfile!.copyWith(name: name, gender: gender);
    await _storageService.saveUserProfile(_userProfile!);
    await HapticService.light();
    notifyListeners();
  }

  Future<void> signOut() async {
    await HapticService.selection();
    await _authService.signOut();
    await _storageService.clearAuth();
    _userProfile = null;
    notifyListeners();
  }
}
