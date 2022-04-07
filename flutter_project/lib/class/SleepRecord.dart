// 1 minute per 1 record, 3 * 20, 20 records in 1 record
import 'package:intl/intl.dart';

class SleepingRecord {
  final DateTime initDateTime = DateTime.now();
  int snore = 0;
  int cough = 0;
  int bodyMovement = 0;
  double sleepIndex = 0;

  ifSamePeriod() {
    return DateTime.now()
        .isBefore(initDateTime.add(const Duration(minutes: 1)));
    // return DateTime.now()
    // .isBefore(initDateTime.add(const Duration(seconds: 20)));
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
    return '${DateFormat.Hm().format(initDateTime)} \nsnore: $snore cough: $cough';
  }
}
