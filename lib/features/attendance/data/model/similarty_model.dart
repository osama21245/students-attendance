import 'dart:convert';
import 'package:university_attendance/features/attendance/domin/entities/similarity.dart';

class SimilartyModel extends Similarity {
  SimilartyModel({required super.state, required super.data});

  SimilartyModel copyWith({
    String? state,
    double? data,
  }) {
    return SimilartyModel(
      state: state ?? this.state,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'state': state,
      'data': data,
    };
  }

  factory SimilartyModel.fromMap(Map<String, dynamic> map) {
    return SimilartyModel(
      state: map['state'] as String,
      data: map['data'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SimilartyModel.fromJson(String source) =>
      SimilartyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Similarity(state: $state, data: $data)';

  @override
  bool operator ==(covariant Similarity other) {
    if (identical(this, other)) return true;

    return other.state == state && other.data == data;
  }

  @override
  int get hashCode => state.hashCode ^ data.hashCode;
}
