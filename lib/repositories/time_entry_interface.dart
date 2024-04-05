import '../models/time_entry.dart';

abstract class ITimeEntryRepository {
  Future<List<TimeEntry>> findByJobId(int id);
  Future<TimeEntry?> findById(int id);
  Future<TimeEntry> create(TimeEntry timeEntry);
  Future<int> update(TimeEntry timeEntry);
  Future<int> delete(TimeEntry timeEntry);
}
