import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:university_attendance/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:university_attendance/core/erorr/custom_error_screen.dart';
import 'package:university_attendance/core/utils/crud.dart';
import 'package:university_attendance/features/attendance/domin/usecases/check_stud_face_model.dart';
import 'package:university_attendance/features/attendance/domin/usecases/confirm_attendance.dart';
import 'package:university_attendance/features/attendance/domin/usecases/confirm_qualifications.dart';
import 'package:university_attendance/features/attendance/domin/usecases/get_local_attendance.dart';
import 'package:university_attendance/features/attendance/domin/usecases/get_local_photos.dart';
import 'package:university_attendance/features/attendance/domin/usecases/set_local_attendance.dart';
import 'package:university_attendance/features/attendance/domin/usecases/set_local_photos.dart';
import 'package:university_attendance/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:university_attendance/features/auth/data/repositories/auth_repository_ipl.dart';
import 'package:university_attendance/features/auth/domain/repository/auth_repository.dart';
import 'package:university_attendance/features/auth/domain/usecases/current_user.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_in.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_up.dart';
import 'package:university_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:university_attendance/firebase_options.dart';
import 'features/attendance/data/datasources/attendance_local_data_source.dart';
import 'features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_ipl.dart';
import 'features/attendance/domin/repository/attendance_repository.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/auth/domain/usecases/set_stud_face_model.dart';
import 'dart:async';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initAttendance();
  _checkGeolocatorPermissions();
  customErorrScreen();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  if (kIsWeb) {
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

Future<void> _checkGeolocatorPermissions() async {
  bool serviceEnabled;
  LocationPermission permission; // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, request user to enable it.
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, request permission.
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  // When we reach here, permissions are granted and we can retrieve the current position.
}

void checkBackGroundDependences() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Background Service",
    notificationText: "Background service is running",
    notificationImportance: AndroidNotificationImportance.Default,
  );
  bool hasPermissions = await FlutterBackground.hasPermissions;
  if (!hasPermissions) {
    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      await FlutterBackground.initialize(androidConfig: androidConfig);
    }
  }
}

void _initAuth() {
  serviceLocator.registerFactory(() => Crud());
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));
  serviceLocator.registerFactory(() => UserSignIn(serviceLocator()));
  serviceLocator.registerFactory(() => GetCurrentUser(serviceLocator()));
  serviceLocator.registerFactory(() => SetStudFaceModel(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      getCurrentUser: serviceLocator(),
      setStudFaceModel: serviceLocator(),
      appUserCubit: serviceLocator()));
}

void _initAttendance() {
  serviceLocator.registerFactory<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSoureImpl(serviceLocator()));

  serviceLocator.registerFactory<AttendanceLocalDataSource>(
      () => AttendanceLocalDataSourceImpl());

  serviceLocator.registerFactory<AttendanceRepository>(
      () => AttendanceRRepositoryImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory(() => ConfirmAttendance(serviceLocator()));
  serviceLocator.registerFactory(() => ConfirmQualifications(serviceLocator()));
  serviceLocator.registerFactory(() => CheckStudFace(serviceLocator()));
  serviceLocator.registerFactory(() => GetLocalPhotos(serviceLocator()));
  serviceLocator.registerFactory(() => SetLocalPhotos(serviceLocator()));
  serviceLocator.registerFactory(() => GetLocalAttendance(serviceLocator()));
  serviceLocator.registerFactory(() => SetLocalAttendance(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AttendanceBloc(
      confirmAttendance: serviceLocator(),
      confirmQualifications: serviceLocator(),
      checkStudFace: serviceLocator(),
      getLocalPhotos: serviceLocator(),
      setLocalPhotos: serviceLocator(),
      setLocalAttendance: serviceLocator(),
      getLocalAttendance: serviceLocator()));
}
