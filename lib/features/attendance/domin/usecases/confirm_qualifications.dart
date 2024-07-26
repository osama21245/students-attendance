import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class ConfirmQualifications
    implements UseCase<bool, ConfirmQualificationsParams> {
  AttendanceRepository attendanceRepository;
  ConfirmQualifications(this.attendanceRepository);

  @override
  Future<Either<Faliure, bool>> call(
      ConfirmQualificationsParams confirmQualificationsParams) async {
    return await attendanceRepository.qualificationsOfAttendanceQualifications(
        attendBssid: confirmQualificationsParams.attendBssid,
        attendLat: confirmQualificationsParams.attendLat,
        attendLong: confirmQualificationsParams.attendLong,
        attendDistance: confirmQualificationsParams.attendDistance);
  }
}

class ConfirmQualificationsParams {
  final String attendBssid;
  final double attendLat;
  final double attendLong;
  final double attendDistance;
  ConfirmQualificationsParams(
      {required this.attendBssid,
      required this.attendLat,
      required this.attendLong,
      required this.attendDistance});
}
