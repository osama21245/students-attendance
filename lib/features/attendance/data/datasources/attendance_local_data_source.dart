import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/const/shared_pref_constans.dart';
import '../../../../core/erorr/exception.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../model/attendance_model.dart';

abstract interface class AttendanceLocalDataSource {
  Future<List<AttendanceModel>> getLocalAttendance();
  Future<bool> setLocalAttendance(AttendanceModel attendanceModel);
  Future<List<File>> getLocalPhotos();
  Future<bool> setLocalPhotos(List<File> file);
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  @override
  Future<List<AttendanceModel>> getLocalAttendance() async {
    try {
      List<String>? attendanceJson =
          await SharedPrefHelper.getSecuredListString(
              SharedPrefrencesConstans.attendance);
      if (attendanceJson != null) {
        List<AttendanceModel> attendanceDecodedList;

        attendanceDecodedList = attendanceJson
            .map((e) => AttendanceModel.fromJson(jsonDecode(e)))
            .toList();
        return attendanceDecodedList;
      }

      throw "Erorr in get your data";
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setLocalAttendance(AttendanceModel attendanceModel) async {
    try {
      // Fetch the attendance list, handle type inconsistency
      List<String>? attendanceList;
      try {
        attendanceList = await SharedPrefHelper.getSecuredListString(
            SharedPrefrencesConstans.attendance);
        print("2: Attendance list fetched");
      } catch (e) {
        attendanceList = null;
      }

      attendanceList ??= [];

      String userJson = jsonEncode(attendanceModel.toJson());

      attendanceList.add(userJson);

      await SharedPrefHelper.setSecuredListString(
          SharedPrefrencesConstans.attendance, attendanceList);

      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<File>> getLocalPhotos() async {
    try {
      List<File>? filesPaths = await SharedPrefHelper.getSecuredPhotos(
          SharedPrefrencesConstans.photos);
      if (filesPaths.isNotEmpty) {
        return filesPaths;
      } else {
        throw "erorr in get photos";
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setLocalPhotos(List<File> files) async {
    try {
      await SharedPrefHelper.setSecuredPhotos(
          SharedPrefrencesConstans.photos, files);
      return true;
    } catch (e) {
      throw "erorr";
    }
  }
}
