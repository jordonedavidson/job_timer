import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';
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
                Job job = jobs[index];
                return ListTile(
                  title: Text(job.name ?? 'No name'),
                  trailing: Text('${job.totalTime}'),
                );
              });
        } else {
          return const Center(
            child: Text('No jobs found'),
          );
        }
      }
    });
  }
}
