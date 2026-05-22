// Durante 15 días toqué el proyecto, no fue perfecto, pero fue constante.

import 'package:flutter/material.dart';
import 'package:numeric_selector/numeric_selector.dart';
import 'package:timer/widgets/runninfab.dart';
import 'package:timer/widgets/stoppedfab.dart';
import 'package:timer/widgets/time_selector.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'package:timer/widgets/button_row.dart';
import 'package:timer/widgets/work_time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme,
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

  /// Esta función incrementa el numero de segundos de ejercicio en 1,
  ///  se llama cada vez que el botón incrementar es presionado.
  void increment() {
    setWorkSeconds(workSeconds + 1);
  }

  void setWorkSeconds(int seconds) {
    setState(() {
      workSeconds = seconds;
      remainingSeconds = seconds;
    });
  }

  /// Esta funcion resta uno al numero de segundos de ejercicio en 1,
  /// se llama cada vez que el botón decrementar el presionado.
  /// Si el numero de segundos es 0, no hace nada.
  void decrement() {
    if (workSeconds == 0) return;
    setWorkSeconds(workSeconds - 1);
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
                      color: isResting ? Colors.redAccent : Colors.lightGreen,
                    ),
                  ),
                )
              : TextButton(
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 30),
                                    onPressed: () {
                                      if (restSeconds <= 1) return;
                                      setState(() {
                                        restSeconds--;
                                      });
                                    },
                                  ),
                                  Text(
                                    '$restSeconds s',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 30),
                                    onPressed: () {
                                      setState(() {
                                        restSeconds++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Configurar descanso (${restSeconds}s)'),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
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
              IconButton(
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
                  workSeconds: workSeconds,
                )
              : WorkTime(workSeconds: remainingSeconds),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
