import 'dart:async';
import 'dart:convert';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:http/http.dart' as http;

class FetchingDataHandler {
  // static String ipAddress = '172.16.200.34';
  static String ipAddress = '192.168.1.141';

  static void fetchingSleepData(List<SleepingRecord> sleepRecordList) async {
    var res = await http.get(Uri.parse('http://$ipAddress:80/testing'));
    if (res.statusCode == 200) {
      var sleepRecord = SleepingRecord.fromJson(jsonDecode(res.body));
      print('Sleep Record: $sleepRecord');
      var currentSleepRecord = sleepRecordList.last;
      if (currentSleepRecord.ifSamePeriod()) {
        print('last: $currentSleepRecord');
        currentSleepRecord.cough += sleepRecord.cough;
        currentSleepRecord.snore += sleepRecord.snore;
        currentSleepRecord.bodyMovement += sleepRecord.bodyMovement;
      } else {
        sleepRecordList.add(sleepRecord);
      }
    }
  }

  static void printData(List<SleepingRecord> sleepRecordList) {
    sleepRecordList
        .asMap()
        .forEach((index, value) => print('${index + 1}: $value'));
  }
}
