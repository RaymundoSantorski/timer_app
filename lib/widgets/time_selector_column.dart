import 'package:flutter/material.dart';
import 'package:numeric_selector/numeric_selector.dart';

class TimeSelectorColumn extends StatelessWidget {
  final String label;
  final int initialValue;
  final Function(int) onValueChanged;

  const TimeSelectorColumn({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalNumericSelector(
          minValue: 0,
          maxValue: 59,
          step: 1,
          initialValue: initialValue,
          onValueChanged: onValueChanged,
          viewPort: 0.3,
          selectedTextStyle: TextStyle(
            color: ColorScheme.of(context).onSurface,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
          backgroundColor: ColorScheme.of(context).surface,
          borderRadius: BorderRadius.circular(10),
          showArrows: false,
          showLabel: false,
          enableVibration: true,
          showSelectedValue: false,
        ),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
