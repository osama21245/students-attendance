import 'package:university_attendance/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:university_attendance/features/attendance/domin/usecases/check_wifi.dart';
import 'package:university_attendance/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:university_attendance/features/auth/data/repositories/auth_repository_ipl.dart';
import 'package:university_attendance/features/auth/domain/repository/auth_repository.dart';
import 'package:university_attendance/features/auth/domain/usecases/current_user.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_in.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_up.dart';
import 'package:university_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_ipl.dart';
import 'features/attendance/domin/repository/attendance_repository.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initAttendance();

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
      .registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));
  serviceLocator.registerFactory(() => UserSignIn(serviceLocator()));
  serviceLocator.registerFactory(() => GetCurrentUser(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      getCurrentUser: serviceLocator(),
      appUserCubit: serviceLocator()));
}

void _initAttendance() {
  serviceLocator.registerFactory<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl());

  serviceLocator.registerFactory<AttendanceRepository>(
      () => AttendanceRRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => CheckWifiConnection(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AttendanceBloc(
        checkWifiConnection: serviceLocator(),
      ));
}
