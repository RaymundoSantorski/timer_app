import 'package:flutter/material.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({super.key, required this.total, required this.current});
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    double value = current / total;
    return CircularProgressIndicator(
      constraints: BoxConstraints(minWidth: 250, minHeight: 250),
      padding: EdgeInsets.all(8.0),
      backgroundColor: Colors.transparent,
      color: value >= 0.5
          ? Colors.blue
          : value >= 0.2
          ? Colors.amber
          : Colors.red,
      value: value,
    );
  }
}
