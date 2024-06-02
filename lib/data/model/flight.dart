import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/utility_access_storage.dart';
import '../my_db.dart';
import 'airport_detail.dart';

/// Represent the flight.
/// Version:1.1.0
@immutable
class Flight extends Equatable {
  ///information of airport departure;
  final AirportDetails airportDeparture;

  ///information of airport arrival;
  final AirportDetails airportArrival;

  /// identify flight
  final String id;
  final String note;

  const Flight(
      {required this.id,
      required this.airportDeparture,
      required this.airportArrival,
      required this.note});

  ///Generates a new Flight by modifying only the inserted elements other than null
  Flight copyWith({
    String? id,
    AirportDetails? airportDeparture,
    AirportDetails? airportArrival,
    String? note,
  }) =>
      Flight(
          id: id ?? this.id,
          airportDeparture: airportDeparture ?? this.airportDeparture,
          airportArrival: airportArrival ?? this.airportArrival,
          note: note ?? this.note);

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
      id: json[UtilityAccessStorage.db!.fieldId],
      airportDeparture:
          AirportDetails.fromJson(json: json, type: TypeAirport.departure),
      airportArrival:
          AirportDetails.fromJson(json: json, type: TypeAirport.arrival),
      note: json[UtilityAccessStorage.db!.fieldNote] ?? "");

  ///Convert object to map like json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {UtilityAccessStorage.db!.fieldId: id};
    json.addAll(airportDeparture.toJson(type: TypeAirport.departure));
    json.addAll(airportArrival.toJson(type: TypeAirport.arrival));
    json.addAll({UtilityAccessStorage.db!.fieldNote: note});
    return json;
  }

  @override
  String toString() => (StringBuffer()
        ..writeln("id: $id")
        ..writeln("departure: ${airportDeparture.toString()}")
        ..writeln("arrival: ${airportArrival.toString()}")
        ..writeln("note: $note"))
      .toString();

  ///Construct empty flight
  factory Flight.empty() => Flight(
      id: "",
      airportDeparture: AirportDetails.empty(),
      airportArrival: AirportDetails.empty(),
      note: "");

  @override
  List<Object?> get props => [airportDeparture, airportArrival, id, note];
}
