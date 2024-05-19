part of 'home_page_cubit.dart';

@immutable
class HomePageState extends Equatable {
  ///List represent flight today
  final List<Flight> flightsToday;

  ///List represent flight passed
  final List<Flight> flightsPassed;

  ///List represent future flight
  final List<Flight> flightsFuture;

  /// Status of cubit
  final Status status;

  final String message;

  const HomePageState(
      {required this.flightsToday,
      required this.flightsPassed,
      required this.flightsFuture,
      required this.status,
      this.message = ""});

  HomePageState copyWith(
          {List<Flight>? flightsToday,
          List<Flight>? flightsPassed,
          List<Flight>? flightsFuture,
          Status? status,
          String? message}) =>
      HomePageState(
          flightsToday: flightsToday ?? this.flightsToday,
          flightsFuture: flightsFuture ?? this.flightsFuture,
          flightsPassed: flightsPassed ?? this.flightsPassed,
          status: status ?? this.status,
          message: message ?? this.message);

  @override
  List<Object> get props =>
      [flightsFuture, flightsPassed, flightsToday, status];
}

class HomePageInitial extends HomePageState {
  const HomePageInitial(
      {super.flightsToday = const [],
      super.flightsPassed = const [],
      super.flightsFuture = const [],
      super.status = Status.initial,
      super.message = ""});
}

enum Status { initial, work, error, done }
