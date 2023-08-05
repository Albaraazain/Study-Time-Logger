// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:study_logger/models/timer_model.dart';
import 'screens/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<TimerModel>(
        create: (_) => TimerModel(),
        child: StudyLoggerApp(),
      ),
    );

class StudyLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
