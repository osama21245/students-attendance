import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class SetLocalPhotos implements UseCase<bool, SetLocalPhotosParams> {
  AttendanceRepository attendanceRepository;
  SetLocalPhotos(this.attendanceRepository);

  @override
  Future<Either<Faliure, bool>> call(
      SetLocalPhotosParams setLocalPhotosParams) async {
    return await attendanceRepository.setLocalPhotos(
        file: setLocalPhotosParams.file);
  }
}

class SetLocalPhotosParams {
  List<File> file;

  SetLocalPhotosParams({required this.file});
}
