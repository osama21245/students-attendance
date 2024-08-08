import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:university_attendance/app_test_colors.dart';
import 'package:university_attendance/core/const/linksApi.dart';
import 'package:university_attendance/core/erorr/exception.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';

import 'features/attendance/data/model/attendance_model copy 2.dart';

class UserTimeLine extends StatefulWidget {
  const UserTimeLine({super.key});

  @override
  State<UserTimeLine> createState() => _UserTimeLineState();
}

class _UserTimeLineState extends State<UserTimeLine> {
  late bool isShowingMainData = true;
  List<TestAttendanceModel2> attendanceModel = [];

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

          attendanceModel.addAll(
              attendanceData.map((e) => TestAttendanceModel2.fromMap(e)));
        }
      }
      setState(() {});
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
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
                'Time Line',
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
              attendanceModel.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: attendanceModel.length,
                          itemBuilder: (context, index) {
                            final attendance = attendanceModel[index];
                            return TimelineTile(
                              indicatorStyle: IndicatorStyle(
                                padding: EdgeInsets.all(10),
                                width: 20,
                                color: attendance.attend == 1
                                    ? AppPallete.primaryColor
                                    : Colors.red,
                              ),
                              alignment: TimelineAlign.manual,
                              lineXY: 0.3,
                              endChild: ListTile(
                                title: Text(attendance.material_name),
                                subtitle: Text(attendance.user_name),
                                trailing: Text(attendance.session_datetime),
                              ),
                              startChild: Container(
                                color: attendance.attend == 1
                                    ? const Color.fromARGB(140, 63, 221, 97)
                                    : const Color.fromARGB(111, 244, 67, 54),
                              ),
                            );
                          }),
                    )
                  : SizedBox(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
