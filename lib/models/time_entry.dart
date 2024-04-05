// Entry class
// Represents a timer entry in the db.

class TimeEntry {
  int? id;
  final int jobid;
  DateTime? start;
  DateTime? end;

  TimeEntry({this.id, required this.jobid, this.start, this.end});

  TimeEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        jobid = map['jobid'],
        start = map['start'] != null ? DateTime.parse(map['start']) : null,
        end = map['end'] != null ? DateTime.parse(map['end']) : null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobid': jobid,
      'start': start?.toIso8601String(),
      'end': end?.toIso8601String(),
    };
  }

  Duration get elapsedTime {
    final now = DateTime.now();
    DateTime endTime = end ?? now;

    if (start == null) {
      return const Duration(seconds: 0);
    }
    return endTime.difference(start!);
  }
}
