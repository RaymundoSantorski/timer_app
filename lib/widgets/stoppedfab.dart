import 'package:flutter/material.dart';

class StoppedFAB extends StatelessWidget {
  const StoppedFAB({super.key, required this.onPressed, this.disabled = false});
  final VoidCallback onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: disabled ? null : onPressed,
      disabledElevation: 0.0,
      child: Icon(Icons.play_arrow),
    );
  }
}
