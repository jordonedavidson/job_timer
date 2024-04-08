import 'package:job_timer/models/time_entry.dart';

/// Job class.
/// Defines all ways to interact with a job.
class Job {
  int? id;
  String? name;
  final List<TimeEntry> entries = [];

  Job({this.id, required this.name});

  Job.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  Duration get totalTime {
    var runningTotal = 0;
    for (var entry in entries) {
      runningTotal = runningTotal + entry.elapsedTime.inSeconds;
    }
    return Duration(seconds: runningTotal);
  }
}
