import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/repositories/job_interface.dart';

class JobRepository implements IJobRepository {
  // Instantiate database helper
  final DatabaseHelper _databaseHelper;

  JobRepository(this._databaseHelper);

  @override
  Future<List<Job>> findAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> jobs = await db.query('jobs');
    if (jobs.isNotEmpty) {
      return jobs.map((e) => Job.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Future<Job?> findById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> jobs =
        await db.query('jobs', where: 'id = ?', whereArgs: [id]);
    if (jobs.isNotEmpty) {
      return Job.fromMap(jobs.first);
    }
    return null;
  }

  @override
  Future<List<TimeEntry>> findTimeEntriesByJobId(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> timeEntries =
        await db.query('time_entries', where: 'jobid = ?', whereArgs: [id]);
    if (timeEntries.isNotEmpty) {
      return timeEntries.map((e) => TimeEntry.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Future<Job> create(Job job) async {
    final db = await _databaseHelper.database;
    job.id = await db.insert('jobs', job.toMap());
    print('job id: ${job.id}');
    return job;
  }

  @override
  Future<int> update(Job job) async {
    final db = await _databaseHelper.database;
    final affectedRows = await db
        .update('jobs', job.toMap(), where: 'id = ?', whereArgs: [job.id]);
    return affectedRows;
  }

  @override
  Future<int> delete(Job job) async {
    final db = await _databaseHelper.database;
    final affectedRows =
        await db.delete('jobs', where: 'id = ?', whereArgs: [job.id]);
    return affectedRows;
  }
}
