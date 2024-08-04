import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:university_attendance/core/const/linksApi.dart';
import 'package:university_attendance/core/erorr/exception.dart';
import 'package:university_attendance/features/attendance/data/model/attendance_model.dart';
import 'package:university_attendance/features/attendance/data/model/flplot_model.dart';
import 'package:university_attendance/features/attendance/domin/entities/attendance.dart';
import 'app_test_colors.dart';
import 'features/attendance/data/model/attendance_model copy.dart';
import 'features/attendance/presentation/pages/user_data/widgets/custom_dropdown_menu.dart';

class _LineChart extends StatefulWidget {
  const _LineChart({
    required this.isShowingMainData,
  });

  final bool isShowingMainData;
  // final List<FlSpot> spots;
  // final List<FlSpot> spots2;

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  List<LineChartBarData> chartsData = [];
  List<TestAttendanceModel> attendanceModel = [];
  List<Widget> indecator = [];

  static _indecator(
          [Color color = AppColors.contentColorGreen, String text = ""]) =>
      Row(
        children: [
          Container(width: 10, height: 10, color: color),
          SizedBox(
            width: 7,
          ),
          Text(text)
        ],
      );

  @override
  void initState() {
    getStudentData(4);
    super.initState();
  }

  void generateLineChartBarData() {
    int counter = 2;

    Map<String, List<TestAttendanceModel>> groupedData = {};
    for (var attendance in attendanceModel) {
      if (!groupedData.containsKey(attendance.material_name)) {
        groupedData[attendance.material_name] = [];
      }
      groupedData[attendance.material_name]!.add(attendance);
    }

    for (var entry in groupedData.entries) {
      List<TestAttendanceModel> data = entry.value;
      List<FlSpot> spots = [];

      for (int i = 0; i < data.length; i++) {
        DateTime currentDate = DateTime.parse(data[i].attendance_date);
        DateTime nextDate;

        if (i == data.length - 1) {
          nextDate = currentDate;
        } else {
          nextDate = DateTime.parse(data[i + 1].attendance_date);
        }
        if (spots.contains(FlSpot(currentDate.day.toDouble(), 1))) {
          spots.remove(FlSpot(currentDate.day.toDouble(), 1));
          spots.add(FlSpot(currentDate.day.toDouble(), 2));
        } else {
          spots.add(FlSpot(currentDate.day.toDouble(), 1));
        }

        print(currentDate.day.toDouble());

        Duration duration = nextDate.difference(currentDate);

        if (duration.inDays > 0) {
          for (int j = 1; j < duration.inDays; j++) {
            DateTime intermediateDate = currentDate.add(Duration(days: j));
            spots.add(FlSpot(intermediateDate.day.toDouble(), 0));
          }
        }
      }

      indecator.add(_indecator(
          counter % 2 == 0
              ? AppColors.contentColorPink
              : AppColors.contentColorGreen,
          entry.key));

      chartsData.add(LineChartBarData(
        isCurved: true,
        color: counter % 2 == 0
            ? AppColors.contentColorPink
            : AppColors.contentColorGreen,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        preventCurveOverShooting: true,
        spots: spots,
      ));
      counter = counter + 1;
      print("counter${counter % 1}");
    }
  }

  void getStudentData(int studentId) async {
    try {
      var response = await http.post(Uri.parse(Apilinks.linkGetUserAttendance),
          body: {"user_id": studentId.toString()},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map res = jsonDecode(response.body);
        if (res["status"] == "success") {
          List attendanceData = res["data"];
          try {
            attendanceModel.addAll(
                attendanceData.map((e) => TestAttendanceModel.fromMap(e)));

            if (attendanceModel.isNotEmpty) {
              generateLineChartBarData();
            }
          } catch (e) {
            print(e);
          }
          print("correct $attendanceModel");
        }
      } else {
        throw ServerException("Server Error");
      }
      setState(() {});
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 150,
              child: ListView.builder(
                  itemCount: indecator.length,
                  itemBuilder: (context, index) => indecator[index]),
            ),
          ],
        ),
        LineChart(
          widget.isShowingMainData ? sampleData1 : sampleData2,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: chartsData,
        minX: 0,
        maxX: 25,
        maxY: 2,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        //  lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    text = '${value.toInt()} Times';

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    String formattedDate = value.toString();
    text = Text(formattedDate, style: style, textAlign: TextAlign.center);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //     isCurved: true,
  //     color: AppColors.contentColorGreen,
  //     barWidth: 8,
  //     isStrokeCapRound: true,
  //     dotData: const FlDotData(show: false),
  //     belowBarData: BarAreaData(show: false),
  //     spots: );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorPink,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: AppColors.contentColorPink.withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.contentColorGreen.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorPink.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.contentColorPink.withOpacity(0.2),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.contentColorCyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData = true;
  List<TestAttendanceModel> attendanceModel = [];
  FlplotModel spotsModel = FlplotModel(flSpot: [], dateTime: []);

  List<String> duration = ["Last 7 days", "Last 30 days", "All"];
  String selectedDuration = "All";
  DateTime selecteddate = DateTime.now();

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    getStudentData(4);
  }

  void getStudentData(int studentId) async {
    try {
      var response = await http.post(Uri.parse(Apilinks.linkGetUserAttendance),
          body: {"user_id": studentId.toString()},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map res = jsonDecode(response.body);
        if (res["status"] == "success") {
          List attendanceData = res["data"];
          try {
            attendanceModel.addAll(
                attendanceData.map((e) => TestAttendanceModel.fromMap(e)));

            for (int i = 0; i <= attendanceModel.length; i++) {
              DateTime currentDate =
                  DateTime.parse(attendanceModel[i].attendance_date);
              DateTime nextDate =
                  DateTime.parse(attendanceModel[i].attendance_date);
              if (i == attendanceModel.length - 1) {
                nextDate = DateTime.parse(attendanceModel[i].attendance_date);
              } else {
                nextDate =
                    DateTime.parse(attendanceModel[i + 1].attendance_date);
              }

              spotsModel.flSpot.add(FlSpot(currentDate.day.toDouble(), 1));
              print(currentDate.day.toDouble());

              Duration duration = nextDate.difference(currentDate);
              // print(duration.inDays);

              if (duration.inDays > 0) {
                for (int j = 1; j < duration.inDays; j++) {
                  DateTime intermediateDate =
                      currentDate.add(Duration(days: j));
                  spotsModel.flSpot.add(
                      FlSpot(currentDate.day.toDouble() + j.toDouble(), 0));
                  spotsModel.dateTime.add(intermediateDate);
                }
              }
            }
          } catch (e) {
            print(e);
          }
          print("correct $attendanceModel");
        }
      } else {
        throw ServerException("Server Error");
      }
      setState(() {});
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  changeDate(String selectedDuration) {
    var smallestSpot = spotsModel.dateTime.first;

    for (var spot in spotsModel.dateTime) {
      if (smallestSpot.isAfter(spot)) {
        smallestSpot = spot;
      }
    }
    if (selectedDuration == "Last 7 days") {
      selecteddate = smallestSpot.add(const Duration(days: 6));
    } else if (selectedDuration == "Last 30 days") {
      selecteddate = smallestSpot.add(const Duration(days: 29));
    } else {
      selecteddate = DateTime.now();
    }
    spotsModel = spotsModel.copyWith(
        dateTime: spotsModel.dateTime
            .where((element) => element.isBefore(selecteddate))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Monthly Sales',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                    isShowingMainData: isShowingMainData,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              attendanceModel.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: attendanceModel.length,
                          itemBuilder: (context, index) {
                            final attendance = attendanceModel[index];
                            return ListTile(
                              title: Text(attendance.material_name),
                              subtitle: Text(attendance.user_name),
                              trailing: Text(attendance.attendance_date),
                            );
                          }),
                    )
                  : SizedBox(),
              CustomDropDown(
                items: duration,
                onChanged: (val) {
                  selectedDuration = val;
                  changeDate(selectedDuration);
                  setState(() {});
                },
              )
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
