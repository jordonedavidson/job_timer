import 'dart:async';

import 'package:flutter/material.dart';

import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:job_timer/repositories/time_entry.dart';
import 'package:job_timer/widgets/formatted_time.dart';
import 'package:intl/intl.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Center(
        child: Column(
          children: [
            FormattedTime(
              elapsedTime: elapsedTime,
              fontSize: 80.0,
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
              style: const TextStyle(fontSize: 36.0),
            ),
            FormattedTime(
              elapsedTime: jobTotalTime,
              fontSize: 80.0,
              colour: Colors.green,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
              width: double.infinity,
              color: Colors.black12,
              child: Center(
                child: Text(
                  'Time Entries for ${widget.job.name}',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Table(
                children: [
                  TableRow(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    children: const [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'End',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...timeEntries.map(
                    (entry) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  dateFormat.format(entry.start!.toLocal()),
                                  style: const TextStyle(fontSize: 16.0)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  timeFormat.format(entry.start!.toLocal()),
                                  style: const TextStyle(fontSize: 16.0)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  timeFormat.format(entry.end!.toLocal()),
                                  style: const TextStyle(fontSize: 16.0)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: FormattedTime(
                                    elapsedTime: entry.elapsedTime)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
