import 'package:flutter/material.dart';
import 'package:numeric_selector/numeric_selector.dart';

class TimeSelector extends StatelessWidget {
  final int remainingSeconds;
  final Function(int) onValueChanged;

  const TimeSelector({
    super.key,
    required this.remainingSeconds,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            VerticalNumericSelector(
              minValue: 0,
              maxValue: 59,
              step: 1,
              initialValue: 0,
              onValueChanged: (value) {},
              viewPort: 0.3,
              selectedTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              showArrows: false,
              showLabel: false,
              enableVibration: true,
              showSelectedValue: false,
            ),
            Text('Hours', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        Column(
          children: [
            VerticalNumericSelector(
              minValue: 0,
              maxValue: 59,
              step: 1,
              initialValue: 0,
              onValueChanged: (value) {},
              viewPort: 0.3,
              selectedTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              showArrows: false,
              showLabel: false,
              enableVibration: true,
              showSelectedValue: false,
            ),
            Text('Minutes', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        Column(
          children: [
            VerticalNumericSelector(
              minValue: 0,
              maxValue: 59,
              step: 1,
              initialValue: remainingSeconds,
              onValueChanged: onValueChanged,
              viewPort: 0.3,
              selectedTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              showArrows: false,
              showLabel: false,
              enableVibration: true,
              showSelectedValue: false,
            ),
            Text('Seconds', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
