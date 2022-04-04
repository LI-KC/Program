import 'SleepRecord.dart';

class WakeIndexCalculator {
  static int _convertToActiveScore(dynamic input) {
    if (input is SleepingRecord) return input.bodyMovement * 15;
    return 0;
  }

  static List<double> calculateSleepIndex(
      List<SleepingRecord> sleepRecordListWithLength7) {
    List<double> wakeIndexList = [];
    var sleepRecordList = sleepRecordListWithLength7;
    sleepRecordList.asMap().forEach((index, value) {
      print('index: $index');
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
      wakeIndexList.add(double.parse(finalScore.toStringAsFixed(2)));
    });
    return wakeIndexList;
  }
}
