part of 'flight_tracker_bloc.dart';

@immutable
abstract class FlightTrackerEvent {}

class FlightTrackerEventInit extends FlightTrackerEvent {}

class FlightTrackerEventAddFlight extends FlightTrackerEvent {
  final String idFlight;

  FlightTrackerEventAddFlight({required this.idFlight});
}

class FlightTrackerEventRemoveFlight extends FlightTrackerEvent {
  final Flight flight;

  FlightTrackerEventRemoveFlight({required this.flight});
}

class FlightTrackerEventRefreshFlight extends FlightTrackerEvent {
  final String iataFlight;

  FlightTrackerEventRefreshFlight({required this.iataFlight});
}

class FlightTrackerEventUpdateFlight extends FlightTrackerEvent {
  final Flight flight;

  FlightTrackerEventUpdateFlight({required this.flight});
}
