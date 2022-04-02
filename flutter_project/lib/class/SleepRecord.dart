import 'package:intl/intl.dart';

class SleepingRecord {
  final DateTime date = DateTime.now();
  int snore = 0;
  int cough = 0;
  int bodyMovement = 0;

  ifSamePeriod() {
    // return DateTime.now().isBefore(date.add(const Duration(minutes: 15)));
    return DateTime.now().isBefore(date.add(const Duration(seconds: 20)));
  }

  SleepingRecord();

  SleepingRecord.havingData(
      {required this.snore, required this.cough, required this.bodyMovement});

  factory SleepingRecord.fromJson(Map<String, dynamic> json) {
    return SleepingRecord.havingData(
        snore: json['snore'],
        cough: json['cough'],
        bodyMovement: json['bodyMovement']);
  }

  @override
  toString() {
    return 'date: $date, snore: $snore, cough: $cough, bodymovement: $bodyMovement';
  }

  static void calculate(List<SleepingRecord> sleepRecordList) {}
}
