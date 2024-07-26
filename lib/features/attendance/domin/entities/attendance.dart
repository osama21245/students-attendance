// ignore_for_file: public_member_api_docs, sort_constructors_first

class Attendance {
  final String id;
  final String lecturerId;
  final String studentId;
  final String date;
  final String time;
  final String status;
  final String bssid;
  Attendance({
    required this.id,
    required this.lecturerId,
    required this.studentId,
    required this.date,
    required this.time,
    required this.status,
    required this.bssid,
  });
}
