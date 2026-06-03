class TimerSession {
  DateTime startTime;
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
    return TimerSession(
      startTime: DateTime.parse(json['startTime']),
      workSeconds: json['workSeconds'],
      restSeconds: json['restSeconds'],
      totalRounds: json['totalRounds'],
      isPaused: json['isPaused'],
      elapsedBeforePause: json['elapsedBeforePause'],
    );
  }
}
