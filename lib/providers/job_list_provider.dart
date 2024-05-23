import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';

class JobListProvider extends ChangeNotifier {
  final List<Job> _jobs = [];

  List<Job> get jobs => _jobs;
}
