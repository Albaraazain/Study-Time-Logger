import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

void main() => runApp(Pomodoro());

class Pomodoro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF2A2B4D),
        colorScheme: ColorScheme.dark(
          primary: Colors.greenAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
