import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/attendance/domin/entities/session.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../repository/attendance_repository.dart';

class GetSessions implements UseCase<List<Sessions>, GetSessionsParams> {
  AttendanceRepository attendanceRepository;
  GetSessions(this.attendanceRepository);

  @override
  Future<Either<Faliure, List<Sessions>>> call(
      GetSessionsParams confirmQualificationsParams) async {
    return await attendanceRepository.getSessions(
        collageId: confirmQualificationsParams.collageId);
  }
}

class GetSessionsParams {
  final int collageId;
  GetSessionsParams({
    required this.collageId,
  });
}
