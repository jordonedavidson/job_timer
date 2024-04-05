import 'package:flutter_test/flutter_test.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/models/time_entry.dart';

void main() {
  group("Testing the Job class", () {
    Job testJob = Job(name: "Test Job");
    testJob.id = 1;

    TimeEntry entryOne = TimeEntry(jobid: 1);
    TimeEntry entryTwo = TimeEntry(jobid: 1);

    test("Job with no entities has 0 elapsed time",
        () => expect(testJob.totalTime, equals(const Duration(seconds: 0))));

    test("Job calculates elapsed time correctly", () {
      entryOne.start = DateTime(2024, 03, 01, 09, 00);
      entryOne.end = DateTime(2024, 03, 01, 10, 00);

      entryTwo.start = DateTime(2024, 03, 01, 13, 00);
      entryTwo.end = DateTime(2024, 03, 01, 14, 00);

      testJob.entries.addAll([entryOne, entryTwo]);

      expect(testJob.totalTime, equals(const Duration(hours: 2)));
    });
  });
}
