// ignore_for_file: file_names, must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../class/SleepRecord.dart';

class Wave extends StatefulWidget {
  List<SleepingRecord>? lastSleepRecord;
  Duration? lastDuration;

  Wave({Key? key}) : super(key: key);
  Wave.withData({
    Key? key,
    required this.lastSleepRecord,
    required this.lastDuration,
  }) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext content) {
    if (widget.lastSleepRecord == null || widget.lastDuration == null) {
      return const Text(
        "You have not started today's recording yet",
        style: TextStyle(color: Color.fromRGBO(36, 159, 191, 1)),
      );
    }
    return Column(children: <Widget>[
      Container(
        width: 275,
        height: 97,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Final Score',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.lastSleepRecord.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Sleep Time',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 135, 157, 171),
                    ),
                  ),
                  Text(
                    '${widget.lastDuration!.inHours.toString().padLeft(2, '0')}h${widget.lastDuration!.inMinutes.remainder(60).toString().padLeft(2, '0')}m',
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      AspectRatio(
        aspectRatio: 0.8,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            // color: Color(0xff232d37)
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 25, left: 12.0, top: 10, bottom: 0),
            child: LineChart(mainData()),
          ),
        ),
      ),
    ]);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: false,
        drawVerticalLine: true,
        verticalInterval: null, // hardcode
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 2,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          getTextStyles: (context, value) =>
              const TextStyle(color: Color(0xff68737d), fontSize: 13.5),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Deep Sleep';
              case 10:
                return 'Sleep';
              case 19:
                return 'Awake';
            }
            return '';
          },
          margin: 10,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (context, value) =>
              const TextStyle(color: Color(0xff68737d), fontSize: 14),
          getTitles: (value) => value.toInt().toString().padLeft(2, '0'),
          margin: 8,
          interval: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          right: BorderSide(color: Color(0xff37434d), width: 2),
          left: BorderSide(color: Color(0xff37434d), width: 2),
        ),
      ),
      minX: 0, // dynamic
      maxX: 9, // dynamic
      minY: 0,
      maxY: 19,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(3, 2),
            FlSpot(4.9, 0),
            FlSpot(6.8, 1),
            FlSpot(8, 0),
            FlSpot(9, 0),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
