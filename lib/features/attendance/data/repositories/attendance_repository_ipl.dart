import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:fpdart/src/either.dart';

import '../../domin/repository/attendance_repository.dart';

class AttendanceRRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource attendanceRemoteDataSource;

  AttendanceRRepositoryImpl(this.attendanceRemoteDataSource);
  @override
  @override
  Future<Either<Faliure, String>> checkWifiConnection() async {
    try {
      final bssid = await attendanceRemoteDataSource.checkWifiConnection();
      return right(bssid);
    } catch (e) {
      return left(Faliure(e.toString()));
    }
  }
}
