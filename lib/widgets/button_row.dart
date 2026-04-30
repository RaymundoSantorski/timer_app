import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    required this.increment,
    required this.decrement,
  });
  final void Function() increment;
  final void Function() decrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: increment, icon: Icon(Icons.add)),
        IconButton(onPressed: decrement, icon: Icon(Icons.remove)),
      ],
    );
  }
}
