import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/const/shared_pref_constans.dart';
import '../../../../core/erorr/exception.dart';
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
      final prefs = await SharedPreferences.getInstance();
      List<String>? attendanceJson =
          prefs.getStringList(SharedPrefrencesConstans.attendance);
      if (attendanceJson != null) {
        List<AttendanceModel> attendanceDecodedList;

        //attendanceJson.map((e) => attendanceDecodedList.add(AttendanceModel.fromJson(jsonDecode(e)))).toList();
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
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch the attendance list, handle type inconsistency
      List<String>? attendanceList;
      try {
        attendanceList =
            prefs.getStringList(SharedPrefrencesConstans.attendance);
        print("2: Attendance list fetched");
      } catch (e) {
        attendanceList = null;
      }

      if (attendanceList == null) {
        attendanceList = [];
      }

      String userJson = jsonEncode(attendanceModel.toJson());

      attendanceList.add(userJson);
      await prefs.setStringList(
          SharedPrefrencesConstans.attendance, attendanceList);

      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<File>> getLocalPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      List<String>? filesPaths =
          prefs.getStringList(SharedPrefrencesConstans.photos);
      if (filesPaths != null) {
        List<File> files = filesPaths.map((e) => File(e)).toList();

        return files;
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> filePaths = files.map((file) => file.path).toList();
      await prefs.setStringList(SharedPrefrencesConstans.photos, filePaths);
      return true;
    } catch (e) {
      throw "erorr";
    }
  }
}
