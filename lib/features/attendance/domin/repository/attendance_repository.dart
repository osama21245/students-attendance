import 'dart:io';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:university_attendance/features/attendance/domin/entities/attendance.dart';
import 'package:university_attendance/features/attendance/domin/entities/session.dart';
import 'package:university_attendance/features/attendance/domin/entities/similarity.dart';

abstract interface class AttendanceRepository {
  Future<Either<Faliure, Map>> confirmAttendance({
    required String session_id,
    required String userId,
  });

  Future<Either<Faliure, bool>> qualificationsOfAttendanceQualifications(
      {required String attendBssid,
      required double attendLat,
      required double attendLong,
      required double attendDistance});

  Future<Either<Faliure, Similarity>> checkStudFace({
    required File imageFile,
    required String studId,
  });

  //sessions

  Future<Either<Faliure, List<Sessions>>> getSessions({
    required int collageId,
  });

  //local dataBase
  Future<Either<Faliure, List<Attendance>>> getLocalAttendance();
  Future<Either<Faliure, bool>> setLocalAttendance({
    required String session_id,
    required String userId,
  });

  Future<Either<Faliure, List<File>>> getLocalPhotos();
  Future<Either<Faliure, bool>> setLocalPhotos({required List<File> file});
}
