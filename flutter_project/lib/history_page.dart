import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:intl/intl.dart';
import 'Widgets/Wave.dart';

class HistoryPage extends StatefulWidget {
  List<List<SleepingRecord>>? sleepRecordListList;

  HistoryPage({
    Key? key,
    required this.sleepRecordListList,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String showingObj = '';
  List<SleepingRecord>? chosenList;

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

  DropdownMenuItem<List<SleepingRecord>> _getItem(List<String> dateTimeList) {
      dateTimeList.asMap().map((key, value) {
        return DropdownMenuItem<List<SleepingRecord>>(
                          value: ,
                          child: Text(value),
                        );
                      },
                    ).toList(),
      });
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
                  DropdownButton<List<SleepingRecord>>(
                    items: dateTimeList.map(
                      (value) {
                        return DropdownMenuItem<List<SleepingRecord>>(
                          value: ,
                          child: Text(value),
                        );
                      }
                    ).toList(),
                    onChanged: (_) {},
                    // onChanged: (String? newValue) {
                    //   setState(() {
                    //     showingObj = newValue!;
                    //   });
                    // },
                  ),
                ],
              ),
              Text(
                '$showingObj',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 21, 31, 1));
  }
}
  // 
