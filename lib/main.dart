import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_timer/pages/home_page.dart';
import 'package:job_timer/providers/job_list_provider.dart';
import 'package:job_timer/widgets/app_theme_data.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (context) => JobListProvider(),
      child: MaterialApp(
        theme: AppThemeData.light,
        debugShowCheckedModeBanner: false,
        title: 'Job Timer',
        home: const HomePage(),
      ),
    );
  }
}
