import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/attendance/domin/entities/similarity.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/attendance_repository.dart';

class CheckStudFace implements UseCase<Similarity, CheckStudFaceModelParams> {
  AttendanceRepository attendanceRepository;
  CheckStudFace(this.attendanceRepository);

  @override
  Future<Either<Faliure, Similarity>> call(
      CheckStudFaceModelParams checkStudFaceModelParams) async {
    return await attendanceRepository.checkStudFace(
      imageFile: checkStudFaceModelParams.file,
      studId: checkStudFaceModelParams.stdId,
    );
  }
}

class CheckStudFaceModelParams {
  final File file;
  final String stdId;

  CheckStudFaceModelParams({
    required this.file,
    required this.stdId,
  });
}
