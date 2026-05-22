import 'package:flutter/material.dart';

// FloatingActionButton(
//         onPressed: remainingSeconds == 0
//             ? null
//             : () {
//                 setState(() {
//                   isRunning = !isRunning;
//                 });
//                 if (isRunning) {
//                   startTimer();
//                 } else {
//                   stopTimer();
//                 }
//               },
//         disabledElevation: 0.0,
//         child: Icon(isRunning ? Icons.stop : Icons.play_arrow),
//       );

class StoppedFAB extends StatelessWidget {
  const StoppedFAB({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      disabledElevation: 0.0,
      child: Icon(Icons.play_arrow),
    );
  }
}
