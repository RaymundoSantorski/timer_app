// Durante 15 días toqué el proyecto, no fue perfecto, pero fue constante.

import 'package:flutter/material.dart';
import 'package:timer/models/timer_session.dart';
import 'package:timer/services/notification_service.dart';
import 'package:timer/services/timer_service.dart';
import 'package:timer/widgets/runninfab.dart';
import 'package:timer/widgets/set_rest_label.dart';
import 'package:timer/widgets/stoppedfab.dart';
import 'package:timer/widgets/time_selector.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'package:timer/widgets/work_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final lightColorScheme = ColorScheme(
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFF97316),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    brightness: Brightness.light,
  );

  final darkColorScheme = ColorScheme(
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFFB923C),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFF87171),
    onError: Color(0xFF000000),
    surface: Color(0xFF111827),
    onSurface: Color(0xFFF3F4F6),
    brightness: Brightness.dark,
  );

  ThemeMode currentMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    void setThemeMode(ThemeMode mode) {
      setState(() {
        currentMode = mode;
      });
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      themeMode: currentMode,
      home: MyHomePage(title: 'RepTimer', setThemeMode: setThemeMode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.setThemeMode,
  });
  final String title;
  final Function(ThemeMode) setThemeMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int workSeconds = 60;
  int remainingSeconds = 60;
  int restSeconds = 30;
  bool isResting = false;
  bool isRunning = false;
  bool isPaused = false;
  int elapsedBeforePause = 0;
  int totalRounds = 3;
  int currentRound = 1;
  Timer? timer;
  bool darkMode = false;
  SharedPreferences? prefs;
  bool selectorVersion = false;
  TimerSession? session;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    darkMode = prefs?.getBool('darkMode') ?? false;
    if (darkMode) {
      widget.setThemeMode(ThemeMode.dark);
    } else {
      widget.setThemeMode(ThemeMode.light);
    }
    if (!mounted) return;
    TimerSession? savedSession = await TimerService.load();
    setState(() {
      if (savedSession != null) {
        if (savedSession.isPaused) {
          session = TimerSession(
            startTime: DateTime.now().subtract(
              Duration(seconds: savedSession.elapsedBeforePause),
            ),
            workSeconds: savedSession.workSeconds,
            restSeconds: savedSession.restSeconds,
            totalRounds: savedSession.totalRounds,
            isPaused: true,
            elapsedBeforePause: savedSession.elapsedBeforePause,
          );
        } else {
          session = savedSession;
        }
        workSeconds = session!.workSeconds;
        restSeconds = session!.restSeconds;
        totalRounds = session!.totalRounds;
        TimerState state = calculateState(session!);
        isRunning = state.isRunning;
        isResting = state.isResting;
        currentRound = state.currentRound;
        remainingSeconds = state.remainingSeconds;
        isPaused = state.isPaused;
        elapsedBeforePause = state.elapsedBeforePause;
        if (isRunning && !isPaused) {
          startTimer();
        }
      } else {
        workSeconds = prefs?.getInt('workSeconds') ?? workSeconds;
        restSeconds = prefs?.getInt('restSeconds') ?? restSeconds;
        totalRounds = prefs?.getInt('totalRounds') ?? totalRounds;
        isRunning = false;
        isResting = false;
        isPaused = false;
        remainingSeconds = workSeconds;
      }
      selectorVersion = !selectorVersion;
    });
  }

  void toggleDarkMode(bool value) {
    setState(() {
      darkMode = value;
    });
    if (value) {
      widget.setThemeMode(ThemeMode.dark);
      prefs?.setBool('darkMode', true);
    } else {
      widget.setThemeMode(ThemeMode.light);
      prefs?.setBool('darkMode', false);
    }
  }

  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500);
    }
  }

  void pauseTimer() {
    if (session != null) {
      timer?.cancel();
      setState(() {
        isRunning = false;
        isPaused = true;
        elapsedBeforePause = calculateElapsed(session!);
        session = TimerSession(
          startTime: session!.startTime,
          workSeconds: session!.workSeconds,
          restSeconds: session!.restSeconds,
          totalRounds: session!.totalRounds,
          isPaused: true,
          elapsedBeforePause: elapsedBeforePause,
        );
        TimerService.save(session!);
      });
    }
  }

  void resetTimer() {
    timer?.cancel();
    TimerService.clear();
    setState(() {
      workSeconds = prefs?.getInt('workSeconds') ?? 60;
      remainingSeconds = workSeconds;
      isPaused = false;
      restSeconds = prefs?.getInt('restSeconds') ?? 30;
      isResting = false;
      isRunning = false;
      totalRounds = prefs?.getInt('totalRounds') ?? 3;
      currentRound = 1;
      session = null;
    });
  }

  void startTimer() {
    if (session == null || calculateState(session!).isFinished) {
      session = TimerSession(
        startTime: DateTime.now(),
        workSeconds: workSeconds,
        restSeconds: restSeconds,
        totalRounds: totalRounds,
        isPaused: false,
        elapsedBeforePause: elapsedBeforePause,
      );
    } else if (isPaused) {
      session = TimerSession(
        startTime: DateTime.now().subtract(
          Duration(seconds: elapsedBeforePause),
        ),
        workSeconds: session!.workSeconds,
        restSeconds: session!.restSeconds,
        totalRounds: session!.totalRounds,
        isPaused: false,
        elapsedBeforePause: elapsedBeforePause,
      );
    }
    TimerService.save(session!);
    setState(() {
      isRunning = true;
      isPaused = false;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (session == null) {
        timer.cancel();
        return;
      }
      final state = calculateState(session!);
      if (state.isFinished) {
        resetTimer();
      } else {
        setState(() {
          isRunning = state.isRunning;
          isResting = state.isResting;
          isPaused = state.isPaused;
          currentRound = state.currentRound;
          remainingSeconds = state.remainingSeconds;
        });
      }
    });
  }

  void decrementRounds() {
    if (totalRounds > 1) {
      prefs?.setInt('totalRounds', totalRounds - 1);
      setState(() {
        totalRounds--;
      });
    }
  }

  void incrementRounds() {
    prefs?.setInt('totalRounds', totalRounds + 1);
    setState(() {
      totalRounds++;
    });
  }

  void setRestSeconds(int seconds) {
    prefs?.setInt('restSeconds', seconds);
    setState(() {
      restSeconds = seconds;
    });
  }

  void setWorkSeconds(int seconds) {
    prefs?.setInt('workSeconds', seconds);
    setState(() {
      workSeconds = seconds;
      remainingSeconds = seconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isRunning
          ? StoppedFAB(onPressed: startTimer, disabled: workSeconds == 0)
          : RunningFAB(
              onStopped: resetTimer,
              onPaused: pauseTimer,
              onResumed: startTimer,
              isRunning: isRunning,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [Switch(value: darkMode, onChanged: toggleDarkMode)],
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (isRunning || isPaused)
              ? Title(
                  key: Key('statusText_$selectorVersion'),
                  color: Colors.black,
                  child: Text(
                    isResting ? 'Rest Time' : 'Work Time',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: isResting
                          ? ColorScheme.of(context).error
                          : Colors.lightGreen,
                    ),
                  ),
                )
              : SetRestLabel(
                  restSeconds: restSeconds,
                  onRestChanged: setRestSeconds,
                ),
          isRunning || isPaused
              ? Text(
                  'Round $currentRound of $totalRounds',
                  key: Key('roundText_$selectorVersion'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 30),
                      onPressed: decrementRounds,
                    ),
                    Text(
                      '$totalRounds rounds',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 30),
                      onPressed: incrementRounds,
                    ),
                  ],
                ),
          (!isRunning && !isPaused)
              ? TimeSelector(
                  key: Key('$selectorVersion'),
                  onValueChanged: setWorkSeconds,
                  initialSeconds: workSeconds,
                )
              : WorkTime(
                  workSeconds: remainingSeconds,
                  key: Key('workTime_$selectorVersion'),
                ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
