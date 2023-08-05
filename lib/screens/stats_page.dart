// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:study_logger/moor_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Map<String, Map<String, dynamic>> statsByDate = {};
  List<charts.Series<dynamic, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreferences();
  }

  Future<void> _getDataFromSharedPreferences() async {
    // Get all sessions from the database
    List<Session> sessions = await AppDatabase().getAllSessions();

    // Group sessions by date
    Map<String, List<Session>> sessionsByDate = {};
    for (Session session in sessions) {
      if (sessionsByDate.containsKey(session.date)) {
        sessionsByDate[session.date]!.add(session);
      } else {
        sessionsByDate[session.date] = [session];
      }
    }

    // For each date, calculate total, average, max, and min durations
    Map<String, Map<String, dynamic>> statsByDate = {};
    for (String date in sessionsByDate.keys) {
      int totalTime = sessionsByDate[date]!
              .fold(0, (prev, session) => prev + session.duration) ~/
          60;
      double averageTime = (totalTime /
          (sessionsByDate[date]!.length > 0
              ? sessionsByDate[date]!.length
              : 1));
      int maxTime = sessionsByDate[date]!.fold(
              0,
              (prev, session) =>
                  prev > session.duration ? prev : session.duration) ~/
          60;
      int minTime = sessionsByDate[date]!.fold(
              maxTime,
              (prev, session) =>
                  prev < session.duration ? prev : session.duration) ~/
          60;
      statsByDate[date] = {
        "totalTime": totalTime,
        "averageTime": averageTime,
        "maxTime": maxTime,
        "minTime": minTime
      };
    }

    // Create seriesList for BarChart
    seriesList = [
      charts.Series<Map<String, dynamic>, String>(
        id: 'Sessions',
        domainFn: (Map<String, dynamic> stats, _) => stats['date'],
        measureFn: (Map<String, dynamic> stats, _) => stats['totalTime'],
        data: statsByDate.entries.map((entry) {
          return {'date': entry.key, 'totalTime': entry.value['totalTime']};
        }).toList(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    setState(() {
      this.statsByDate = statsByDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 600, // Adjust as per your needs
          width: 800, // Adjust as per your needs
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: seriesList.isNotEmpty
                  ? charts.BarChart(
                      seriesList,

                      // make the bar charts green. to do that we need to extend the color function to take in our data object as well as an index value
                      // and return a color. here we check to see if the data object is the one we want to color differently, and return the desired
                      // color, otherwise return the default.

                      animate: true,
                      behaviors: [
                        charts.ChartTitle('Dates',
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('Total Time',
                            behaviorPosition: charts.BehaviorPosition.start,
                            titleStyleSpec: charts.TextStyleSpec(fontSize: 14)),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
