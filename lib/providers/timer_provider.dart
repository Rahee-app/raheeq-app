import 'dart:async';
import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

enum TimerState {
  idle,
  running,
  paused,
  completed,
}

class TimerProvider with ChangeNotifier {
  static const int totalSeconds = 60;

  int _remainingSeconds = totalSeconds;
  int _counter = 0;
  TimerState _state = TimerState.idle;
  Timer? _timer;

  final List<String> _adhkarPhrases = [
    'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
    'سُبْحَانَ اللهِ الْعَظِيمِ',
    'الْحَمْدُ للهِ',
    'لا إِلَهَ إِلَّا اللهُ',
    'اللهُ أَكْبَرُ',
    'أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
  ];

  int _selectedPhraseIndex = 0;

  int get remainingSeconds => _remainingSeconds;
  int get counter => _counter;
  TimerState get state => _state;
  bool get isRunning => _state == TimerState.running;
  bool get isCompleted => _state == TimerState.completed;
  double get progress => (totalSeconds - _remainingSeconds) / totalSeconds;
  String get currentPhrase => _adhkarPhrases[_selectedPhraseIndex];
  List<String> get adhkarPhrases => _adhkarPhrases;

  void selectPhrase(int index) {
    if (index >= 0 && index < _adhkarPhrases.length) {
      _selectedPhraseIndex = index;
      HapticService.selection();
      notifyListeners();
    }
  }

  void startTimer({VoidCallback? onComplete}) {
    if (_state == TimerState.running) return;

    _state = TimerState.running;
    HapticService.selection();
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _state = TimerState.completed;
        await HapticService.medium();
        if (onComplete != null) {
          onComplete();
        }
        notifyListeners();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _state = TimerState.paused;
    HapticService.selection();
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingSeconds = totalSeconds;
    _counter = 0;
    _state = TimerState.idle;
    HapticService.selection();
    notifyListeners();
  }

  Future<void> incrementTap() async {
    // If timer is not running, start it on first tap
    if (_state == TimerState.idle) {
      startTimer();
    }

    if (_state == TimerState.running) {
      _counter++;
      await HapticService.light();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
