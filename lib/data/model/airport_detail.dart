import 'package:flutter/material.dart';

import '../../domain/utility_access_storage.dart';
import '../my_db.dart';

/// Represent the necessary information of airport.
/// Version:1.1.0
@immutable
class AirportDetails {
  ///Identifier airport
  final String iata;

  ///name airport
  final String nameAirport;

  ///name terminal of Airport
  final String terminal;

  ///name gate of Airport
  final String gate;

  ///estimate arrive flight of Airport
  final DateTime estimateArrival;

  ///current delay of flight
  final int delay;

  const AirportDetails(
      {required this.iata,
      required this.nameAirport,
      required this.terminal,
      required this.gate,
      required this.estimateArrival,
      required this.delay});

  /// Generate  AirportDetails form map content data like json
  factory AirportDetails.fromJson(
          {required Map<String, dynamic> json, required TypeAirport type}) =>
      AirportDetails(
          iata: json[UtilityAccessStorage.db!.fieldIdAirport + type.name],
          nameAirport:
              json[UtilityAccessStorage.db!.fieldNameAirport + type.name],
          terminal:
              json[UtilityAccessStorage.db!.fieldTerminalAirport + type.name],
          gate: json[UtilityAccessStorage.db!.fieldGateAirport + type.name],
          estimateArrival: DateTime.fromMillisecondsSinceEpoch(
            json[
                UtilityAccessStorage.db!.fieldTimeEstimatedAirport + type.name],
          ),
          delay: json[UtilityAccessStorage.db!.fieldDelay + type.name]);

  /// Generate map content data like json content information of AirportDetails
  Map<String, dynamic> toJson({required TypeAirport type}) => {
        UtilityAccessStorage.db!.fieldIdAirport + type.name: iata,
        UtilityAccessStorage.db!.fieldNameAirport + type.name: nameAirport,
        UtilityAccessStorage.db!.fieldTerminalAirport + type.name: terminal,
        UtilityAccessStorage.db!.fieldGateAirport + type.name: gate,
        UtilityAccessStorage.db!.fieldTimeEstimatedAirport + type.name:
            estimateArrival.millisecondsSinceEpoch,
        UtilityAccessStorage.db!.fieldDelay + type.name: delay
      };

  ///Generates a new AirportDetails by modifying only the inserted elements other than null
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

  ///Generates a new AirportDetails empty
  factory AirportDetails.empty() => AirportDetails(
      iata: "",
      nameAirport: "",
      terminal: "",
      gate: "",
      estimateArrival: DateTime.now(),
      delay: 0);
}
