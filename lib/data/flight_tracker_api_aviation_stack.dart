import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/model/airport_detail.dart';
import '../data/model/flight.dart';
import '../domain/repository/flight_tracker_api_repository.dart';

/// API for Aviationstack(https://aviationstack.com)
class FlightTrackerApiAviationstack extends FightTrackerApiRepository {
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
  String get fieldIdAirport => "iata";
  String personalAccessKey = "";
  @override
  String get fieldDelay => "delay";

  @override
  Future<Flight?> getFlightById(String idFlight) async {
    var url = Uri.https('api.aviationstack.com', '/v1/flights',
        {'access_key': personalAccessKey, 'flight_iata': idFlight});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> out = await jsonDecode(response.body);
      return Flight(
          id: out[locationId][fieldId],
          airportDeparture: AirportDetails(
              iata: out[fieldMapAirportDetailDeparture][fieldIdAirport] ?? "-",
              nameAirport:
                  out[fieldMapAirportDetailDeparture][fieldNameAirport] ?? "-",
              terminal: out[fieldMapAirportDetailDeparture]
                      [fieldTerminalAirport] ??
                  "",
              gate: out[fieldMapAirportDetailDeparture][fieldGateAirport] ?? "",
              estimateArrival: out[fieldMapAirportDetailDeparture]
                      [fieldTimeEstimatedAirport] ??
                  "-",
              delay: out[fieldMapAirportDetailDeparture][fieldDelay] ?? 0),
          airportArrival: AirportDetails(
              iata: out[fieldMapAirportDetailArrival][fieldIdAirport] ?? "-",
              nameAirport:
                  out[fieldMapAirportDetailArrival][fieldNameAirport] ?? "-",
              terminal:
                  out[fieldMapAirportDetailArrival][fieldTerminalAirport] ?? "",
              gate: out[fieldMapAirportDetailArrival][fieldGateAirport] ?? "",
              estimateArrival: out[fieldMapAirportDetailArrival]
                      [fieldTimeEstimatedAirport] ??
                  "-",
              delay: out[fieldMapAirportDetailArrival][fieldDelay] ?? 0),
          note: "");
    }
    return null;
  }

  @override
  Future<List<Flight>> updateListFlight(
      {required List<Flight> listToUpdate}) async {
    List<Flight> out = [];
    for (Flight flight in listToUpdate) {
      Flight valueUpdate = (await getFlightById(flight.id))!;
      out.add(flight.copyWith(
          airportDeparture: valueUpdate.airportDeparture,
          airportArrival: valueUpdate.airportArrival));
    }
    return out;
  }
}
