import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/widgets/timer.dart';

class TimerPage extends StatelessWidget {
  final Job job;
  const TimerPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(job.name!)),
      ),
      body: Timer(
        jobId: job.id!,
      ),
    );
  }
}
