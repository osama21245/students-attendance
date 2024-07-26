// import 'package:network_info_plus/network_info_plus.dart';
// import '../../../../core/erorr/exception.dart';

// abstract interface class AttendanceRemoteDataSource {
//   Future<String> checkWifiConnection();
// }

// class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
//   AttendanceRemoteDataSourceImpl();

//   @override
//   Future<String> checkWifiConnection() async {
// final info = NetworkInfo();
// String? bssid;
// try {
//   bssid = await info.getWifiGatewayIP(); // الحصول على BSSID
//   print(bssid);

//   if (bssid == null) {
//     throw "erorr in connection";
//   } else {
//     return bssid;
//   }
// } catch (e) {
//   throw ServerException(e.toString());
// }
//   }

//   // Future<UserModel> logInWithEmailAndPassword(
//   //     {required String email, required String password}) async {
//   // try {
//   //   final response = await supabaseClient.auth
//   //       .signInWithPassword(email: email, password: password);
//   //   if (response.user == null) {
//   //     throw ServerException("Email or Passowrd is wrong");
//   //   } else {
//   //     return UserModel.fromJson(response.user!.toJson())
//   //         .copyWith(email: currentUserSession!.user.email);
//   //   }
//   // } catch (e) {
//   //   throw ServerException(e.toString());
//   // }
//   // }
// }

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
}

class AttendanceRemoteDataSoureImpl implements AttendanceRemoteDataSource {
  Crud crud;
  AttendanceRemoteDataSoureImpl(this.crud);
  @override
  Future<Map> confirmAttendance(
      {required AttendanceModel attendanceModel}) async {
    //change Api links
    try {
      final response = await crud.postData(Apilinks.baseUrl,
          {"id": attendanceModel.id, "stdid": attendanceModel.studentId});
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
}
