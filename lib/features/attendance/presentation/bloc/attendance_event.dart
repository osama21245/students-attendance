part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class AttendanceConfirmAttendance extends AttendanceEvent {
  final String sessionId;
  final String userId;

  AttendanceConfirmAttendance({required this.sessionId, required this.userId});
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

//sessions

class AttendanceGetSessions extends AttendanceEvent {
  final int collageId;

  AttendanceGetSessions({required this.collageId});
}

//local database

class AttendanceGetLocalAttendance extends AttendanceEvent {}

class AttendanceSetLocalAttendance extends AttendanceEvent {
  final String sessionId;
  final String userId;

  AttendanceSetLocalAttendance({required this.sessionId, required this.userId});
}

class AttendanceGetLocalPhotos extends AttendanceEvent {}

class AttendanceSetLocalPhotos extends AttendanceEvent {
  final List<File> file;
  AttendanceSetLocalPhotos({required this.file});
}
//

class AttendanceStartLoading extends AttendanceEvent {}

class AttendanceStopLoading extends AttendanceEvent {}
