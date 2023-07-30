// lib/study_log.dart

class StudyLog {
  final DateTime startTime;
  final DateTime endTime;

  StudyLog({required this.startTime, required this.endTime});

  Duration get studyDuration {
    return endTime.difference(startTime);
  }
}
