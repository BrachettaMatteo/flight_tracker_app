import 'package:flutter/material.dart';

import '../../core/utility.dart';
import '../my_db.dart';

/// Represent the necessary information of airport.
@immutable
class AirportDetails {
  final String iata;
  final String nameAirport;
  final String terminal;
  final String gate;
  final DateTime estimateArrival;
  final int delay;

  const AirportDetails(
      {required this.iata,
      required this.nameAirport,
      required this.terminal,
      required this.gate,
      required this.estimateArrival,
      required this.delay});

  factory AirportDetails.fromJson(
          {required Map<String, dynamic> json, required TypeAirport type}) =>
      AirportDetails(
          iata: json[Utility.db!.fieldIdAirport + type.name],
          nameAirport: json[Utility.db!.fieldNameAirport + type.name],
          terminal: json[Utility.db!.fieldTerminalAirport + type.name],
          gate: json[Utility.db!.fieldGateAirport + type.name],
          estimateArrival: DateTime.fromMillisecondsSinceEpoch(
            json[Utility.db!.fieldTimeEstimatedAirport + type.name],
          ),
          delay: json[Utility.db!.fieldDelay + type.name]);

  Map<String, dynamic> toJson({required TypeAirport type}) => {
        Utility.db!.fieldIdAirport + type.name: iata,
        Utility.db!.fieldNameAirport + type.name: nameAirport,
        Utility.db!.fieldTerminalAirport + type.name: terminal,
        Utility.db!.fieldGateAirport + type.name: gate,
        Utility.db!.fieldTimeEstimatedAirport + type.name:
            estimateArrival.millisecondsSinceEpoch,
        Utility.db!.fieldDelay + type.name: delay
      };

  AirportDetails copyWith(String? iata, String? nameAirport, String? terminal,
          String? gate, DateTime? estimateArrival, int? delay) =>
      AirportDetails(
          iata: iata ?? this.iata,
          nameAirport: nameAirport ?? this.nameAirport,
          terminal: terminal ?? this.terminal,
          gate: gate ?? this.gate,
          estimateArrival: estimateArrival ?? this.estimateArrival,
          delay: delay ?? this.delay);
  @override
  String toString() => (StringBuffer()
        ..writeln("iata: $iata")
        ..writeln("name: $nameAirport")
        ..writeln("terminal: $terminal")
        ..writeln("gate: $gate")
        ..writeln("estimateArrival: ${estimateArrival.toString()}")
        ..writeln("delay: $delay"))
      .toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirportDetails &&
          iata == other.iata &&
          nameAirport == other.nameAirport &&
          terminal == other.terminal &&
          gate == other.gate &&
          estimateArrival == other.estimateArrival &&
          delay == other.delay;

  @override
  int get hashCode => iata.hashCode;
}
