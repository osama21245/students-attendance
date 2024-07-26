import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class SetLocalAttendance implements UseCase<bool, SetLocalAttendanceParams> {
  AttendanceRepository attendanceRepository;
  SetLocalAttendance(this.attendanceRepository);

  @override
  Future<Either<Faliure, bool>> call(
      SetLocalAttendanceParams setLocalAttendanceParams) async {
    return await attendanceRepository.setLocalAttendance(
      lectureId: '',
      studentId: '',
      time: '',
      date: '',
      status: '',
      bssid: '',
    );
  }
}

class SetLocalAttendanceParams {
  final String bssid;
  final String id;
  final String stdId;
  final String time;
  final String date;
  final String status;

  SetLocalAttendanceParams(
      {required this.bssid,
      required this.id,
      required this.stdId,
      required this.date,
      required this.status,
      required this.time});
}
