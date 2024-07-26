import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:university_attendance/core/common/entities/response.dart';
import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/usecase/usecase.dart';

class SetStudFaceModel
    implements UseCase<HostResponse, SetStudFaceModelParams> {
  AuthRepository authRepository;
  SetStudFaceModel(this.authRepository);

  @override
  Future<Either<Faliure, HostResponse>> call(
      SetStudFaceModelParams setStudFaceModelParams) async {
    return await authRepository.setStudFaceModel(
      imageFile: setStudFaceModelParams.file,
      studId: setStudFaceModelParams.stdId,
    );
  }
}

class SetStudFaceModelParams {
  final List<File> file;
  final String stdId;

  SetStudFaceModelParams({
    required this.file,
    required this.stdId,
  });
}
