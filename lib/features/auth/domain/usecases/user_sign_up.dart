import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/core/usecase/usecase.dart';
import 'package:university_attendance/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Faliure, User>> call(UserSignUpParams userSignUpParams) async {
    return await authRepository.signInWithEmailAndPassword(
        email: userSignUpParams.email,
        password: userSignUpParams.password,
        name: userSignUpParams.name);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams(this.email, this.password, this.name);
}
