import 'package:flutter/material.dart';
import 'package:job_timer/models/database_helper.dart';
import 'package:job_timer/models/job.dart';
import 'package:job_timer/repositories/job.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key});
  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  // Global key to uniquely identify the Form widget.
  // This allows us to validate the form.
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final databaseHelper = DatabaseHelper();

  void _addJob(String name) async {
    JobRepository jobRepository = JobRepository(databaseHelper);
    Job job = Job(name: name);
    var newJob = await jobRepository.create(job);
    print(newJob);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Job')),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: textController,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Name of Job is required.'
                    : null,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addJob(textController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add Job'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
