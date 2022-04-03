import 'dart:async';
import 'dart:convert';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;

class FetchingDataHandler {
  static String? ipAddress;

  static Future<void> init() async {
    var res = await http.get(Uri.parse('https://api.db-ip.com/v2/free/self'));
    Map<String, dynamic> jsonObj = jsonDecode(res.body);
    ipAddress = jsonObj['ipAddress'];
    print(ipAddress);
  }

  static void fetchingSleepData(List<SleepingRecord> sleepRecordList) async {
    var res = await http.get(Uri.parse('http://$ipAddress:80/frameType'));
    if (res.statusCode == 200) {
      var sleepRecord = SleepingRecord.fromJson(jsonDecode(res.body));
      print('Sleep Record: $sleepRecord');
      var currentSleepRecord = sleepRecordList.last;
      if (currentSleepRecord.ifSamePeriod()) {
        print('last: $currentSleepRecord');
        currentSleepRecord.cough += sleepRecord.cough;
        currentSleepRecord.snore += sleepRecord.snore;
      } else {
        sleepRecordList.add(sleepRecord);
      }
    }
  }

  static void fetchFrameType(
      List<SleepingRecord> sleepRecordList, eventFrag) async {
    // var res = await http.get(Uri.parse('http://$ipAddress:80/frameType'));
    var res = await http.get(Uri.parse('http://172.16.187.131:80/frameType'));
    if (res.statusCode == 200) {
      Map<String, dynamic> jsonObj = jsonDecode(res.body);
      var frameType = jsonObj['type'];
      print('FrameType: $frameType');
      var currentSleepRecord = sleepRecordList.last;
      if (currentSleepRecord.ifSamePeriod()) {
        switch (frameType) {
          case 'Cough':
            currentSleepRecord.cough += 1;
            break;
          case 'Snore':
            currentSleepRecord.snore += 1;
            break;
          case 'None':
            break;
          default:
            break;
        }
        if (eventFrag) currentSleepRecord.bodyMovement += 1;

        print('last: $currentSleepRecord');
      } else {
        var newSleepRecord = SleepingRecord();
        switch (frameType) {
          case 'Cough':
            newSleepRecord.cough += 1;
            break;
          case 'Snore':
            newSleepRecord.snore += 1;
            break;
          case 'None':
            break;
          default:
            break;
        }
        newSleepRecord.bodyMovement += 1;
        sleepRecordList.add(newSleepRecord);

        print('new: $newSleepRecord');
      }
    }
  }

  static void printData(List<SleepingRecord> sleepRecordList) {
    sleepRecordList.asMap().forEach(
          (index, value) => print('${index + 1}: $value'),
        );
  }
}
