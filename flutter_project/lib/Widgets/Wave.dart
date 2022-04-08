// ignore_for_file: file_names, must_be_immutable
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../class/SleepRecord.dart';

class Wave extends StatefulWidget {
  // final String startHm = '23:03';
  // final String endHm = '09:48';
  String? startHm;
  String? endHm;
  List<Map<String, SleepingRecord>>? scoreList;
  Duration? lastDuration;
  bool historyMode = false;

  Wave({Key? key}) : super(key: key);
  Wave.withData({
    Key? key,
    required this.startHm,
    required this.endHm,
    required this.scoreList,
    required this.lastDuration,
  }) : super(key: key);

  Wave.historyMode({
    Key? key,
    required this.startHm,
    required this.endHm,
    required this.scoreList,
    required this.lastDuration,
    required this.historyMode,
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
    print(count);
    if (count < 0) {
      return (count + 24);
    }
    return count;
    // return (widget.scoreList!.length / 60).round().toInt(); // !!
  }

  List<FlSpot> _updatingGraph() {
    List<FlSpot> wakeIndexScoreList = [];
    for (var mapElement in widget.scoreList!) {
      double baseIndex = 0;
      var hour = int.parse([...mapElement.keys][0].substring(0, 2));
      var minuteIndex = int.parse([...mapElement.keys][0].substring(3, 5)) / 60;

      baseIndex = baseIndex +
          (hour - int.parse(widget.startHm!.substring(0, 2))) +
          minuteIndex;

      var wakeIndex = [...mapElement.values][0].sleepIndex * 10;
      if (wakeIndex > 10) wakeIndex = 10;
      wakeIndexScoreList.add(FlSpot(baseIndex, wakeIndex));
    }
    print('list: $wakeIndexScoreList');
    return wakeIndexScoreList;
  }

  double _getSleepEfficiency() {
    int sleepCount = 0;
    for (var mapElement in widget.scoreList!) {
      var score = [...mapElement.values][0].sleepIndex;
      if (score < 1) sleepCount++;
    }

    return sleepCount / widget.scoreList!.length * 100;
  }

  @override
  Widget build(BuildContext content) {
    if (widget.scoreList == null || widget.lastDuration == null) {
      if (widget.historyMode) {
        return const Text(
          "You have not selected any record",
          style: TextStyle(color: Color.fromRGBO(36, 159, 191, 1)),
        );
      }
      return const Text(
        "You have not started today's recording yet",
        style: TextStyle(color: Color.fromRGBO(36, 159, 191, 1)),
      );
    }
    if (widget.historyMode) {
      return Column(children: <Widget>[
        SizedBox(
          width: 275,
          height: 70,
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
                        fontSize: 15,
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
          aspectRatio: 0.87,
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
    return Column(children: <Widget>[
      SizedBox(
        width: 275,
        height: 93,
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
        aspectRatio: 0.82,
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
      lineTouchData: LineTouchData(
        // getTouchedSpotIndicator:
        //     (LineChartBarData barData, List<int> spotIndexes) {
        //   return spotIndexes.map((spotIndex) {
        //     if ([...widget.scoreList![spotIndex].values][0].cough == 0 &&
        //         [...widget.scoreList![spotIndex].values][0].snore == 0) {
        //       return TouchedSpotIndicatorData(
        //           FlLine(color: Colors.white, strokeWidth: 4), FlDotData());
        //     }
        //   }).toList();
        // },
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (
            List<LineBarSpot> touchedBarSpots,
          ) {
            return touchedBarSpots.map(
              (barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: [...widget.scoreList![flSpot.spotIndex].values][0]
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ).toList();
          },
        ),
      ),
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
      maxX: _updatingGraph().last.x,
      // maxX: _getCount().toDouble() + 1, // dynamic
      minY: -1,
      maxY: 13,
      lineBarsData: [
        LineChartBarData(
          show: true,
          spots: _updatingGraph(),
          // isCurved: false,
          isCurved: true,
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
