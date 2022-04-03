import 'package:intl/intl.dart';

class SleepingRecord {
  final DateTime initDateTime = DateTime.now();
  int snore = 0;
  int cough = 0;
  int bodyMovement = 0;

  ifSamePeriod() {
    // return DateTime.now()
    //     .isBefore(initDateTime.add(const Duration(minutes: 1)));
    return DateTime.now()
        .isBefore(initDateTime.add(const Duration(seconds: 20)));
  }

  SleepingRecord();

  SleepingRecord.havingData({
    required this.snore,
    required this.cough,
  });

  factory SleepingRecord.fromJson(Map<String, dynamic> json) {
    return SleepingRecord.havingData(
      snore: json['snore'],
      cough: json['cough'],
    );
  }

  @override
  toString() {
    return '$initDateTime snore: $snore cough: $cough bodymovement: $bodyMovement';
  }

  static void calculate(List<SleepingRecord> sleepRecordList) {}
}
