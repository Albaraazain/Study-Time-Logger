// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  SharedPreferences? _prefs;
  int totalTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalTime();
  }

  void _loadTotalTime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      totalTimeInSeconds = _prefs?.getInt('totalTime') ?? 0;
    });
  }

  // Log time
  void _logTime() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      totalTimeInSeconds += _seconds;
      _prefs?.setInt('totalTime', totalTimeInSeconds);
      _seconds = 0;
      _timer?.cancel();
      _isRunning = false;
    });
  }

  void _startStopTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    } else {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _timer?.cancel();
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_seconds),
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startStopTimer,
                  child: FittedBox(
                      child: Text(
                    _isRunning ? 'Pause' : 'Start',
                  )),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: FittedBox(
                      child: Text(
                    'Reset',
                  )),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logTime,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: FittedBox(
                  child: Text('Log Time', style: TextStyle(fontSize: 13))),
            ),
          ],
        ),
      ),
    );
  }
}
