import 'package:intl/intl.dart';

// 1 minute per 1 record, 3 * 20, 20 records in 1 record
class SleepingRecord {
  final DateTime initDateTime = DateTime.now();
  int snore = 0;
  int cough = 0;
  int bodyMovement = 0; // maximum 20

  ifSamePeriod() {
    // return DateTime.now()
    //     .isBefore(initDateTime.add(const Duration(minutes: 1)));
    return DateTime.now()
        // .isBefore(initDateTime.add(const Duration(seconds: 20)));
        .isBefore(initDateTime.add(const Duration(seconds: 3)));
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
}
