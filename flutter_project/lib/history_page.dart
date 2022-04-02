import 'package:flutter/material.dart';
import 'package:flutter_project/class/SleepRecord.dart';
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
                  DropdownButton<String>(
                    items: ['A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {
                      // currentList = _;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 21, 31, 1));
  }
}
  // 
