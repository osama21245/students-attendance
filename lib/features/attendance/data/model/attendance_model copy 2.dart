// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domin/entities/attendance.dart';

class TestAttendanceModel2 {
  final int attend;
  final String session_datetime;
  final String material_name;
  final String user_name;
  TestAttendanceModel2({
    required this.attend,
    required this.session_datetime,
    required this.material_name,
    required this.user_name,
  });

  TestAttendanceModel2 copyWith({
    int? attend,
    String? session_datetime,
    String? material_name,
    String? user_name,
  }) {
    return TestAttendanceModel2(
      attend: attend ?? this.attend,
      session_datetime: session_datetime ?? this.session_datetime,
      material_name: material_name ?? this.material_name,
      user_name: user_name ?? this.user_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attend': attend,
      'session_datetime': session_datetime,
      'material_name': material_name,
      'user_name': user_name,
    };
  }

  factory TestAttendanceModel2.fromMap(Map<String, dynamic> map) {
    return TestAttendanceModel2(
      attend: map['attend'] as int,
      session_datetime: map['session_datetime'] as String,
      material_name: map['material_name'] as String,
      user_name: map['user_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestAttendanceModel2.fromJson(String source) =>
      TestAttendanceModel2.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestAttendanceModel2(attend: $attend, session_datetime: $session_datetime, material_name: $material_name, user_name: $user_name)';
  }

  @override
  bool operator ==(covariant TestAttendanceModel2 other) {
    if (identical(this, other)) return true;

    return other.attend == attend &&
        other.session_datetime == session_datetime &&
        other.material_name == material_name &&
        other.user_name == user_name;
  }

  @override
  int get hashCode {
    return attend.hashCode ^
        session_datetime.hashCode ^
        material_name.hashCode ^
        user_name.hashCode;
  }
}
