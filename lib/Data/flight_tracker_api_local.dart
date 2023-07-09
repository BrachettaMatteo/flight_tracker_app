import 'dart:convert';
import 'package:flutter/services.dart';

import '../Domain/Repository/flight_tracker_api_repository.dart';
import 'model/airport_detail.dart';
import 'model/flight.dart';

/// Api for local storage, json structure is the same as aviation stack
class FligthTrackerApiLocal extends FightTrackerApiRepository {
  final String pathJsonResource;
  final String pathJsonResourceUpdate;

  FligthTrackerApiLocal(
      {required this.pathJsonResource, required this.pathJsonResourceUpdate});

  @override
  String get fieldGateAirport => "gate";
  @override
  String get fieldId => "iata";
  String get locationId => "flight";
  @override
  String get fieldMapAirportDetailArrival => "arrival";
  @override
  String get fieldMapAirportDetailDeparture => "departure";
  @override
  String get fieldNameAirport => "airport";
  @override
  String get fieldTerminalAirport => "terminal";
  @override
  String get fieldTimeEstimatedAirport => "estimated";
  @override
  String get fieldidAirport => "iata";
  String personalAccesKey = "";
  @override
  String get fieldDelay => "delay";
  @override
  Future<Flight?> getFlightById(String idFlight, [String? pathRef]) async {
    final String response =
        await rootBundle.loadString(pathRef ?? pathJsonResource);
    List<dynamic> listDirty = await jsonDecode(response);

    Map<String, dynamic>? el = listDirty
        .where((element) => element[locationId][fieldId] == idFlight)
        .firstOrNull;

    return el != null
        ? Flight(
            id: el[locationId][fieldId],
            aiportDeparture: AirportDetails(
                iata: el[fieldMapAirportDetailDeparture][fieldidAirport] ?? "-",
                nameAriport:
                    el[fieldMapAirportDetailDeparture][fieldNameAirport] ?? "-",
                terminal: el[fieldMapAirportDetailDeparture]
                        [fieldTerminalAirport] ??
                    "-",
                gate:
                    el[fieldMapAirportDetailDeparture][fieldGateAirport] ?? "-",
                estimateArrival: DateTime.parse(
                    el[fieldMapAirportDetailDeparture]
                        [fieldTimeEstimatedAirport]),
                delay: el[fieldMapAirportDetailDeparture][fieldDelay] ?? 0),
            airportArrival: AirportDetails(
                iata: el[fieldMapAirportDetailArrival][fieldidAirport] ?? "-",
                nameAriport:
                    el[fieldMapAirportDetailArrival][fieldNameAirport] ?? "-",
                terminal: el[fieldMapAirportDetailArrival]
                        [fieldTerminalAirport] ??
                    "-",
                gate: el[fieldMapAirportDetailArrival][fieldGateAirport] ?? "-",
                estimateArrival: DateTime.parse(el[fieldMapAirportDetailArrival]
                    [fieldTimeEstimatedAirport]),
                delay: el[fieldMapAirportDetailArrival][fieldDelay] ?? 0),
            note: "")
        : null;
  }

  @override
  Future<List<Flight>> updateListFlight(
      {required List<Flight> listToUpdate}) async {
    List<Flight> out = [];
    for (Flight f in listToUpdate) {
      Flight? update = await getFlightById(f.id, pathJsonResourceUpdate);
      update != null ? out.add(update.copyWith(note: f.note)) : out.add(f);
    }
    return out;
  }
}
