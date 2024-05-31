import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/pages/timer_page.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:provider/provider.dart';

class JobListing extends StatefulWidget {
  const JobListing({super.key});

  @override
  State<JobListing> createState() => _JobListingState();
}

class _JobListingState extends State<JobListing> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<JobListProvider>(context, listen: false).getAllJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobListProvider>(builder: (context, jobList, child) {
      if (jobList.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final jobs = jobList.jobs;
        if (jobs.isNotEmpty) {
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return FutureBuilder<ListTile>(
                future: _buildJobTile(context, index, jobs),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return snapshot.data!;
                  }
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text('No jobs found'),
          );
        }
      }
    });
  }
}

Future<ListTile> _buildJobTile(
    BuildContext context, int index, List<Job> jobs) async {
  Job job = jobs[index];
  Duration elapsedTime = await job.totalTime;
  return ListTile(
    leading: const Icon(Icons.timer_rounded),
    title: Text(job.name ?? 'No name'),
    trailing: Text(
      '${elapsedTime.inHours.toString().padLeft(2, '0')} h ${elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')} m ${elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TimerPage(job: job),
        ),
      );
    },
  );
}
