import 'package:flutter/material.dart';

class WorkTime extends StatelessWidget {
  const WorkTime({super.key, required this.workSeconds});
  final int workSeconds;
  Duration get workDuration => Duration(seconds: workSeconds);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              '${workDuration.inHours.toString().padLeft(2, '0')}:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
          ),
          FittedBox(
            child: Text(
              '${(workDuration.inMinutes % 60).toString().padLeft(2, '0')}:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
          ),
          FittedBox(
            child: Text(
              '${(workDuration.inSeconds % 60).toString().padLeft(2, '0')} ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
          ),
        ],
      ),
    );
  }
}
