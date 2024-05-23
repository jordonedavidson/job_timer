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
}
