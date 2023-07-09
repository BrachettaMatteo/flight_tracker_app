import 'package:flutter/material.dart';

import '../../core/utility.dart';
import '../my_db.dart';
import 'airport_detail.dart';

///Rappresent the flight.
///The flight is compost:
///
///[id] to identific unique flight;
///[aiportDeparture] to container the infromation of ariport departure;
///[airportArrival] to container the information of airport arrival;
@immutable
class Flight {
  final AirportDetails aiportDeparture;
  final AirportDetails airportArrival;
  final String id;
  final String note;

  const Flight(
      {required this.id,
      required this.aiportDeparture,
      required this.airportArrival,
      required this.note});

  Flight copyWith({
    String? id,
    AirportDetails? aiportDeparture,
    AirportDetails? airportArrival,
    String? note,
  }) =>
      Flight(
          id: id ?? this.id,
          aiportDeparture: aiportDeparture ?? this.aiportDeparture,
          airportArrival: airportArrival ?? this.airportArrival,
          note: note ?? this.note);

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
      id: json[Utility.db!.fieldId],
      aiportDeparture:
          AirportDetails.fromJson(json: json, type: TypeAirpot.departure),
      airportArrival:
          AirportDetails.fromJson(json: json, type: TypeAirpot.arrival),
      note: json[Utility.db!.fieldNote] ?? "");

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {Utility.db!.fieldId: id};
    json.addAll(aiportDeparture.toJson(type: TypeAirpot.departure));
    json.addAll(airportArrival.toJson(type: TypeAirpot.arrival));
    json.addAll({Utility.db!.fieldNote: note});
    return json;
  }

  @override
  String toString() => (StringBuffer()
        ..writeln("id: $id")
        ..writeln("departure: ${aiportDeparture.toString()}")
        ..writeln("arrival: ${airportArrival.toString()}")
        ..writeln("note: $note"))
      .toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Flight &&
          id == other.id &&
          aiportDeparture == other.aiportDeparture &&
          airportArrival == other.airportArrival;

  @override
  int get hashCode => id.hashCode;
}
