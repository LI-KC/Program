import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';
import 'history_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

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
  static List<SleepingRecord> sleepRecordList = [];
  static List<List<SleepingRecord>> sleepRecordListList = [];
  static List<List<SleepingRecord>> lastSleepRecordListList = [];
  static List<Duration> globalDuration = [];

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
    ),
    HistoryPage(
      sleepRecordListList: sleepRecordListList,
    ),
    // Text(
    //   globalDuration.toString(),
    // ),
  ];

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
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.safety_divider),
          //     label: 'Testing',
          //     backgroundColor: Color.fromRGBO(36, 159, 191, 1),
          //   ),
        ],
        onTap: (int index) => setState(() {
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
