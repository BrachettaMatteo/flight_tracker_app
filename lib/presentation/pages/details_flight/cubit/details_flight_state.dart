part of 'details_flight_cubit.dart';

@immutable
class DetailsFlightState extends Equatable {
  final Flight flight;
  final String noteWriting;
  final bool flightIsDelay;
  const DetailsFlightState(
      {required this.flight,
      this.noteWriting = "",
      this.flightIsDelay = false});
  @override
  List<Object> get props => [noteWriting, flightIsDelay, flight];

  DetailsFlightState copyWith({
    Flight? flight,
    String? noteWriting,
    bool? flightIsDelay,
  }) =>
      DetailsFlightState(
          flight: flight ?? this.flight,
          noteWriting: noteWriting ?? this.noteWriting,
          flightIsDelay: flightIsDelay ?? this.flightIsDelay);
}
