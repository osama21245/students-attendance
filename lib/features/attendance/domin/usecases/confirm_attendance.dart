import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class ConfirmAttendance implements UseCase<Map, ConfirmAttendanceParams> {
  AttendanceRepository attendanceRepository;
  ConfirmAttendance(this.attendanceRepository);

  @override
  Future<Either<Faliure, Map>> call(
      ConfirmAttendanceParams confirmAttendanceParams) async {
    return await attendanceRepository.confirmAttendance(
        bssid: confirmAttendanceParams.bssid,
        id: confirmAttendanceParams.id,
        stdId: confirmAttendanceParams.stdId);
  }
}

class ConfirmAttendanceParams {
  final String bssid;
  final String id;
  final String stdId;

  ConfirmAttendanceParams(
      {required this.bssid, required this.id, required this.stdId});
}
