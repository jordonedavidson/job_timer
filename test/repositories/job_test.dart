import 'dart:math';

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

    test("A job can be deleted", () async {
      final repository = JobRepository(databaseHelper);
      final job = Job(name: "Job 1", id: 1);

      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.delete('jobs', where: 'id = ?', whereArgs: [job.id]))
          .thenAnswer((_) async => 1);

      var result = await repository.delete(job);
      expect(result, 1);
    });

    test("Find all jobs returns list when there are results", () async {
      final repository = JobRepository(databaseHelper);
      final jobsList = [
        Job(name: "Job 1", id: 1),
        Job(name: "Job 2", id: 2),
        Job(name: "Job 3", id: 3),
      ];
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.query('jobs')).thenAnswer((_) async =>
          [jobsList[0].toMap(), jobsList[1].toMap(), jobsList[2].toMap()]);
      var result = await repository.findAll();
      expect(result[0].name, jobsList[0].name);
      expect(result[1].name, jobsList[1].name);
      expect(result[2].name, jobsList[2].name);
      expect(result[0].id, jobsList[0].id);
      expect(result[1].id, jobsList[1].id);
      expect(result[2].id, jobsList[2].id);
    });

    test("Find all jobs returns an empty list when there are no results",
        () async {
      final repository = JobRepository(databaseHelper);
      when(databaseHelper.database).thenAnswer((_) async => mockDb);
      when(mockDb.query('jobs')).thenAnswer((_) async => []);

      var result = await repository.findAll();
      expect(result, []);
    });
  });
}
