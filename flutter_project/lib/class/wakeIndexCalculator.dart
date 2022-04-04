import 'SleepRecord.dart';

class wakeIndexCalculator {
  static double _convertToActiveScore(dynamic input) {
    if (input is SleepingRecord) return input.bodyMovement / 20;
    return 0;
  }

  static List<int> calculateSleepIndex(List<SleepingRecord> sleepRecordList) {
    var wakeIndexList = [];
    sleepRecordList.asMap().forEach((index, value) {
      double a_4 = 0, a_3 = 0, a_2 = 0, a_1 = 0, a_0 = 0, a1 = 0, a2 = 0;
      switch (index) {
        case (0):
          a_0 = _convertToActiveScore(sleepRecordList[0]);
          a1 = _convertToActiveScore(sleepRecordList[1]);
          a2 = _convertToActiveScore(sleepRecordList[2]);
          break;
        case (1):
          a_1 = _convertToActiveScore(sleepRecordList[0]);
          a_0 = _convertToActiveScore(sleepRecordList[1]);
          a1 = _convertToActiveScore(sleepRecordList[2]);
          a2 = _convertToActiveScore(sleepRecordList[3]);
          break;
        case (2):
          a_2 = _convertToActiveScore(sleepRecordList[0]);
          a_1 = _convertToActiveScore(sleepRecordList[1]);
          a_0 = _convertToActiveScore(sleepRecordList[2]);
          a1 = _convertToActiveScore(sleepRecordList[3]);
          a2 = _convertToActiveScore(sleepRecordList[4]);
          break;
        case (3):
          a_3 = _convertToActiveScore(sleepRecordList[0]);
          a_2 = _convertToActiveScore(sleepRecordList[1]);
          a_1 = _convertToActiveScore(sleepRecordList[2]);
          a_0 = _convertToActiveScore(sleepRecordList[3]);
          a1 = _convertToActiveScore(sleepRecordList[4]);
          a2 = _convertToActiveScore(sleepRecordList[5]);
          break;
        case (4):
          a_4 = _convertToActiveScore(sleepRecordList[0]);
          a_3 = _convertToActiveScore(sleepRecordList[1]);
          a_2 = _convertToActiveScore(sleepRecordList[2]);
          a_1 = _convertToActiveScore(sleepRecordList[3]);
          a_0 = _convertToActiveScore(sleepRecordList[4]);
          a1 = _convertToActiveScore(sleepRecordList[5]);
          a2 = _convertToActiveScore(sleepRecordList[6]);
          break;
        case (5):
          a_4 = _convertToActiveScore(sleepRecordList[0]);
          a_3 = _convertToActiveScore(sleepRecordList[1]);
          a_2 = _convertToActiveScore(sleepRecordList[2]);
          a_1 = _convertToActiveScore(sleepRecordList[3]);
          a_0 = _convertToActiveScore(sleepRecordList[4]);
          a1 = _convertToActiveScore(sleepRecordList[5]);
          a2 = _convertToActiveScore(sleepRecordList[6]);
          break;
        default:
          a_4 = _convertToActiveScore(sleepRecordList[index - 4]);
          a_3 = _convertToActiveScore(sleepRecordList[index - 3]);
          a_2 = _convertToActiveScore(sleepRecordList[index - 2]);
          a_1 = _convertToActiveScore(sleepRecordList[index - 1]);
          a_0 = _convertToActiveScore(sleepRecordList[index]);
          a1 = _convertToActiveScore(sleepRecordList[index + 1]);
          a2 = _convertToActiveScore(sleepRecordList[index + 2]);
          break;
        case ():
          
      }
    });
  }
}
