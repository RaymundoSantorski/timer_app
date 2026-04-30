import 'package:flutter/material.dart';

class WorkTime extends StatelessWidget {
  const WorkTime({super.key, required this.workSeconds});
  final int workSeconds;
  Duration get workDuration => Duration(seconds: workSeconds);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${workDuration.inMinutes.toString().padLeft(2, '0')}:${(workDuration.inSeconds % 60).toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
      ),
    );
  }
}
