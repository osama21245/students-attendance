part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}

final class AttendanceStopLoadingState extends AttendanceState {}

//success
final class AttendanceSuccess extends AttendanceState {
  final Map res;

  AttendanceSuccess(this.res);
}

final class AttendanceConfirmQualificationsSucess extends AttendanceState {
  final bool isQualified;
  AttendanceConfirmQualificationsSucess({required this.isQualified});
}

final class AttendanceCheckFaceSuccess extends AttendanceState {
  final double similarty;

  AttendanceCheckFaceSuccess({required this.similarty});
}

//local database

final class AttendanceGetLocalAttendanceSuccess extends AttendanceState {
  final List<Attendance> attendance;

  AttendanceGetLocalAttendanceSuccess({required this.attendance});
}

final class AttendanceSetLocalAttendanceSuccess extends AttendanceState {
  AttendanceSetLocalAttendanceSuccess();
}

final class AttendanceGetLocalPhotosSuccess extends AttendanceState {
  final List<File> file;

  AttendanceGetLocalPhotosSuccess({required this.file});
}

final class AttendanceSetLocalPhotosSuccess extends AttendanceState {
  AttendanceSetLocalPhotosSuccess();
}

//fail

final class AttendanceRejectQualifications extends AttendanceState {
  final String message;

  AttendanceRejectQualifications(this.message);
}

final class AttendanceFail extends AttendanceState {
  final String message;

  AttendanceFail(this.message);
}
