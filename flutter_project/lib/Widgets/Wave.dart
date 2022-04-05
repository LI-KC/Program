// ignore_for_file: file_names, must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../class/SleepRecord.dart';

class Wave extends StatefulWidget {
  // final String startHm = '23:03';
  // final String endHm = '09:48';
  String? startHm;
  String? endHm;
  List<Map<String, double>>? scoreList;
  Duration? lastDuration;

  Wave({Key? key}) : super(key: key);
  Wave.withData({
    Key? key,
    required this.startHm,
    required this.endHm,
    required this.scoreList,
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

  int _getCount() {
    var count = int.parse(widget.endHm!.substring(0, 2)) -
        int.parse(widget.startHm!.substring(0, 2));
    if (count < 0) {
      return (count + 24);
    }
    return count;
    // return (widget.scoreList!.length / 60).round().toInt(); // !!
  }

  List<FlSpot> _updatingGraph() {
    List<FlSpot> wakeIndexScoreList = [];
    widget.scoreList!.forEach((mapElement) {
      double baseIndex = 0;
      var hour = int.parse([...mapElement.keys][0].substring(0, 2));
      var minuteIndex = int.parse([...mapElement.keys][0].substring(3, 5)) / 60;

      baseIndex = baseIndex +
          (hour - int.parse(widget.startHm!.substring(0, 2))) +
          minuteIndex;

      var wakeIndex = [...mapElement.values][0] * 10;
      if (wakeIndex > 10) wakeIndex = 10;
      wakeIndexScoreList.add(FlSpot(baseIndex, wakeIndex));
    });
    print('list: $wakeIndexScoreList');
    return wakeIndexScoreList;
  }

  double _getSleepEfficiency() {
    int sleepCount = 0;
    widget.scoreList!.forEach((mapElement) {
      var score = [...mapElement.values][0];
      if (score < 1) sleepCount++;
    });

    return sleepCount / widget.scoreList!.length * 100;
  }

  @override
  Widget build(BuildContext content) {
    if (widget.scoreList == null || widget.lastDuration == null) {
      return const Text(
        "You have not started today's recording yet",
        style: TextStyle(color: Color.fromRGBO(36, 159, 191, 1)),
      );
    }

    return Column(children: <Widget>[
      SizedBox(
        width: 275,
        height: 97,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sleep Efficiency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                  ),
                  Text(
                    '${_getSleepEfficiency().toStringAsFixed(0)}%',
                    style: const TextStyle(
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
        // verticalInterval: 15, // hardcode
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
            if (value == 0) return 'Deep Sleep';
            if (value == 5) return 'Sleep';
            if (value == 10) return 'Awake';
            return '';
          },
          margin: 10,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (context, value) =>
              const TextStyle(color: Color(0xff68737d), fontSize: 14),
          getTitles: (value) {
            var index =
                (value.toInt() + int.parse(widget.startHm!.substring(0, 2)))
                    .toString()
                    .padLeft(2, '0');
            if (int.parse(index) >= 24) {
              return (int.parse(index) - 24).toString().padLeft(2, '0');
            }
            return index;
          },
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
      minX: _updatingGraph()[0].x, // dynamic
      maxX: _getCount().toDouble() + 1, // dynamic
      minY: 0,
      maxY: 13,
      lineBarsData: [
        LineChartBarData(
          spots: _updatingGraph(),
          isCurved: false,
          // isCurved: true,
          colors: gradientColors,
          barWidth: 2.5,
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

// FlSpot(0, 0),
// FlSpot(1, 1),
// FlSpot(1.2, 0.75),
// FlSpot(1.5, 0.5),
// FlSpot(1.75, 0.25),
// FlSpot(2, 0),
// FlSpot(2.25, 0.25),
// FlSpot(2.5, 1),
// FlSpot(2.75, 0.75),
// FlSpot(3, 1),
// FlSpot(5, 0),
// FlSpot(5.05, 0),
// FlSpot(5.1, 0),
// FlSpot(5.2, 0),
// FlSpot(5.5, 0),
// FlSpot(6, 0),
// FlSpot(8, 0),
// FlSpot(9, 0),
