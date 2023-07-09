import 'package:flight_tracker/Data/model/flight.dart';

/// Repository for rappresent the implementation of api
abstract class FightTrackerApiRepository {
  String get fieldId;
  String get fieldMapAirportDetailDeparture;
  String get fieldMapAirportDetailArrival;
  String get fieldDelay;
  String get fieldNameAirport;
  String get fieldidAirport;
  String get fieldTerminalAirport;
  String get fieldGateAirport;
  String get fieldTimeEstimatedAirport;

  Future<Flight?> getFlightById(String idFlight);

  Future<List<Flight>> updateListFlight({required List<Flight> listToUpdate});
}
