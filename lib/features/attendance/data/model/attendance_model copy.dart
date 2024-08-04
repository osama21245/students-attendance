// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domin/entities/attendance.dart';

class TestAttendanceModel {
  final int attendance_id;
  final int attendance_userid;
  final int attendance_roomid;
  final int attendance_materialid;
  final String attendance_date;
  final String material_name;
  final String user_name;
  TestAttendanceModel({
    required this.attendance_id,
    required this.attendance_userid,
    required this.attendance_roomid,
    required this.attendance_materialid,
    required this.attendance_date,
    required this.material_name,
    required this.user_name,
  });

  TestAttendanceModel copyWith({
    int? attendance_id,
    int? attendance_userid,
    int? attendance_roomid,
    int? attendance_materialid,
    String? attendance_date,
    String? material_name,
    String? user_name,
  }) {
    return TestAttendanceModel(
      attendance_id: attendance_id ?? this.attendance_id,
      attendance_userid: attendance_userid ?? this.attendance_userid,
      attendance_roomid: attendance_roomid ?? this.attendance_roomid,
      attendance_materialid:
          attendance_materialid ?? this.attendance_materialid,
      attendance_date: attendance_date ?? this.attendance_date,
      material_name: material_name ?? this.material_name,
      user_name: user_name ?? this.user_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendance_id': attendance_id,
      'attendance_userid': attendance_userid,
      'attendance_roomid': attendance_roomid,
      'attendance_materialid': attendance_materialid,
      'attendance_date': attendance_date,
      'material_name': material_name,
      'user_name': user_name,
    };
  }

  factory TestAttendanceModel.fromMap(Map<String, dynamic> map) {
    return TestAttendanceModel(
      attendance_id: map['attendance_id'] as int,
      attendance_userid: map['attendance_userid'] as int,
      attendance_roomid: map['attendance_roomid'] as int,
      attendance_materialid: map['attendance_materialid'] as int,
      attendance_date: map['attendance_date'] as String,
      material_name: map['material_name'] as String,
      user_name: map['user_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestAttendanceModel.fromJson(String source) =>
      TestAttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestAttendanceModel(attendance_id: $attendance_id, attendance_userid: $attendance_userid, attendance_roomid: $attendance_roomid, attendance_materialid: $attendance_materialid, attendance_date: $attendance_date, material_name: $material_name, user_name: $user_name)';
  }

  @override
  bool operator ==(covariant TestAttendanceModel other) {
    if (identical(this, other)) return true;

    return other.attendance_id == attendance_id &&
        other.attendance_userid == attendance_userid &&
        other.attendance_roomid == attendance_roomid &&
        other.attendance_materialid == attendance_materialid &&
        other.attendance_date == attendance_date &&
        other.material_name == material_name &&
        other.user_name == user_name;
  }

  @override
  int get hashCode {
    return attendance_id.hashCode ^
        attendance_userid.hashCode ^
        attendance_roomid.hashCode ^
        attendance_materialid.hashCode ^
        attendance_date.hashCode ^
        material_name.hashCode ^
        user_name.hashCode;
  }
}
