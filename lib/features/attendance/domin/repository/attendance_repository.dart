import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AttendanceRepository {
  Future<Either<Faliure, String>> checkWifiConnection();
}
