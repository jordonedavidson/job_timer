import 'package:flutter/material.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:provider/provider.dart';

class JobListing extends StatelessWidget {
  const JobListing({super.key});

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
