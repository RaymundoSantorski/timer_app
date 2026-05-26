// Durante 15 días toqué el proyecto, no fue perfecto, pero fue constante.

import 'package:flutter/material.dart';
import 'package:timer/widgets/runninfab.dart';
import 'package:timer/widgets/set_rest_label.dart';
import 'package:timer/widgets/stoppedfab.dart';
import 'package:timer/widgets/time_selector.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'package:timer/widgets/work_time.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      home: const MyHomePage(title: 'RepTimer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int workSeconds = 0;
  int remainingSeconds = 0;
  int restSeconds = 5;
  bool isResting = false;
  bool isRunning = false;
  bool isPaused = false;
  int totalRounds = 3;
  int currentRound = 1;
  Timer? timer;

  void resetTimer() {
    timer?.cancel();
    setState(() {
      workSeconds = 0;
      remainingSeconds = 0;
      isPaused = false;
      restSeconds = 5;
      isResting = false;
      isRunning = false;
      totalRounds = 3;
      currentRound = 1;
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (isResting) {
        if (remainingSeconds == 0) {
          setState(() {
            isResting = false;
            remainingSeconds = workSeconds;
            incrementRound();
          });
          vibrate();
          return;
        }
        setState(() {
          remainingSeconds--;
        });
        return;
      } else {
        if (remainingSeconds == 0) {
          setState(() {
            isResting = true;
            remainingSeconds = restSeconds;
          });
          vibrate();
          return;
        }
        setState(() {
          remainingSeconds--;
        });
        return;
      }
    });
  }

  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500);
    } else {
      print('No tiene vibrador');
    }
  }

  void stopTimer() {
    timer?.cancel();
  }

  void setWorkSeconds(int seconds) {
    setState(() {
      workSeconds = seconds;
      remainingSeconds = seconds;
    });
  }

  void incrementRound() {
    if (currentRound <= totalRounds) {
      setState(() {
        currentRound++;
        remainingSeconds = workSeconds;
        if (currentRound > totalRounds) {
          isRunning = false;
          timer?.cancel();
          currentRound = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isRunning
          ? StoppedFAB(
              onPressed: () {
                setState(() {
                  isRunning = true;
                  isPaused = false;
                });
                startTimer();
              },
              disabled: workSeconds == 0,
            )
          : RunningFAB(
              onStopped: () {
                stopTimer();
                resetTimer();
              },
              onPaused: () {
                stopTimer();
                setState(() {
                  isRunning = false;
                  isPaused = true;
                });
              },
              onResumed: () {
                startTimer();
                setState(() {
                  isRunning = true;
                  isPaused = false;
                });
              },
              isRunning: isRunning,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (isRunning | isPaused)
              ? Title(
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
                  onRestChanged: (value) {
                    setState(() {
                      restSeconds = value;
                    });
                  },
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isRunning || isPaused
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Icon(Icons.remove, size: 30),
                      onPressed: () {
                        if (totalRounds <= 1) return;
                        setState(() {
                          totalRounds--;
                        });
                      },
                    ),
              Text(
                'Round $currentRound/$totalRounds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              isRunning || isPaused
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Icon(Icons.add, size: 30),
                      onPressed: () {
                        setState(() {
                          totalRounds++;
                        });
                      },
                    ),
            ],
          ),
          (!isRunning && !isPaused)
              ? TimeSelector(
                  onValueChanged: setWorkSeconds,
                  initialSeconds: workSeconds,
                )
              : WorkTime(workSeconds: remainingSeconds),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
