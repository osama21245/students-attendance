part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class AttendanceCheckWifiConnection extends AttendanceEvent {}
