import 'package:flight_tracker/data/flight_tracker_api_local.dart';
import 'package:flight_tracker/data/model/airport_detail.dart';
import 'package:flight_tracker/data/model/flight.dart';
import 'package:flight_tracker/domain/repository/flight_tracker_api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FightTrackerApiRepository apiLocal;
  final Flight flightCorrect = Flight(
      id: "EK5159",
      airportDeparture: AirportDetails(
          iata: "SYD",
          nameAirport: "Kingsford Smith",
          terminal: "3",
          gate: "T3G",
          estimateArrival: DateTime.parse("2022-02-18T08:40:00+00:00"),
          delay: 10),
      airportArrival: AirportDetails(
          iata: "PQQ",
          nameAirport: "Port Macquarie",
          terminal: "2",
          gate: "-",
          estimateArrival: DateTime.parse("2022-02-18T09:40:00+00:00"),
          delay: 0),
      note: "");
  final Flight flightUpdate = Flight(
      id: "EK5159",
      airportDeparture: AirportDetails(
          iata: "SYD",
          nameAirport: "Kingsford Smith",
          terminal: "3",
          gate: "T3G",
          estimateArrival: DateTime.parse("2022-02-18T10:40:00+00:00"),
          delay: 120),
      airportArrival: AirportDetails(
          iata: "PQQ",
          nameAirport: "Port Macquarie",
          terminal: "2",
          gate: "-",
          estimateArrival: DateTime.parse("2022-02-18T11:40:00+00:00"),
          delay: 120),
      note: "");

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    apiLocal = FlightTrackerApiLocal(
        pathJsonResource: "asset/test.json",
        pathJsonResourceUpdate: "asset/updateTest.json");
  });

  test('Test get flight by id', () async {
    Flight? f = await apiLocal.getFlightById("EK5159");
    expect(flightCorrect, f!);
    Flight? flightError = await apiLocal.getFlightById("------");
    expect(null, flightError);
  });
  test("Test Update List", () async {
    expect([flightUpdate],
        await apiLocal.updateListFlight(listToUpdate: [flightCorrect]));
  });
}
