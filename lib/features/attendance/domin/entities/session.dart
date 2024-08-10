// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sessions {
  final int session_id;
  final String material_name;
  final String user_name;
  final String room;
  final int session_time;
  final String session_datetime;
  final String room_bssid;
  Sessions({
    required this.session_id,
    required this.material_name,
    required this.user_name,
    required this.room,
    required this.session_time,
    required this.session_datetime,
    required this.room_bssid,
  });

  Sessions copyWith({
    int? session_id,
    String? material_name,
    String? user_name,
    String? room,
    int? session_time,
    String? session_datetime,
    String? room_bssid,
  }) {
    return Sessions(
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

  factory Sessions.fromMap(Map<String, dynamic> map) {
    return Sessions(
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

  factory Sessions.fromJson(String source) =>
      Sessions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sessions(session_id: $session_id, material_name: $material_name, user_name: $user_name, room: $room, session_time: $session_time, session_datetime: $session_datetime, room_bssid: $room_bssid)';
  }

  @override
  bool operator ==(covariant Sessions other) {
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
