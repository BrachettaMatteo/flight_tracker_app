import 'package:flutter/material.dart';

import '../../core/utility.dart';
import '../my_db.dart';
import 'airport_detail.dart';

///Represent the flight.
///The flight is compost:
///
///[id] to identify unique flight;
///[airportDeparture] to container the information of airport departure;
///[airportArrival] to container the information of airport arrival;
@immutable
class Flight {
  final AirportDetails airportDeparture;
  final AirportDetails airportArrival;
  final String id;
  final String note;

  const Flight(
      {required this.id,
      required this.airportDeparture,
      required this.airportArrival,
      required this.note});

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
      id: json[Utility.db!.fieldId],
      airportDeparture:
          AirportDetails.fromJson(json: json, type: TypeAirport.departure),
      airportArrival:
          AirportDetails.fromJson(json: json, type: TypeAirport.arrival),
      note: json[Utility.db!.fieldNote] ?? "");

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {Utility.db!.fieldId: id};
    json.addAll(airportDeparture.toJson(type: TypeAirport.departure));
    json.addAll(airportArrival.toJson(type: TypeAirport.arrival));
    json.addAll({Utility.db!.fieldNote: note});
    return json;
  }

  @override
  String toString() => (StringBuffer()
        ..writeln("id: $id")
        ..writeln("departure: ${airportDeparture.toString()}")
        ..writeln("arrival: ${airportArrival.toString()}")
        ..writeln("note: $note"))
      .toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Flight &&
          id == other.id &&
          airportDeparture == other.airportDeparture &&
          airportArrival == other.airportArrival;

  @override
  int get hashCode => id.hashCode;
}
