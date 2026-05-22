import 'package:flutter/material.dart';

class RunningFAB extends StatelessWidget {
  const RunningFAB({
    super.key,
    this.onStopped,
    this.onPaused,
    this.onResumed,
    required this.isRunning,
  });
  final VoidCallback? onStopped;
  final VoidCallback? onPaused;
  final VoidCallback? onResumed;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: onStopped,
          disabledElevation: 0.0,
          child: Icon(Icons.stop),
        ),
        SizedBox(width: 30),
        FloatingActionButton(onPressed: onPaused, child: Icon(Icons.pause)),
      ],
    );
  }
}
