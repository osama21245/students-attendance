part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class AttendanceConfirmAttendance extends AttendanceEvent {
  final String bssid;
  final String id;
  final String stdid;

  AttendanceConfirmAttendance(
      {required this.bssid, required this.id, required this.stdid});
}

class AttendanceConfirmQualifications extends AttendanceEvent {
  final String attendbssid;
  final double attendLat;
  final double attendLong;
  final double attendDistance;

  AttendanceConfirmQualifications(
      {required this.attendbssid,
      required this.attendLat,
      required this.attendLong,
      required this.attendDistance});
}

class AttendanceCheckStudFace extends AttendanceEvent {
  final File image;
  final String studId;

  AttendanceCheckStudFace({required this.image, required this.studId});
}

//local database

class AttendanceGetLocalAttendance extends AttendanceEvent {}

class AttendanceSetLocalAttendance extends AttendanceEvent {
  final String bssid;
  final String id;
  final String stdId;
  final String time;
  final String date;
  final String status;

  AttendanceSetLocalAttendance(
      {required this.bssid,
      required this.id,
      required this.stdId,
      required this.time,
      required this.date,
      required this.status});
}

class AttendanceGetLocalPhotos extends AttendanceEvent {}

class AttendanceSetLocalPhotos extends AttendanceEvent {
  final List<File> file;
  AttendanceSetLocalPhotos({required this.file});
}
//

class AttendanceStartLoading extends AttendanceEvent {}

class AttendanceStopLoading extends AttendanceEvent {}
