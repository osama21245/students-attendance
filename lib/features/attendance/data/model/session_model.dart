// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:university_attendance/features/attendance/domin/entities/session.dart';

class SessionModel extends Sessions {
  SessionModel(
      {required super.session_id,
      required super.material_name,
      required super.user_name,
      required super.room,
      required super.room_bssid,
      required super.session_time,
      required super.session_datetime});

  SessionModel copyWith({
    int? session_id,
    String? material_name,
    String? user_name,
    String? room,
    int? session_time,
    String? session_datetime,
    String? room_bssid,
  }) {
    return SessionModel(
      session_id: session_id ?? this.session_id,
      material_name: material_name ?? this.material_name,
      user_name: user_name ?? this.user_name,
      room: room ?? this.room,
      session_time: session_time ?? this.session_time,
      session_datetime: session_datetime ?? this.session_datetime,
      room_bssid: room_bssid ?? this.room_bssid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'session_id': session_id,
      'material_name': material_name,
      'user_name': user_name,
      'room': room,
      'session_time': session_time,
      'session_datetime': session_datetime,
      'room_bssid': room_bssid,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      session_id: map['session_id'] as int,
      material_name: map['material_name'] as String,
      user_name: map['user_name'] as String,
      room: map['room'] as String,
      session_time: map['session_time'] as int,
      session_datetime: map['session_datetime'] as String,
      room_bssid: map['room_bssid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionModel(session_id: $session_id, material_name: $material_name, user_name: $user_name, room: $room, session_time: $session_time, session_datetime: $session_datetime, room_bssid: $room_bssid)';
  }

  @override
  bool operator ==(covariant SessionModel other) {
    if (identical(this, other)) return true;

    return other.session_id == session_id &&
        other.material_name == material_name &&
        other.user_name == user_name &&
        other.room == room &&
        other.session_time == session_time &&
        other.session_datetime == session_datetime &&
        other.room_bssid == room_bssid;
  }

  @override
  int get hashCode {
    return session_id.hashCode ^
        material_name.hashCode ^
        user_name.hashCode ^
        room.hashCode ^
        session_time.hashCode ^
        session_datetime.hashCode ^
        room_bssid.hashCode;
  }
}
