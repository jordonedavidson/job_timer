import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/pages/timer_page.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:job_timer/widgets/formatted_time.dart';
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
  Color tileColour = index % 2 == 0
      ? const Color.fromARGB(255, 132, 233, 223)
      : Colors.white38;
  return ListTile(
    leading: IconButton(
      icon: const Icon(Icons.timer_rounded),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TimerPage(job: job),
          ),
        );
      },
    ),
    title: Text(job.name ?? 'No name'),
    trailing: FormattedTime(elapsedTime: elapsedTime),
    tileColor: tileColour,
  );
}
