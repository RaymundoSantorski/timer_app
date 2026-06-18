import 'package:flutter/material.dart';

class Round extends StatelessWidget {
  const Round({
    super.key,
    required this.currentRound,
    required this.totalRounds,
  });
  final int currentRound;
  final int totalRounds;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ronda $currentRound / $totalRounds',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
