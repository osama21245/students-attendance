part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}

final class AttendanceSuccess extends AttendanceState {
  final String bssid;

  AttendanceSuccess(this.bssid);
}

final class AttendanceFail extends AttendanceState {
  final String message;

  AttendanceFail(this.message);
}
