import 'package:flutter/material.dart';

class FormattedTime extends StatelessWidget {
  final Duration elapsedTime;
  final double fontSize;
  final Color? colour;
  const FormattedTime(
      {super.key,
      required this.elapsedTime,
      this.fontSize = 16.0,
      this.colour = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${elapsedTime.inHours.toString().padLeft(2, '0')} h ${elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')} m ${elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: fontSize, color: colour),
    );
  }
}
