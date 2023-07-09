import 'package:flight_tracker/Data/model/flight.dart';

/// Repository for rappresent the Database
abstract class DatabaseRepository {
  String get fieldDelay;

  String get nameDb;
  String get nameTable;

  String get fieldId;
  String get fieldMapAirportDetailDeparture;
  String get fieldMapAirportDetailArrival;
  String get fieldNote;

  String get fieldNameAirport;
  String get fieldidAirport;
  String get fieldTerminalAirport;
  String get fieldGateAirport;
  String get fieldTimeEstimatedAirport;

  Future<void> initDB();
  Future<List<Flight>> getAllFlight();
  Future<void> addFlight(Flight flight);
  Future<void> removeFlight(Flight flight);

  Future<void> updateFlight(Flight flight);
  Future<void> updateNoteFligth(Flight flight, String note);
}
