import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:job_timer/repositories/time_entry.dart';
import 'package:provider/provider.dart';

class JobTimer extends StatefulWidget {
  final int jobId;
  const JobTimer({super.key, required this.jobId});

  @override
  State<JobTimer> createState() => _JobTimerState();
}

class _JobTimerState extends State<JobTimer> {
  bool isRunning = false;
  Duration elapsedTime = Duration();
  Timer? timer;
  late TimeEntry jobTimer;
  TimeEntryRepository timeEntryRepository =
      TimeEntryRepository(DatabaseHelper());

  @override
  void initState() {
    super.initState();
    jobTimer = TimeEntry(jobid: widget.jobId);
  }

  void startTimer() async {
    jobTimer.start = DateTime.now();
    TimeEntry savedTimer = await timeEntryRepository.create(jobTimer);
    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => jobTimer.elapsedTime);
    setState(() {
      jobTimer = savedTimer;
      isRunning = true;
    });
  }

  void stopTimer() async {
    jobTimer.end = DateTime.now();
    int affectedRows = await timeEntryRepository.update(jobTimer);

    if (affectedRows != 1) {
      throw Exception('Failed to stop timer');
    }
    setState(() {
      isRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Center(
        child: Column(
          children: [
            Text(
              timer == null ? '00:00:00' : jobTimer.elapsedTime.toString(),
              style: const TextStyle(fontSize: 80),
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
          ],
        ),
      ),
    );
  }
}
