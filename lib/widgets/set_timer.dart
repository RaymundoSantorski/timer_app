import 'package:flutter/material.dart';
import 'package:timer/widgets/round_controls.dart';
import 'package:timer/widgets/set_rest_label.dart';
import 'package:timer/widgets/time_selector.dart';

class SetTimer extends StatelessWidget {
  const SetTimer({
    super.key,
    required this.restSeconds,
    required this.onRestChanged,
    required this.decrementRounds,
    required this.totalRounds,
    required this.incrementRounds,
    required this.initialSeconds,
    required this.onValueChanged,
  });
  final int restSeconds;
  final Function(int) onRestChanged;
  final void Function() decrementRounds;
  final int totalRounds;
  final void Function() incrementRounds;
  final int initialSeconds;
  final Function(int) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SetRestLabel(restSeconds: restSeconds, onRestChanged: onRestChanged),
        RoundControls(
          decrementRounds: decrementRounds,
          totalRounds: totalRounds,
          incrementRounds: incrementRounds,
        ),
        TimeSelector(
          initialSeconds: initialSeconds,
          onValueChanged: onValueChanged,
        ),
      ],
    );
  }
}
