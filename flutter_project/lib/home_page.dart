// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter_project/class/FetchingDataHandler.dart';
import 'package:flutter/material.dart';
import 'Widgets/sound_recorder.dart';
import 'class/SleepRecord.dart';
import 'package:intl/intl.dart';
import 'Widgets/timer_widget.dart';

class HomePage extends StatefulWidget {
  List<SleepingRecord>? sleepRecordList;
  final VoidCallback popSleepRecordList;
  List<Duration>? globalDuration;
  final Function updateDuration;

  // static bool globalEventFlag;
  // final VoidCallback changeGlobalEventFlag;

  HomePage({
    Key? key,
    required this.sleepRecordList,
    required this.popSleepRecordList,
    required this.globalDuration,
    required this.updateDuration,
    // required this.globalEventFlag,
    // required this.changeGlobalEventFlag,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? globalDurationTimer;
  Duration? indiGlobalDuration;

  final timerController = TimerController();
  Timer? timer;
  String? _weekDay;
  String? _dateTime;

  int SleepingScore = 100;
  int BodyMovement = 0;
  int Cough = 0;
  int Snore = 0;

  // late Future<List<Testing>> futureTestingList;
  SoundRecorder? recorder;

  @override
  void initState() {
    super.initState();

    // timer func
    _weekDay = DateFormat('EEEE').format(DateTime.now());
    _dateTime = DateFormat('HH:mm MMM').format(DateTime.now());
    timer = Timer.periodic(
      // 3 seconds -> 16000 * 3 samples per frame -> model training using 3 second per frame
      const Duration(milliseconds: 1),
      (Timer t) => setState(
        () {
          // print('big: ${widget.globalEventFlag}');
          _weekDay = DateFormat('EEEE').format(DateTime.now());
          _dateTime = DateFormat('HH:mm MMM').format(DateTime.now());
        },
      ),
    );

    // init recorder
    recorder = SoundRecorder(
        // widget.globalEventFlag,
        // widget.changeGlobalEventFlag,
        );
    recorder!.init();

    print('HOME INITTTTT: ${widget.sleepRecordList}');
  }

  @override
  void dispose() {
    recorder!.dispose();
    timer!.cancel();
    super.dispose();

    print('HOME DISPOSEEEEEEE: ${widget.sleepRecordList}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(5, 21, 31, 1),
                ),
                width: 400,
                height: 335,
                alignment: const Alignment(0, 0.75),
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, bottom: 35, right: 20),
                          child: Text(
                            _weekDay!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: Text(
                            _dateTime!,
                            style: const TextStyle(
                              color: Color.fromRGBO(185, 208, 223, 1),
                              fontSize: 27,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text(
                        'Start evaluating Your Sleep Today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TimerWidget(
                    controller: timerController,
                  )),
              buildStart(),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 21, 31, 1));
  }

  Widget buildStart() {
    bool isRecording = recorder!.isRecording;

    var icon = isRecording ? Icons.stop : Icons.mic;
    var text = isRecording ? 'STOP' : 'START';
    var primary = isRecording ? Colors.grey : Colors.white;
    var onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        if (!isRecording) {
          widget.sleepRecordList!.add(SleepingRecord());
          recorder!.passInRecordList(widget.sleepRecordList!);

          setState(() {
            indiGlobalDuration = const Duration();
          });

          globalDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
            const addSecond = 1;

            setState(() {
              final seconds = indiGlobalDuration!.inSeconds + addSecond;
              print(seconds);

              if (seconds < 0) {
                globalDurationTimer?.cancel();
              } else {
                indiGlobalDuration = Duration(seconds: seconds);
              }
            });
          });
        } else {
          FetchingDataHandler.printData(widget.sleepRecordList!);
          widget.popSleepRecordList();

          globalDurationTimer!.cancel();
          print(widget.globalDuration);
          widget.updateDuration(
            Duration(
              seconds: indiGlobalDuration!.inSeconds,
            ),
          );
        }

        await recorder!.toggleRecording();
        isRecording = recorder!.isRecording;

        if (isRecording) {
          timerController.startTimer();
        } else {
          timerController.stopTimer();
        }
        setState(() {});
        // fetchingSleepData();
        // outputData();
      },
    );
  }
}
