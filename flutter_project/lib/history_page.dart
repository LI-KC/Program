import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'class/wakeIndexCalculator.dart';
import 'package:intl/intl.dart';
import 'Widgets/Wave.dart';

class HistoryPage extends StatefulWidget {
  List<List<SleepingRecord>>? sleepRecordListList;
  List<Duration>? globalDuration;

  HistoryPage({
    Key? key,
    required this.sleepRecordListList,
    required this.globalDuration,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String showingObj = '';
  List<Map<String, double>>? scoreList;
  String? startHm, endHm;
  Duration? lastDuration;

  @override
  void initState() {
    super.initState();
    print('HISTORY INIT: ${widget.sleepRecordListList}');
  }

  @override
  void dispose() {
    super.dispose();
    print('HISTORY DISPOSE: ${widget.sleepRecordListList}');
  }

  List<DropdownMenuItem<Map<int, List<SleepingRecord>>>> _getItem(
      List<String> dateTimeList) {
    List<DropdownMenuItem<Map<int, List<SleepingRecord>>>> list = [];
    dateTimeList.asMap().forEach((key, value) {
      var aMap = {key: widget.sleepRecordListList![key]};
      var dropDownMenuItem = DropdownMenuItem<Map<int, List<SleepingRecord>>>(
        value: aMap,
        child: Text(value),
      );
      list.add(dropDownMenuItem);
    });
    return list;
  }

  void _setWaveInfo(Map<int, List<SleepingRecord>> aMapWithChosenList) {
    List<SleepingRecord> chosenList = [...aMapWithChosenList.values][0];
    String startHm = DateFormat.Hm().format(chosenList.first.initDateTime);
    String endHm = DateFormat.Hm().format(chosenList.last.initDateTime);
    this.startHm = startHm;
    this.endHm = endHm;
    scoreList = WakeIndexCalculator.calculateSleepIndex(chosenList);

    int index = [...aMapWithChosenList.keys][0];
    lastDuration = widget.globalDuration![index];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sleepRecordListList!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
        ),
        body: const Center(
          child: Text(
            "You do not have any history record yet",
            style: TextStyle(
              color: Color.fromRGBO(36, 159, 191, 1),
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 21, 31, 1),
      );
    }
    List<String> dateTimeList = [];
    widget.sleepRecordListList!.forEach((sleepRecordList) {
      String dateTime =
          DateFormat.yMd().format(sleepRecordList[0].initDateTime);
      dateTimeList.add(dateTime);
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
        ),
        body: Center(
          child: Column(
            children: [
              Wrap(
                children: [
                  const Text(
                    'Record: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                  DropdownButton<Map<int, List<SleepingRecord>>>(
                    items: _getItem(dateTimeList),
                    onChanged:
                        (Map<int, List<SleepingRecord>>? aMapWithChosenList) {
                      print(aMapWithChosenList.toString());
                      setState(() {
                        _setWaveInfo(aMapWithChosenList!);
                        showingObj = scoreList.toString();
                      });
                    },
                  ),
                ],
              ),
              Wave.withData(
                startHm: startHm,
                endHm: endHm,
                scoreList: scoreList,
                lastDuration: lastDuration,
              )
            ],
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 21, 31, 1));
  }
}
  // 
