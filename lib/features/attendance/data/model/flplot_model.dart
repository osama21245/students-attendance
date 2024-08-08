// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class FlplotModel {
  final List<FlSpot> flSpot;
  final List<DateTime> dateTime;
  FlplotModel({
    required this.flSpot,
    required this.dateTime,
  });

  FlplotModel copyWith({
    List<FlSpot>? flSpot,
    List<DateTime>? dateTime,
  }) {
    return FlplotModel(
      flSpot: flSpot ?? this.flSpot,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  String toString() => 'FlplotModel(flSpot: $flSpot, dateTime: $dateTime)';

  @override
  bool operator ==(covariant FlplotModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.flSpot, flSpot) &&
        listEquals(other.dateTime, dateTime);
  }

  @override
  int get hashCode => flSpot.hashCode ^ dateTime.hashCode;
}
