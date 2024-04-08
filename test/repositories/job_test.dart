import 'package:flutter_test/flutter_test.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/repositories/job.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'job_test.mocks.dart';

@GenerateMocks([Database, DatabaseHelper])
void main() {
  final databaseHelper = MockDatabaseHelper();
  final mockDb = MockDatabase();

  group("Testing JobRepository", () {
    test("A new entry is created", () async {
      final repository = JobRepository(databaseHelper);
      final job = Job(name: "Job 1");

      // Mocking the database interactions.
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.insert('jobs', job.toMap())).thenAnswer((_) async {
        return 1;
      });

      var result = await repository.create(job);
      expect(result, isA<Job>());
      expect(result.id == 1, true);
    });

    test("A job can be updated", () async {
      final repository = JobRepository(databaseHelper);
      final job = Job(name: "Job 1", id: 1);
      job.name = "Job 2";

      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.update('jobs', job.toMap(),
          where: 'id = ?', whereArgs: [job.id])).thenAnswer((_) async => 1);

      var result = await repository.update(job);
      expect(result, 1);
    });
  });
}
