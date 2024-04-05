import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/time_entry.dart';
import 'time_entry_interface.dart';

class TimeEntryRepository implements ITimeEntryRepository {
  final DatabaseHelper _databaseHelper;
  TimeEntryRepository(this._databaseHelper);

  @override
  Future<List<TimeEntry>> findByJobId(int jobId) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> timeEntries =
        await db.query('time_entries', where: 'jobid = ?', whereArgs: [jobId]);
    if (timeEntries.isNotEmpty) {
      return timeEntries.map((e) => TimeEntry.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Future<TimeEntry?> findById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> timeEntries =
        await db.query('time_entries', where: 'id = ?', whereArgs: [id]);
    if (timeEntries.isNotEmpty) {
      return TimeEntry.fromMap(timeEntries.first);
    }
    return null;
  }

  @override
  Future<TimeEntry> create(TimeEntry timeEntry) async {
    final db = await _databaseHelper.database;
    timeEntry.id = await db.insert('time_entries', timeEntry.toMap());
    return timeEntry;
  }

  @override
  Future<int> update(TimeEntry timeEntry) async {
    final db = await _databaseHelper.database;
    final affectedRows = await db.update('time_entries', timeEntry.toMap(),
        where: 'id = ?', whereArgs: [timeEntry.id]);
    return affectedRows;
  }

  @override
  Future<int> delete(TimeEntry timeEntry) async {
    final db = await _databaseHelper.database;
    final affectedRows = await db
        .delete('time_entries', where: 'id = ?', whereArgs: [timeEntry.id]);
    return affectedRows;
  }
}
