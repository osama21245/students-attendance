import 'dart:io';

import 'package:university_attendance/core/const/linksApi.dart';
import 'package:university_attendance/features/attendance/data/model/attendance_model.dart';
import "package:http/http.dart" as http;

import '../../../../core/erorr/exception.dart';
import '../../../../core/utils/crud.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<Map> confirmAttendance({required AttendanceModel attendanceModel});
  Future<Map> checkStudFace({
    required File imageFile,
    required String studId,
  });

  Future<Map> getSessions({required int collageId, required String date});
}

class AttendanceRemoteDataSoureImpl implements AttendanceRemoteDataSource {
  Crud crud;
  AttendanceRemoteDataSoureImpl(this.crud);
  @override
  Future<Map> confirmAttendance(
      {required AttendanceModel attendanceModel}) async {
    //change Api links
    try {
      final response = await crud.postData(Apilinks.linkInsertUserAttendance, {
        "attendance_session": attendanceModel.attendance_session,
        "attendance_userid": attendanceModel.attendance_userid,
        "attendance_date": attendanceModel.attendance_date
      });
      return response;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map> checkStudFace({
    required File imageFile,
    required String studId,
  }) async {
    final response =
        await crud.multiPostData(imageFile, Apilinks.linkSetFaceIdModel, {
      "name": studId,
    });
    return response;
  }

  @override
  Future<Map> getSessions(
      {required int collageId, required String date}) async {
    try {
      final response = await crud.postData(Apilinks.linkGetUserSessions,
          {"date": date, "user_collage_id": collageId.toString()});
      return response;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
