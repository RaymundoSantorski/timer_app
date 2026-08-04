import 'package:flutter/material.dart';

class MyTimerState extends StatelessWidget {
  const MyTimerState({super.key, required this.isResting});
  final bool isResting;

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Text(
          key: Key('workState-${isResting ? 'rest' : 'work'}'),
          isResting ? 'Descanso' : 'Trabajo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: isResting
                ? ColorScheme.of(context).error
                : Colors.lightGreen,
          ),
        ),
      ),
    );
  }
}
