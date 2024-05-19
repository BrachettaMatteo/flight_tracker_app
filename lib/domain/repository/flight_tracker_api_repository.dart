import '../../data/model/flight.dart';

/// Repository for represent the implementation of api
abstract class FightTrackerApiRepository {
  /// field identifying flight id
  String get fieldId;

  /// field identifying map details airport departure
  String get fieldMapAirportDetailDeparture;

  /// field identifying map details arrival
  String get fieldMapAirportDetailArrival;

  /// field identifying delay
  String get fieldDelay;

  /// field identifying name Airport
  String get fieldNameAirport;

  /// field identifying airport id
  String get fieldIdAirport;

  /// field identifying terminal of Airport
  String get fieldTerminalAirport;

  /// field identifying  gate airport
  String get fieldGateAirport;

  /// field identifying estimated arrived
  String get fieldTimeEstimatedAirport;

  /// Action to research flight by [idFlight]
  Future<Flight?> getFlightById(String idFlight);

  /// Action to request update flight
  /// [listToUpdate] list of flight to update
  Future<List<Flight>> updateListFlight({required List<Flight> listToUpdate});
}
