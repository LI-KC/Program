import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'class/FetchingDataHandler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'detail_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'package:tflite_audio/tflite_audio.dart';

void main() {
  runApp(const MyApp());
}

// record not finish

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Home Page',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // MyHomePage is passed
}

class _MyHomePageState extends State<MyHomePage> {
  String _sound = 'press the button to start';
  bool _recording = false;
  Stream<Map<dynamic, dynamic>>? recognitionStream;

  static List<SleepingRecord> sleepRecordList = [];
  static List<List<SleepingRecord>> sleepRecordListList = [];
  static List<List<SleepingRecord>> lastSleepRecordListList = [];
  static List<Duration> globalDuration = [];

  static bool globalEventFlag = false;

  static updateDuration(newDuration) {
    globalDuration.add(newDuration);
    print('on9: $globalDuration');
  }

  int _counter = 0;
  int _selectedIndex = 0;
  List<Widget> widgetOption = <Widget>[
    DetailPage(
      lastSleepRecordListList: lastSleepRecordListList,
      globalDuration: globalDuration,
    ),
    HomePage(
      sleepRecordList: sleepRecordList,
      globalDuration: globalDuration,
      popSleepRecordList: () {
        var newList = [...sleepRecordList];
        sleepRecordListList.add(newList);
        lastSleepRecordListList.add(newList);

        sleepRecordList.clear();
      },
      updateDuration: updateDuration,
      // globalEventFlag: globalEventFlag,
      // changeGlobalEventFlag: () {
      //   globalEventFlag = false;
      // },
    ),
    HistoryPage(
      sleepRecordListList: sleepRecordListList,
      globalDuration: globalDuration,
    ),
  ];

  @override
  void initState() {
    super.initState();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      var _gyroscopeValues = <double>[event.x, event.y, event.z]
          .reduce((value, element) => value + element.abs());
      if (_gyroscopeValues.abs() > 0.1) {
        print(_gyroscopeValues);
        globalEventFlag = true;
        FetchingDataHandler.globalEventFlag = globalEventFlag;
      }
    });

    // TfliteAudio.loadModel(
    //   model: 'assets/soundclassifier.tflite',
    //   label: 'assets/labels.txt',
    //   inputType: 'decodedWav',
    // );
  }

  // void _recorder() {
  //   String recognition = "";
  //   if (!_recording) {
  //     setState(() => _recording = true);
  //     recognitionStream = TfliteAudio.startAudioRecognition(
  //       numOfInferences: 1,
  //       inputType: 'rawAudio',
  //       sampleRate: 44100,
  //       recordingLength: 44032,
  //       bufferSize: 22016,
  //     );
  //     recognitionStream!.listen((event) {
  //       recognition = event["recognitionResult"];
  //     }).onDone(() {
  //       setState(() {
  //         _recording = false;
  //         _sound = recognition.split(" ")[1];
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(36, 159, 191, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Detail',
            backgroundColor: Color.fromRGBO(36, 159, 191, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dark_mode),
            label: 'Sleep',
            backgroundColor: Color.fromRGBO(36, 159, 191, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Color.fromRGBO(36, 159, 191, 1),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.safety_divider),
          //   label: 'Testing',
          //   backgroundColor: Color.fromRGBO(36, 159, 191, 1),
          // ),
        ],
        onTap: (int index) => setState(() {
          print(globalEventFlag);
          _selectedIndex = index;
        }),
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
      ),
      body: Center(
        child: widgetOption.elementAt(_selectedIndex),
      ),
    );
  }
}
