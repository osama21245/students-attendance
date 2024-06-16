import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';
import '../repository/attendance_repository.dart';

class CheckWifiConnection implements UseCase<String, NoParams> {
  final AttendanceRepository attendanceRepository;

  CheckWifiConnection(this.attendanceRepository);
  @override
  Future<Either<Faliure, String>> call(NoParams params) async {
    return await attendanceRepository.checkWifiConnection();
  }
}
