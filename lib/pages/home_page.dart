import 'package:flutter/material.dart';
import 'package:job_timer/widgets/job_form.dart';
import 'package:job_timer/widgets/job_listing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Job Timer')),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JobForm(),
                ),
              ),
            },
            icon: const Icon(
              Icons.add,
            ),
            tooltip: "Add Job",
          ),
        ],
      ),
      body: const JobListing(),
    );
  }
}
