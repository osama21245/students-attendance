import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:fpdart/src/either.dart';
import 'package:university_attendance/features/attendance/data/model/attendance_model.dart';
import 'package:university_attendance/features/attendance/data/model/similarty_model.dart';
import 'package:university_attendance/features/attendance/domin/entities/session.dart';
import '../datasources/attendance_local_data_source.dart';
import '../function/arabic_to_english_num.dart';
import '../../domin/repository/attendance_repository.dart';

class AttendanceRRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource attendanceRemoteDataSource;
  final AttendanceLocalDataSource attendacneLocalDataSource;

  AttendanceRRepositoryImpl(
      this.attendanceRemoteDataSource, this.attendacneLocalDataSource);
  @override
  Future<Either<Faliure, Map>> confirmAttendance({
    required String session_id,
    required String userId,
  }) async {
    try {
      AttendanceModel attendanceModel = AttendanceModel(
          attendance_id: "will_be_generated_in_DB",
          attendance_session: session_id,
          attendance_userid: userId,
          attendance_date: DateTime.now().toString());
      final res = await attendanceRemoteDataSource.confirmAttendance(
          attendanceModel: attendanceModel);
      return right(res);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

  //check functions
  @override
  Future<Either<Faliure, bool>> qualificationsOfAttendanceQualifications(
      {required String attendBssid,
      required double attendLat,
      required double attendLong,
      required double attendDistance}) async {
    final info = NetworkInfo();
    String? bssid;
    try {
      //check location
      List<Position> positions = [];

      for (int i = 0; i < 4; i++) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        positions.add(position);
        await Future.delayed(const Duration(milliseconds: 200));
      }
      double totalLatitude = 0;
      double totalLongitude = 0;

      for (Position position in positions) {
        totalLatitude += position.latitude;
        totalLongitude += position.longitude;
      }
      // print(position.latitude);
      double distanceInMeters = await Geolocator.distanceBetween(
          totalLatitude / 4.0, totalLongitude / 4.0, attendLat, attendLong);
//check wiFi
      bssid = await info.getWifiGatewayIP(); // الحصول على BSSID
      // print(bssid);
      bssid = arabicToEnglish(bssid ?? "");
      // print(bssid);
      if (bssid == null) {
        throw "erorr in connection";
      } else if (bssid == attendBssid && distanceInMeters < attendDistance) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

  @override
  Future<Either<Faliure, SimilartyModel>> checkStudFace({
    required File imageFile,
    required String studId,
  }) async {
    try {
      SimilartyModel similartyModel;
      final res = await attendanceRemoteDataSource.checkStudFace(
          imageFile: imageFile, studId: studId);
      print(res);
      if (res["response"] is String) {
        print("string");
        similartyModel = SimilartyModel(state: res["response"], data: 0);
      } else {
        print("list");
        print(res["response"]);
        // List<double> data = res["response"];
        final similarty = res["response"];

        print(similarty[0]);
        similartyModel = SimilartyModel(state: "success", data: similarty[0]);
      }

      return right(similartyModel);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

//sessions

  @override
  Future<Either<Faliure, List<Sessions>>> getSessions(
      {required int collageId}) async {
    try {
      List<Sessions> sessions = [];
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(date);

      final res = await attendanceRemoteDataSource.getSessions(
          date: date, collageId: collageId);
      if (res["status"] == "success") {
        print(res);
        List sessionsData = res["data"];
        sessions.addAll(sessionsData.map((e) => Sessions.fromMap(e)));
        print(sessions);

        return right(sessions);
      } else {
        return left(Faliure("there is no sessions"));
      }
    } catch (e) {
      print(e);
      return left(Faliure(e.toString()));
    }
  }

//local database

  @override
  Future<Either<Faliure, List<AttendanceModel>>> getLocalAttendance() async {
    try {
      final res = await attendacneLocalDataSource.getLocalAttendance();

      return right(res);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

  @override
  Future<Either<Faliure, bool>> setLocalAttendance({
    required String session_id,
    required String userId,
  }) async {
    try {
      AttendanceModel attendanceModel = AttendanceModel(
          attendance_id: "will_be_generated_in_DB",
          attendance_session: session_id,
          attendance_userid: userId,
          attendance_date: DateTime.now().toString());
      final res =
          await attendacneLocalDataSource.setLocalAttendance(attendanceModel);

      return right(res);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<File>>> getLocalPhotos() async {
    try {
      final res = await attendacneLocalDataSource.getLocalPhotos();

      return right(res);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }

  @override
  Future<Either<Faliure, bool>> setLocalPhotos(
      {required List<File> file}) async {
    try {
      final res = await attendacneLocalDataSource.setLocalPhotos(file);
      return right(res);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }
}
