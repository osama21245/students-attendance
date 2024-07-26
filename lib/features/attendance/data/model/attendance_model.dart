// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domin/entities/attendance.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.id,
    required super.lecturerId,
    required super.studentId,
    required super.date,
    required super.time,
    required super.status,
    required super.bssid,
  });

  AttendanceModel copyWith({
    String? id,
    String? lecturerId,
    String? studentId,
    String? date,
    String? time,
    String? status,
    String? bssid,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      lecturerId: lecturerId ?? this.lecturerId,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      bssid: bssid ?? this.bssid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lecturerId': lecturerId,
      'studentId': studentId,
      'date': date,
      'time': time,
      'status': status,
      'bssid': bssid,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] as String,
      lecturerId: map['lecturerId'] as String,
      studentId: map['studentId'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      status: map['status'] as String,
      bssid: map['bssid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceModel(id: $id, lecturerId: $lecturerId, studentId: $studentId, date: $date, time: $time, status: $status, bssid: $bssid)';
  }

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lecturerId == lecturerId &&
        other.studentId == studentId &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.bssid == bssid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lecturerId.hashCode ^
        studentId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        bssid.hashCode;
  }
}
