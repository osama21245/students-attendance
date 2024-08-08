// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domin/entities/attendance.dart';

class AttendanceModel extends Attendance {
  AttendanceModel(
      {required super.attendance_id,
      required super.attendance_session,
      required super.attendance_userid,
      required super.attendance_date});

  AttendanceModel copyWith({
    String? attendance_id,
    String? attendance_session,
    String? attendance_userid,
    String? attendance_date,
  }) {
    return AttendanceModel(
      attendance_id: attendance_id ?? this.attendance_id,
      attendance_session: attendance_session ?? this.attendance_session,
      attendance_userid: attendance_userid ?? this.attendance_userid,
      attendance_date: attendance_date ?? this.attendance_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendance_id': attendance_id,
      'attendance_session': attendance_session,
      'attendance_userid': attendance_userid,
      'attendance_date': attendance_date,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      attendance_id: map['attendance_id'] as String,
      attendance_session: map['attendance_session'] as String,
      attendance_userid: map['attendance_userid'] as String,
      attendance_date: map['attendance_date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceModel(attendance_id: $attendance_id, attendance_session: $attendance_session, attendance_userid: $attendance_userid, attendance_date: $attendance_date)';
  }

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;

    return other.attendance_id == attendance_id &&
        other.attendance_session == attendance_session &&
        other.attendance_userid == attendance_userid &&
        other.attendance_date == attendance_date;
  }

  @override
  int get hashCode {
    return attendance_id.hashCode ^
        attendance_session.hashCode ^
        attendance_userid.hashCode ^
        attendance_date.hashCode;
  }
}
