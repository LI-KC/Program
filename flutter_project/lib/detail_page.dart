import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:intl/intl.dart';
import 'class/wakeIndexCalculator.dart';
import 'Widgets/Wave.dart';

class DetailPage extends StatefulWidget {
  List<List<SleepingRecord>>? lastSleepRecordListList;
  List<Duration>? globalDuration;

  DetailPage({
    Key? key,
    required this.lastSleepRecordListList,
    required this.globalDuration,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    // print('DETAIL INIT: ${widget.lastSleepRecordListList}');
    // print('Global Timer: ${widget.globalDuration}');
  }

  @override
  void dispose() {
    super.dispose();
    print('DETAIL DISPOSE: ${widget.lastSleepRecordListList}');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lastSleepRecordListList!.isEmpty ||
        widget.globalDuration!.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(''),
            backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
          ),
          body: Center(
            // child: Text(sleepRecordList.toString()),
            child: Wave(),
          ),
          backgroundColor: const Color.fromRGBO(5, 21, 31, 1));
    }
    List<SleepingRecord> lastSleepRecord = widget.lastSleepRecordListList!.last;

    String startHm = DateFormat.Hm().format(lastSleepRecord.first.initDateTime);
    String endHm = DateFormat.Hm().format(lastSleepRecord.last.initDateTime);
    Duration lastDuration = widget.globalDuration!.last;

    print('lastDuration ($startHm - $endHm): $lastDuration');
    // print('lastRecord: $lastSleepRecord, length: ${lastSleepRecord.length}');

    List<Map<String, SleepingRecord>> scoreList =
        WakeIndexCalculator.calculateSleepIndex(lastSleepRecord);

    print('scoreList: $scoreList');

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromRGBO(10, 52, 79, 1),
      ),
      body: Center(
        child: Wave.withData(
          startHm: startHm,
          endHm: startHm,
          scoreList: scoreList,
          lastDuration: lastDuration,
        ),
      ),
      backgroundColor: const Color.fromRGBO(5, 21, 31, 1),
    );
  }
}
