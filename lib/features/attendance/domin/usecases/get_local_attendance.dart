import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/attendance/domin/entities/attendance.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class GetLocalAttendance implements UseCase<List<Attendance>, NoParams> {
  AttendanceRepository attendanceRepository;
  GetLocalAttendance(this.attendanceRepository);

  @override
  Future<Either<Faliure, List<Attendance>>> call(NoParams params) async {
    return await attendanceRepository.getLocalAttendance();
  }
}
