import 'package:flutter/material.dart';
import 'package:numeric_selector/numeric_selector.dart';

class TimeSelector extends StatefulWidget {
  final int workSeconds;
  final Function(int) onValueChanged;

  const TimeSelector({
    super.key,
    required this.workSeconds,
    required this.onValueChanged,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    int? selectedSeconds = Duration(seconds: widget.workSeconds).inSeconds % 60;
    int? selectedMinutes = Duration(
      seconds: widget.workSeconds % 3600,
    ).inMinutes;
    int? selectedHours = Duration(seconds: widget.workSeconds).inHours;
    void setTime(int? seconds, int? minutes, int? hours) {
      selectedSeconds = seconds ?? selectedSeconds;
      selectedMinutes = minutes ?? selectedMinutes;
      selectedHours = hours ?? selectedHours;
      int totalSeconds =
          (selectedHours! * 3600) + (selectedMinutes! * 60) + selectedSeconds!;
      widget.onValueChanged(totalSeconds);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            VerticalNumericSelector(
              minValue: 0,
              maxValue: 59,
              step: 1,
              initialValue: selectedHours!,
              onValueChanged: (value) => setTime(null, null, value),
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
              initialValue: selectedMinutes!,
              onValueChanged: (value) => setTime(null, value, null),
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
              initialValue: selectedSeconds!,
              onValueChanged: (value) => setTime(value, null, null),
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
