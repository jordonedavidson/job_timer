import 'package:flutter_test/flutter_test.dart';
import 'package:job_timer/models/time_entry.dart';

void main() {
  group("Testing TimeEntry class", () {
    TimeEntry timer = TimeEntry(jobid: 1);
    test("Time entry with no start time returns a duration of 0", () {
      expect(timer.elapsedTime, equals(const Duration(seconds: 0)));
    });

    test("Time entry with no end produces positive duration", () {
      timer.start = DateTime.now();
      expect(timer.elapsedTime.inMicroseconds, greaterThan(0.0));
    });

    test("Timer returnsw correct elapsed time", () {
      DateTime startTime = DateTime(2024, 3, 1, 9, 15, 0);
      DateTime endTime = DateTime(2024, 3, 1, 9, 30, 0);
      Duration elapsed = endTime.difference(startTime);

      timer.start = startTime;
      timer.end = endTime;

      expect(timer.elapsedTime, equals(elapsed));
    });
  });
}
