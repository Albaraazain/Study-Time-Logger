// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/timer_model.dart';
import 'package:provider/provider.dart';
import '/moor_database.dart';
import 'package:moor/moor.dart' hide Column;

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
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

  void _logTime(int seconds) async {
    final timerModel = Provider.of<TimerModel>(context, listen: false);

    String today = DateTime.now().toIso8601String().substring(0, 10);

    // Create a new row in the database
    await AppDatabase().insertSession(SessionsCompanion(
      date: Value(today),
      duration: Value(seconds),
    ));

    timerModel.reset();
  }

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<TimerModel>(
              builder: (context, timerModel, child) => Text(
                _formatTime(timerModel.seconds),
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timerModel.toggle,
                  child: FittedBox(
                    child: Text(
                      timerModel.isRunning ? 'Pause' : 'Start',
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: timerModel.reset,
                  child: FittedBox(
                    child: Text(
                      'Reset',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logTime(timerModel.seconds),
              child: FittedBox(
                child: Text(
                  'Log Time',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
