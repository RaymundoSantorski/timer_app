import 'package:flutter/material.dart';

class RoundControls extends StatelessWidget {
  const RoundControls({
    super.key,
    required this.decrementRounds,
    required this.totalRounds,
    required this.incrementRounds,
  });
  final VoidCallback decrementRounds;
  final int totalRounds;
  final VoidCallback incrementRounds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 30),
          onPressed: decrementRounds,
        ),
        Text(
          '$totalRounds rounds',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        IconButton(icon: Icon(Icons.add, size: 30), onPressed: incrementRounds),
      ],
    );
  }
}
