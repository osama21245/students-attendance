import 'package:university_attendance/core/erorr/faliure.dart';
import 'package:university_attendance/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Faliure, User>> signInWithEmailAndPassword(
      {required String email, required String password, required String name});

  Future<Either<Faliure, User>> loginInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Faliure, User?>> getCurrentUserData();
}
