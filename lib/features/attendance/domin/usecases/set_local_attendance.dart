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
        session_id: setLocalAttendanceParams.sessionId,
        userId: setLocalAttendanceParams.userId);
  }
}

class SetLocalAttendanceParams {
  final String sessionId;
  final String userId;

  SetLocalAttendanceParams({required this.sessionId, required this.userId});
}
