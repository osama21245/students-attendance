import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class GetLocalPhotos implements UseCase<List<File>, NoParams> {
  AttendanceRepository attendanceRepository;
  GetLocalPhotos(this.attendanceRepository);

  @override
  Future<Either<Faliure, List<File>>> call(NoParams params) async {
    return await attendanceRepository.getLocalPhotos();
  }
}
