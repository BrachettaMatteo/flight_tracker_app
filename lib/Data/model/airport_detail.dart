import 'package:flutter/material.dart';

import '../../core/utility.dart';
import '../my_db.dart';

/// Rappresent the necessary information of airport.
@immutable
class AirportDetails {
  final String iata;
  final String nameAriport;
  final String terminal;
  final String gate;
  final DateTime estimateArrival;
  final int delay;

  const AirportDetails(
      {required this.iata,
      required this.nameAriport,
      required this.terminal,
      required this.gate,
      required this.estimateArrival,
      required this.delay});

  factory AirportDetails.fromJson(
          {required Map<String, dynamic> json, required TypeAirpot type}) =>
      AirportDetails(
          iata: json[Utility.db!.fieldidAirport + type.name],
          nameAriport: json[Utility.db!.fieldNameAirport + type.name],
          terminal: json[Utility.db!.fieldTerminalAirport + type.name],
          gate: json[Utility.db!.fieldGateAirport + type.name],
          estimateArrival: DateTime.fromMillisecondsSinceEpoch(
            json[Utility.db!.fieldTimeEstimatedAirport + type.name],
          ),
          delay: json[Utility.db!.fieldDelay + type.name]);

  Map<String, dynamic> toJson({required TypeAirpot type}) => {
        Utility.db!.fieldidAirport + type.name: iata,
        Utility.db!.fieldNameAirport + type.name: nameAriport,
        Utility.db!.fieldTerminalAirport + type.name: terminal,
        Utility.db!.fieldGateAirport + type.name: gate,
        Utility.db!.fieldTimeEstimatedAirport + type.name:
            estimateArrival.millisecondsSinceEpoch,
        Utility.db!.fieldDelay + type.name: delay
      };

  AirportDetails copyWith(String? iata, String? nameAriport, String? terminal,
          String? gate, DateTime? estimateArrival, int? delay) =>
      AirportDetails(
          iata: iata ?? this.iata,
          nameAriport: nameAriport ?? this.nameAriport,
          terminal: terminal ?? this.terminal,
          gate: gate ?? this.gate,
          estimateArrival: estimateArrival ?? this.estimateArrival,
          delay: delay ?? this.delay);
  @override
  String toString() => (StringBuffer()
        ..writeln("iata: $iata")
        ..writeln("name: $nameAriport")
        ..writeln("termianl: $terminal")
        ..writeln("gate: $gate")
        ..writeln("estimateArrival: ${estimateArrival.toString()}")
        ..writeln("delay: $delay"))
      .toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirportDetails &&
          iata == other.iata &&
          nameAriport == other.nameAriport &&
          terminal == other.terminal &&
          gate == other.gate &&
          estimateArrival == other.estimateArrival &&
          delay == other.delay;

  @override
  int get hashCode => iata.hashCode;
}
