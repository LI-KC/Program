import 'package:intl/intl.dart';

import 'SleepRecord.dart';

class WakeIndexCalculator {
  static int _convertToActiveScore(dynamic input) {
    if (input is SleepingRecord) return input.bodyMovement * 18;
    return 0;
  }

  static void _handlingSleepCase(List<Map<String, SleepingRecord>> scoreList) {
    var index = 0;
    while (index < scoreList.length) {
      int wakeCount = 0;
      int sleepCount = 0;
      while ([...(scoreList[index + wakeCount]).values][0].sleepIndex >= 10) {
        wakeCount++;
        if (index + wakeCount >= scoreList.length) break;
      }
      while ([...(scoreList[index + sleepCount]).values][0].sleepIndex < 10) {
        sleepCount++;
        if (index + sleepCount >= scoreList.length) break;
      }
      if (sleepCount <= 9) {
        int beforeWakeCount = 0;
        int afterWakeCount = 0;
        int currentIndex = index + sleepCount;
        if (index - 1 < 0) {
          index++;
          continue;
        }
        if (currentIndex + 1 >= scoreList.length) {
          index++;
          continue;
        }
        while ([...(scoreList[index - beforeWakeCount - 1]).values][0]
                .sleepIndex >=
            10) {
          beforeWakeCount++;
          if (index - beforeWakeCount - 1 < 0) break;
        }
        while ([...(scoreList[currentIndex + afterWakeCount + 1]).values][0]
                .sleepIndex >=
            10) {
          afterWakeCount++;
          if (index + afterWakeCount + 1 >= scoreList.length) break;
        }
        if (sleepCount <= 5) {
          if (beforeWakeCount + afterWakeCount >= 10) {
            var selectedIndex = index;
            for (selectedIndex;
                selectedIndex < index + sleepCount + 1;
                selectedIndex++) {
              [...scoreList[selectedIndex].values][0].sleepIndex = 10;
            }
            index = currentIndex + afterWakeCount + 1;
          }
        }
        if (beforeWakeCount + afterWakeCount >= 20) {
          var selectedIndex = index;
          for (selectedIndex;
              selectedIndex < index + sleepCount + 1;
              selectedIndex++) {
            [...scoreList[selectedIndex].values][0].sleepIndex = 10;
          }
          index = currentIndex + afterWakeCount + 1;
        }
        index++;
        continue;
      }
      if (wakeCount >= 4 && wakeCount <= 9) {
        var selectedIndex = index + wakeCount + 1;
        if (selectedIndex >= scoreList.length) {
          index++;
          continue;
        }
        [...scoreList[selectedIndex].values][0].sleepIndex = 10;
        index = selectedIndex + 1;
      } else if (wakeCount >= 10 && wakeCount <= 14) {
        var selectedIndex = index + wakeCount + 1;
        for (selectedIndex;
            selectedIndex < index + wakeCount + 4;
            selectedIndex++) {
          if (selectedIndex >= scoreList.length) {
            index++;
            continue;
          }
          [...scoreList[selectedIndex].values][0].sleepIndex = 10;
        }
        index = selectedIndex + 1;
      } else if (wakeCount >= 15) {
        var selectedIndex = index + wakeCount + 1;
        for (selectedIndex;
            selectedIndex < index + wakeCount + 5;
            selectedIndex++) {
          if (selectedIndex >= scoreList.length) {
            index++;
            continue;
          }
          [...scoreList[selectedIndex].values][0].sleepIndex = 10;
        }
        index = selectedIndex + 1;
      }
      index++;
    }
  }

  static List<Map<String, SleepingRecord>> calculateSleepIndex(
      List<SleepingRecord> sleepRecordListWithLength7) {
    List<Map<String, SleepingRecord>> wakeIndexList = [];
    var sleepRecordList = sleepRecordListWithLength7;
    sleepRecordList.asMap().forEach((index, value) {
      // print('index: $index');
      int lastTwo = sleepRecordList.length - 2;
      int lastOne = sleepRecordList.length - 1;
      int a_4 = 0, a_3 = 0, a_2 = 0, a_1 = 0, a_0 = 0, a1 = 0, a2 = 0;
      if (index == 0) {
        a_0 = _convertToActiveScore(sleepRecordList[0]);
        a1 = _convertToActiveScore(sleepRecordList[1]);
        a2 = _convertToActiveScore(sleepRecordList[2]);
      } else if (index == 1) {
        a_1 = _convertToActiveScore(sleepRecordList[0]);
        a_0 = _convertToActiveScore(sleepRecordList[1]);
        a1 = _convertToActiveScore(sleepRecordList[2]);
        a2 = _convertToActiveScore(sleepRecordList[3]);
      } else if (index == 2) {
        a_2 = _convertToActiveScore(sleepRecordList[0]);
        a_1 = _convertToActiveScore(sleepRecordList[1]);
        a_0 = _convertToActiveScore(sleepRecordList[2]);
        a1 = _convertToActiveScore(sleepRecordList[3]);
        a2 = _convertToActiveScore(sleepRecordList[4]);
      } else if (index == 3) {
        a_3 = _convertToActiveScore(sleepRecordList[0]);
        a_2 = _convertToActiveScore(sleepRecordList[1]);
        a_1 = _convertToActiveScore(sleepRecordList[2]);
        a_0 = _convertToActiveScore(sleepRecordList[3]);
        a1 = _convertToActiveScore(sleepRecordList[4]);
        a2 = _convertToActiveScore(sleepRecordList[5]);
      } else if (index == lastTwo) {
        a_4 = _convertToActiveScore(sleepRecordList[index - 4]);
        a_3 = _convertToActiveScore(sleepRecordList[index - 3]);
        a_2 = _convertToActiveScore(sleepRecordList[index - 2]);
        a_1 = _convertToActiveScore(sleepRecordList[index - 1]);
        a_0 = _convertToActiveScore(sleepRecordList[index]);
        a1 = _convertToActiveScore(sleepRecordList[index + 1]);
      } else if (index == lastOne) {
        a_4 = _convertToActiveScore(sleepRecordList[index - 4]);
        a_3 = _convertToActiveScore(sleepRecordList[index - 3]);
        a_2 = _convertToActiveScore(sleepRecordList[index - 2]);
        a_1 = _convertToActiveScore(sleepRecordList[index - 1]);
        a_0 = _convertToActiveScore(sleepRecordList[index]);
      } else {
        a_4 = _convertToActiveScore(sleepRecordList[index - 4]);
        a_3 = _convertToActiveScore(sleepRecordList[index - 3]);
        a_2 = _convertToActiveScore(sleepRecordList[index - 2]);
        a_1 = _convertToActiveScore(sleepRecordList[index - 1]);
        a_0 = _convertToActiveScore(sleepRecordList[index]);
        a1 = _convertToActiveScore(sleepRecordList[index + 1]);
        a2 = _convertToActiveScore(sleepRecordList[index + 2]);
      }
      double finalScore = 0.125 *
          (0.15 * a_4 +
              0.15 * a_3 +
              0.15 * a_2 +
              0.08 * a_1 +
              0.21 * a_0 +
              0.12 * a1 +
              0.13 * a2);
      value.sleepIndex = double.parse(finalScore.toStringAsFixed(2));
      Map<String, SleepingRecord> wakeIndexMap = {
        DateFormat.Hm().format(value.initDateTime): value
      };
      wakeIndexList.add(wakeIndexMap);
    });
    _handlingSleepCase(wakeIndexList);
    return wakeIndexList;
  }
}
