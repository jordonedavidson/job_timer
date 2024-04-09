import 'package:flutter/material.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/repositories/job.dart';

class JobListing extends StatefulWidget {
  const JobListing({super.key});

  @override
  State<JobListing> createState() => _JobListingState();
}

class _JobListingState extends State<JobListing> {
  final jobRepository = JobRepository(DatabaseHelper());
  Future<List<Job>>? _jobs;

  @override
  // Initialize the state by calling the superclass initState method and fetching all jobs from the job repository.
  void initState() {
    super.initState();
    _jobs = jobRepository.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _jobs,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              final jobs = snapshot.data;
              if (jobs!.isNotEmpty) {
                return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      Job job = jobs[index];
                      return ListTile(
                        title: Text(job.name ?? 'No name'),
                      );
                    });
              } else {
                return const Center(
                  child: Text('No jobs found'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred: $snapshot.error'),
              );
            }
        }
        return const Center(
          child: Text('No jobs found'),
        );
      },
    );
  }
}
