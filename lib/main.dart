import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_timer/widgets/app_theme_data.dart';
import 'package:job_timer/widgets/job_listing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.light,
      debugShowCheckedModeBanner: false,
      title: 'Job Timer',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Job Timer')),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.add,
              ),
              tooltip: "Add Job",
            ),
          ],
        ),
        body: const JobListing(),
      ),
    );
  }
}
