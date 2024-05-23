import 'package:flutter/material.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/repositories/job.dart';

class JobListProvider extends ChangeNotifier {
  List<Job> _jobs = [];
  bool isLoading = false;

  List<Job> get jobs => _jobs;

  Future<void> getAllJobs() async {
    // set loading state
    isLoading = true;
    notifyListeners();

    // Load jobs from database.
    final jobList = await JobRepository(DatabaseHelper()).findAll();

    _jobs = jobList;
    isLoading = false;
    notifyListeners();
  }

  /// Adds a [job] to the list of jobs and notifies the listeners.
  ///
  /// The [job] parameter is the job to be added to the list.
  ///
  /// This function does not return anything.
  Future<void> addJob(Job job) async {
    await JobRepository(DatabaseHelper()).create(job);

    _jobs.add(job);
    notifyListeners();
  }
}
