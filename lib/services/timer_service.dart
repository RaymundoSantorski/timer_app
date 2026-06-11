import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/models/timer_session.dart';
import 'package:timezone/timezone.dart' as tz;

TimerState calculateState(TimerSession session) {
  // Usamos tz.local ya que en NotificationService lo fijaste como 'America/Mexico_City'
  DateTime now = tz.TZDateTime.now(tz.local);

  int workSeconds = session.workSeconds;
  int restSeconds = session.restSeconds;
  int totalRounds = session.totalRounds;
  bool isPaused = session.isPaused;
  int elapsedBeforePause = session.elapsedBeforePause;

  // Asegurar que comparamos manzanas con manzanas
  final sessionStartTZ = tz.TZDateTime.from(session.startTime, tz.local);
  int elapsed = now.difference(sessionStartTZ).inSeconds;

  int durationPerRound = workSeconds + restSeconds;
  int currentRound = (elapsed ~/ durationPerRound) + 1;
  int roundElapsed = elapsed % durationPerRound;
  bool isResting = roundElapsed >= workSeconds;
  int remainingSeconds = isResting
      ? durationPerRound - roundElapsed
      : workSeconds - roundElapsed;

  return TimerState(
    isRunning: isPaused
        ? false
        : elapsed < (totalRounds * durationPerRound - restSeconds),
    isResting: isResting,
    isPaused: isPaused,
    currentRound: currentRound > totalRounds ? totalRounds : currentRound,
    remainingSeconds: remainingSeconds,
    elapsedBeforePause: elapsedBeforePause,
    isFinished: elapsed >= (totalRounds * durationPerRound - restSeconds),
  );
}

int calculateElapsed(TimerSession session) {
  DateTime now = tz.TZDateTime.now(tz.local);
  final sessionStartTZ = tz.TZDateTime.from(session.startTime, tz.local);
  return now.difference(sessionStartTZ).inSeconds;
}

class TimerService {
  static Future<void> save(TimerSession session) async {
    // Save session to persistent storage (e.g., SharedPreferences, Hive, etc.)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('timerSession', jsonEncode(session.toJson()));
  }

  static Future<TimerSession?> load() async {
    // Load session from persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionString = prefs.getString('timerSession');
    if (sessionString != null) {
      Map<String, dynamic> sessionJson = jsonDecode(sessionString);
      return TimerSession.fromJson({
        'startTime': sessionJson['startTime'],
        'workSeconds': sessionJson['workSeconds'],
        'restSeconds': sessionJson['restSeconds'],
        'totalRounds': sessionJson['totalRounds'],
        'isPaused': sessionJson['isPaused'],
        'elapsedBeforePause': sessionJson['elapsedBeforePause'],
      });
    }
    return null;
  }

  static Future<void> clear() async {
    // Clear session from persistent storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('timerSession');
  }
}

class TimerState {
  TimerState({
    required this.isRunning,
    required this.isResting,
    required this.currentRound,
    required this.remainingSeconds,
    required this.isPaused,
    required this.elapsedBeforePause,
    required this.isFinished,
  });
  bool isRunning;
  bool isResting;
  int currentRound;
  int remainingSeconds;
  bool isPaused;
  int elapsedBeforePause;
  bool isFinished;
}
