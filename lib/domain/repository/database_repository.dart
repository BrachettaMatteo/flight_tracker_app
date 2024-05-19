import '../../data/model/flight.dart';

/// Repository for represent the Database
abstract class DatabaseRepository {
  /// field identifying delay
  String get fieldDelay;

  /// field represent name of db
  String get nameDb;

  /// field represent name of table
  String get nameTable;

  /// field for id
  String get fieldId;

  /// field for Airport Detail Departure
  String get fieldMapAirportDetailDeparture;

  /// field for Airport Detail Arrival
  String get fieldMapAirportDetailArrival;

  /// field for Flight note
  String get fieldNote;

  /// field for name airport
  String get fieldNameAirport;

  /// field for identifier airport
  String get fieldIdAirport;

  /// field for terminal airport
  String get fieldTerminalAirport;

  /// field for gate airport
  String get fieldGateAirport;

  /// field for estimate arrival in airport
  String get fieldTimeEstimatedAirport;

  ///Action to init database, loading data or create new Database
  Future<void> initDB();

  /// Action to return all flight
  Future<List<Flight>> getAllFlight();

  /// Action to add flight
  /// /// [Flight] flight to add
  Future<void> addFlight(Flight flight);

  /// Action to remove flight
  /// [Flight] flight to remove
  Future<void> removeFlight(Flight flight);

  /// Action to update flight
  /// [Flight] flight to update
  Future<void> updateFlight(Flight flight);
}
