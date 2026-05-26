import 'package:flutter/material.dart';
import 'package:timer/widgets/time_selector_column.dart';

class TimeSelector extends StatefulWidget {
  final int initialSeconds;
  final Function(int) onValueChanged;

  const TimeSelector({
    super.key,
    required this.initialSeconds,
    required this.onValueChanged,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    int? selectedSeconds =
        Duration(seconds: widget.initialSeconds).inSeconds % 60;
    int? selectedMinutes = Duration(
      seconds: widget.initialSeconds % 3600,
    ).inMinutes;
    int? selectedHours = Duration(seconds: widget.initialSeconds).inHours;
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
        TimeSelectorColumn(
          initialValue: selectedHours!,
          label: 'Hours',
          onValueChanged: (value) => setTime(null, null, value),
        ),
        SizedBox(width: 20),
        TimeSelectorColumn(
          initialValue: selectedMinutes!,
          label: 'Minutes',
          onValueChanged: (value) => setTime(null, value, null),
        ),
        SizedBox(width: 20),
        TimeSelectorColumn(
          initialValue: selectedSeconds!,
          label: 'Seconds',
          onValueChanged: (value) => setTime(value, null, null),
        ),
      ],
    );
  }
}
