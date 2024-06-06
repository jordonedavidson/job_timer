import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_timer/models/time_entry.dart';
import 'package:job_timer/widgets/formatted_time.dart';

class TimeEntryTable extends StatelessWidget {
  final List<TimeEntry> timeEntries;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  const TimeEntryTable({
    super.key,
    required this.timeEntries,
    required this.dateFormat,
    required this.timeFormat,
  });

  // Sort the time entries by start time newest first.
  void sortTimeEntries() =>
      timeEntries.sort((b, a) => a.start!.compareTo(b.start!));

  @override
  Widget build(BuildContext context) {
    sortTimeEntries();
    return Expanded(
      child: ListView(
        children: [
          Table(
            children: [
              TableRow(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                children: const [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'End',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...timeEntries.map(
                (entry) => TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(dateFormat.format(entry.start!.toLocal()),
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(timeFormat.format(entry.start!.toLocal()),
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(timeFormat.format(entry.end!.toLocal()),
                              style: const TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: FormattedTime(
                          elapsedTime: entry.elapsedTime,
                          fontSize: 12.0,
                        )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
