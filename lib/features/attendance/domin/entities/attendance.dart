import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Attendance {
  final String attendance_id;
  final String attendance_session;
  final String attendance_userid;
  final String attendance_date;
  Attendance({
    required this.attendance_id,
    required this.attendance_session,
    required this.attendance_userid,
    required this.attendance_date,
  });
}
