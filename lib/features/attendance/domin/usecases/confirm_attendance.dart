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
      session_id: confirmAttendanceParams.sessionId,
      userId: confirmAttendanceParams.userId,
    );
  }
}

class ConfirmAttendanceParams {
  final String sessionId;
  final String userId;

  ConfirmAttendanceParams({required this.sessionId, required this.userId});
}
