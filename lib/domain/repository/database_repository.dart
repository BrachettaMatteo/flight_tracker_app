import '../../data/model/flight.dart';

/// Repository for represent the Database
abstract class DatabaseRepository {
  String get fieldDelay;

  String get nameDb;
  String get nameTable;

  String get fieldId;
  String get fieldMapAirportDetailDeparture;
  String get fieldMapAirportDetailArrival;
  String get fieldNote;

  String get fieldNameAirport;
  String get fieldIdAirport;
  String get fieldTerminalAirport;
  String get fieldGateAirport;
  String get fieldTimeEstimatedAirport;

  Future<void> initDB();
  Future<List<Flight>> getAllFlight();
  Future<void> addFlight(Flight flight);
  Future<void> removeFlight(Flight flight);

  Future<void> updateFlight(Flight flight);
  Future<void> updateNoteFlight(Flight flight, String note);
}
