import 'package:flutter/material.dart';
import 'package:timer/widgets/time_selector.dart';

class SetRestLabel extends StatelessWidget {
  const SetRestLabel({
    super.key,
    required this.restSeconds,
    required this.onRestChanged,
  });
  final int restSeconds;
  final void Function(int) onRestChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Configurar descanso',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  TimeSelector(
                    onValueChanged: onRestChanged,
                    initialSeconds: restSeconds,
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Aceptar'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Text(
        'Configurar descanso (${Duration(seconds: restSeconds).inHours.toString().padLeft(2, '0')}:${(Duration(seconds: restSeconds).inMinutes % 60).toString().padLeft(2, '0')}:${(Duration(seconds: restSeconds).inSeconds % 60).toString().padLeft(2, '0')})',
      ),
    );
  }
}
