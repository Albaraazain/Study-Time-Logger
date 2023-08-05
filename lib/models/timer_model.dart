// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  int _seconds = 0;
  Timer? _timer;

  int get seconds =>
      _seconds; // Getter for _seconds variable in TimerModel class
  bool get isRunning => _timer != null;

  void start() {
    if (!isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _seconds++;
        notifyListeners();
      });
    }
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    _seconds = 0;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void toggle() {
    if (isRunning) {
      _timer?.cancel();
      _timer = null;
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _seconds++;
        notifyListeners();
      });
    }
    notifyListeners();
  }
}
