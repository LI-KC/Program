import 'dart:async';
import 'dart:convert';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:http/http.dart' as http;

class FetchingDataHandler {
  static String? ipAddress;
  static bool globalEventFlag = false;

  static Future<void> init() async {
    var res = await http.get(Uri.parse('https://api.db-ip.com/v2/free/self'));
    Map<String, dynamic> jsonObj = jsonDecode(res.body);
    ipAddress = jsonObj['ipAddress'];
    print('ipAddress: $ipAddress');
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

  static void fetchFrameType(List<SleepingRecord> sleepRecordList) async {
    // var res = await http.get(Uri.parse('http://$ipAddress:80/frameType'));
    try {
      var res = await http.get(Uri.parse('http://172.16.186.232:80/frameType'));
      if (res.statusCode == 200) {
        Map<String, dynamic> jsonObj = jsonDecode(res.body);
        var frameType = jsonObj['type'];
        print('FrameType: $frameType');
        if (sleepRecordList.isEmpty) return;
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
          // print('eventflag: $eventFrag');
          if (globalEventFlag) {
            currentSleepRecord.bodyMovement += 1;
            print('increased one');
            globalEventFlag = false;
          }

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
          // print('eventflag: $eventFrag');
          if (globalEventFlag) {
            currentSleepRecord.bodyMovement += 1;
            print('increased one');
            globalEventFlag = false;
          }
          sleepRecordList.add(newSleepRecord);

          print('new: $newSleepRecord');
        }
      }
    } catch (err) {
      print(err);
    }
  }

  static void printData(List<SleepingRecord> sleepRecordList) {
    sleepRecordList.asMap().forEach(
          (index, value) => print('${index + 1}: $value'),
        );
  }
}
