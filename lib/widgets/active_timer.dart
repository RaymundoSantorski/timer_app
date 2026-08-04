import 'package:flutter/material.dart';
import 'package:timer/widgets/circle.dart';
import 'package:timer/widgets/round.dart';
import 'package:timer/widgets/timer_state.dart';
import 'package:timer/widgets/work_time.dart';

class ActiveTimer extends StatelessWidget {
  const ActiveTimer({
    super.key,
    required this.isResting,
    required this.currentRound,
    required this.totalRounds,
    required this.progress,
    required this.remainingSeconds,
  });
  final bool isResting;
  final int currentRound;
  final int totalRounds;
  final double progress;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Round(currentRound: currentRound, totalRounds: totalRounds),
        Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: CustomPaint(
                key: Key('circle-$progress'),
                size: const Size(100, 100),
                painter: Circle(progress: progress),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20),
                WorkTime(workSeconds: remainingSeconds),
                MyTimerState(isResting: isResting),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
