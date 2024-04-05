import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/models/job.dart';

abstract class IJobRepository {
  Future<List<Job>> findAll();
  Future<Job?> findById(int id);
  Future<List<TimeEntry>> findTimeEntriesByJobId(int id);
  Future<Job> create(Job job);
  Future<void> update(Job job);
  Future<void> delete(Job job);
}
