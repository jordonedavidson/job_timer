import 'package:flutter/material.dart';
import 'package:job_timer/widgets/app_theme_data.dart';

void main() {
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
        ),
        body: ListView(
          children: const [
            ListTile(
              title: Text(
                "Job One",
              ),
              trailing: Text("00:30:20"),
            ),
            ListTile(
              title: Text(
                "Job Two",
              ),
              trailing: Text("00:30:20"),
            ),
          ],
        ),
      ),
    );
  }
}
