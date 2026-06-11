import 'package:timezone/timezone.dart' as tz;

class TimerSession {
  DateTime startTime; // Se mantendrá compatible, pero se parseará controlado
  int workSeconds;
  int restSeconds;
  int totalRounds;
  bool isPaused;
  int elapsedBeforePause;

  TimerSession({
    required this.startTime,
    required this.workSeconds,
    required this.restSeconds,
    required this.totalRounds,
    this.isPaused = false,
    this.elapsedBeforePause = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'totalRounds': totalRounds,
      'isPaused': isPaused,
      'elapsedBeforePause': elapsedBeforePause,
    };
  }

  factory TimerSession.fromJson(Map<String, dynamic> json) {
    // CLAVE: Forzamos a que el string guardado sea interpretado bajo la locación de la app
    final parsedUtc = DateTime.parse(json['startTime']).toUtc();
    final location = tz.getLocation('America/Mexico_City');

    return TimerSession(
      startTime: tz.TZDateTime.from(
        parsedUtc,
        location,
      ), // <-- Convertido a la zona correcta
      workSeconds: json['workSeconds'],
      restSeconds: json['restSeconds'],
      totalRounds: json['totalRounds'],
      isPaused: json['isPaused'],
      elapsedBeforePause: json['elapsedBeforePause'],
    );
  }
}
