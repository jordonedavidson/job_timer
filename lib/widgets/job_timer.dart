import 'dart:async';

import 'package:flutter/material.dart';

import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:job_timer/repositories/time_entry.dart';
import 'package:job_timer/widgets/formatted_time.dart';
import 'package:intl/intl.dart';
import 'package:job_timer/widgets/time_entry_table.dart';
import 'package:provider/provider.dart';

class JobTimer extends StatefulWidget {
  final Job job;
  const JobTimer({super.key, required this.job});

  @override
  State<JobTimer> createState() => _JobTimerState();
}

class _JobTimerState extends State<JobTimer> {
  bool isRunning = false;
  Duration elapsedTime = const Duration(seconds: 0);
  Duration jobTotalTime = const Duration(seconds: 0);
  List<TimeEntry> timeEntries = [];
  Timer? timer;
  late TimeEntry jobTimer;
  TimeEntryRepository timeEntryRepository =
      TimeEntryRepository(DatabaseHelper());

  @override
  void initState() {
    super.initState();
    jobTimer = TimeEntry(jobid: widget.job.id!);
    getJobTotalTime();
    getTimeEntries();
  }

  Future<void> getJobTotalTime() async {
    Duration duration = await widget.job.totalTime;
    setState(() {
      jobTotalTime = duration;
    });
  }

  Future<List<TimeEntry>> getTimeEntries() async {
    timeEntries = await timeEntryRepository.findByJobId(widget.job.id!);
    return timeEntries;
  }

  void startTimer() async {
    jobTimer.start = DateTime.now();
    TimeEntry savedTimer = await timeEntryRepository.create(jobTimer);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTimer());
    setState(() {
      jobTimer = savedTimer;
      isRunning = true;
    });
  }

  void updateTimer() {
    setState(() {
      elapsedTime = jobTimer.elapsedTime;
    });
  }

  void stopTimer() async {
    jobTimer.end = DateTime.now();
    int affectedRows = await timeEntryRepository.update(jobTimer);

    if (affectedRows != 1) {
      throw Exception('Failed to stop timer');
    }
    setState(() {
      jobTimer.id = null;
      jobTimer.start = null;
      jobTimer.end = null;
      isRunning = false;
      getJobTotalTime();
      getTimeEntries();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat("yyyy-MM-dd");
    var timeFormat = DateFormat("HH:mm:ss");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Center(
        child: Column(
          children: [
            FormattedTime(
              elapsedTime: elapsedTime,
              fontSize: 42.0,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      startTimer();
                      Provider.of<JobListProvider>(context, listen: false)
                          .getAllJobs();
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {
                      stopTimer();
                      Provider.of<JobListProvider>(context, listen: false)
                          .getAllJobs();
                    },
                    icon: const Icon(
                      Icons.stop,
                      size: 50,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Total time spent on ${widget.job.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32.0),
            ),
            FormattedTime(
              elapsedTime: jobTotalTime,
              fontSize: 42.0,
              colour: Colors.green,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0),
              width: double.infinity,
              color: Colors.black12,
              child: const Center(
                child: Text(
                  'Time Entries',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            TimeEntryTable(
                timeEntries: timeEntries,
                dateFormat: dateFormat,
                timeFormat: timeFormat),
          ],
        ),
      ),
    );
  }
}
