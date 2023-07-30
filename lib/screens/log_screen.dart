import 'package:flutter/material.dart';
import 'package:custom_timer/custom_timer.dart';
import '../models/study_log.dart';
import '../styles/styles.dart';

class LogScreen extends StatefulWidget {
  final Function(StudyLog) onLogAdded;

  LogScreen({required this.onLogAdded});

  @override
  LogScreenState createState() => LogScreenState();
}

class LogScreenState extends State<LogScreen>
    with SingleTickerProviderStateMixin {
  DateTime? _startTime;
  DateTime? _endTime;

  late CustomTimerController _controller = CustomTimerController(
    vsync: this,
    begin: Duration(seconds: 0),
    end: Duration(hours: 1),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.milliseconds,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Study Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _startTime != null ? Icons.timer : Icons.book,
              size: 80,
              color: _startTime != null
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              _startTime != null
                  ? 'Logging in progress...'
                  : 'Tap to start logging.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            _startTime != null
                ? CustomTimer(
                    controller: _controller,
                    builder: (state, remaining) {
                      return DisplayTime(state: state, remaining: remaining);
                    },
                  )
                : SizedBox(height: 20),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Start"),
                  onPressed: () => setState(() {
                    _startTime == null ? _startTime = DateTime.now() : null;
                    _controller.start();
                  }),
                ),
                _controller.state == CustomTimerState.paused
                    ? RoundedButton(
                        text: "Resume",
                        color: Colors.green,
                        onPressed: _startTime != null
                            ? () => setState(() {
                                  _controller.start();
                                })
                            : null,
                      )
                    : RoundedButton(
                        text: "Pause",
                        color: Colors.blue,
                        onPressed: () => setState(() {
                          _controller.pause();
                        }),
                      ),
                RoundedButton(
                  text: "Reset",
                  color: Colors.red,
                  onPressed: _startTime != null
                      ? () => setState(() {
                            _endTime = DateTime.now();
                            final studyLog = StudyLog(
                                startTime: _startTime!, endTime: _endTime!);
                            widget.onLogAdded(studyLog);
                            _controller.reset();
                            _startTime = null;
                          })
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayTime extends StatelessWidget {
  final CustomTimerState state;
  final CustomTimerRemainingTime remaining;

  DisplayTime({required this.state, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("${state.name}", style: TextStyle(fontSize: 24.0)),
        Text(
          "${remaining.hours}:${remaining.minutes.toString().padLeft(2, '0')}:${remaining.seconds.toString().padLeft(2, '0')}.${remaining.milliseconds.toString().padLeft(3, '0')}",
          style: TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onPressed;

  RoundedButton({required this.text, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: onPressed,
    );
  }
}
