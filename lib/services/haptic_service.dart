import 'package:flutter/services.dart';

class HapticService {
  HapticService._();

  /// Soft light impact for regular checkbox, button tap, or adhkar count increment
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Fallback gracefully on devices without haptic engine
    }
  }

  /// Subtle click for switching tabs or changing toggles
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Fallback gracefully
    }
  }

  /// Medium impact when completing a full cycle (e.g. 1-minute timer finish or completing 8 tasks)
  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Fallback gracefully
    }
  }
}
