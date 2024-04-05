import 'package:flutter_test/flutter_test.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/repositories/time_entry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'time_entry_test.mocks.dart';

@GenerateMocks([Database, DatabaseHelper])
void main() {
  final databaseHelper = MockDatabaseHelper();
  final mockDb = MockDatabase();

  group("Testing TimeEntryRepository", () {
    test("A new entry is created", () async {
      final repository = TimeEntryRepository(databaseHelper);
      final timeEntry = TimeEntry(jobid: 1);

      // Mocking the database interactions.
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.insert('time_entries', TimeEntry(jobid: 1).toMap()))
          .thenAnswer((_) async {
        return 1;
      });

      var result = await repository.create(timeEntry);
      expect(result, isA<TimeEntry>());
      expect(result.id == 1, true);
    });

    test('An entry can be updated', () async {
      final repository = TimeEntryRepository(databaseHelper);
      final timeEntry = TimeEntry(jobid: 1);
      timeEntry.id = 1;
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.update('time_entries', timeEntry.toMap(),
          where: 'id = ?',
          whereArgs: [timeEntry.id])).thenAnswer((_) async => 1);

      var result = await repository.update(timeEntry);
      expect(result, 1);
    });

    test('An entry can be deleted', () async {
      final repository = TimeEntryRepository(databaseHelper);
      final timeEntry = TimeEntry(jobid: 1);
      timeEntry.id = 1;
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.delete('time_entries',
          where: 'id = ?',
          whereArgs: [timeEntry.id])).thenAnswer((_) async => 1);

      var result = await repository.delete(timeEntry);
      expect(result, 1);
    });

    test('An entry can be found by id', () async {
      final repository = TimeEntryRepository(databaseHelper);
      final timeEntry = TimeEntry(jobid: 1);
      timeEntry.id = 1;

      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.query('time_entries', where: 'id = ?', whereArgs: [1]))
          .thenAnswer((_) async => [timeEntry.toMap()]);

      var result = await repository.findById(1);
      expect(result, isA<TimeEntry>());
    });
  });
}
