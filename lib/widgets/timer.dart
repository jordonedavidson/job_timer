import 'package:flutter/material.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/repositories/time_entry.dart';

class Timer extends StatefulWidget {
  late int jobId;
  Timer({super.key, required this.jobId});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  bool isRunning = false;
  Duration elapsedTime = const Duration(seconds: 0);
  late TimeEntry timer;
  TimeEntryRepository timeEntryRepository =
      TimeEntryRepository(DatabaseHelper());

  @override
  void initState() {
    super.initState();
    timer = TimeEntry(jobid: widget.jobId);
  }

  void startTimer() async {
    timer.start = DateTime.now();
    TimeEntry savedTimer = await timeEntryRepository.create(timer);
    setState(() {
      timer = savedTimer;
      isRunning = true;
    });
  }

  void stopTimer() async {
    timer.end = DateTime.now();
    int affectedRows = await timeEntryRepository.update(timer);

    if (affectedRows != 1) {
      throw Exception('Failed to stop timer');
    }
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Center(
        child: Column(
          children: [
            Text(
              timer.elapsedTime.toString(),
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => startTimer(),
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () => stopTimer(),
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
