import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'job_timer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL  
      );
      CREATE TABLE time_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobid INTEGER NOT NULL,
        start TEXT,
        end TEXT,
        FOREIGN KEY (jobid) REFERENCES jobs (id) ON DELETE CASCADE
      );
      CREATE INDEX time_entries_jobid_index ON time_entries (jobid);
    ''');
  }
}
