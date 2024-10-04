import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_tracker/core/notification_service.dart';
import 'package:flight_tracker/data/model/flight.dart';
import 'package:flight_tracker/data/model/storage_flight.dart';
import 'package:flight_tracker/domain/repository/database_repository.dart';
import 'package:flight_tracker/domain/repository/flight_tracker_api_repository.dart';
import 'package:flight_tracker/presentation/pages/home/logic/status/status_homePage.dart';
import 'package:flutter/cupertino.dart';

export 'package:flight_tracker/presentation/pages/home/logic/status/status_homePage.dart';
part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  late StorageFlight storageFlight;

  /// Repository to save data
  final DatabaseRepository db;

  /// Repository to get data of flight
  final FightTrackerApiRepository repoApi;

  HomePageCubit({required this.db, required this.repoApi})
      : super(const HomePageInitial());

  Future<void> init() async {
    storageFlight = StorageFlight(db: db, api: repoApi);
    await storageFlight.init();
    emit(HomePageState(
        flightsToday: storageFlight.getTodayFlight(),
        flightsPassed: storageFlight.getPastFlight(),
        flightsFuture: storageFlight.getFutureFlight(),
        status: HomePageStatus.work));
  }

  /// Add flight on personal list with
  /// [gufi]  Globally Unique Flight Identifier
  Future<bool> addFlight(
      {required String gufi,
      String? messageAdded,
      String? messageFailureAdded}) async {
    Flight? flight = await repoApi.getFlightById(gufi);
    if (flight != null) {
      if (await storageFlight.addById(idFlight: flight.id)) {
        DateTime estimateNotification = flight.airportDeparture.estimateArrival
            .subtract(const Duration(hours: 3));
        DateTime estimatedSecondNotification = flight
            .airportDeparture.estimateArrival
            .subtract(const Duration(minutes: 30));

        NotificationService().scheduleNotification(
            id: 2,
            title: "Ready to FLight?",
            body:
                "The flight $gufi departure on: ${flight.airportDeparture.estimateArrival}",
            listDateNotification: [
              estimateNotification,
              estimatedSecondNotification
            ]);

        emit(state.copyWith(
            message: messageAdded ?? "flight add",
            status: HomePageStatus.done));
      } else {
        emit(state.copyWith(
            message: messageFailureAdded ?? "error add fight",
            status: HomePageStatus.error));
        return false;
      }
      emit(HomePageState(
          flightsToday: storageFlight.getTodayFlight(),
          flightsPassed: storageFlight.getPastFlight(),
          flightsFuture: storageFlight.getFutureFlight(),
          status: HomePageStatus.work));
      return true;
    }
    emit(state.copyWith(
        message: "flight not exist", status: HomePageStatus.error));
    return false;
  }

  /// Remove flight by identifier [idFlight]
  Future<void> removeFlight(
      {required Flight flight,
      String? messageDelete,
      String? messageFailureDelate}) async {
    if (await storageFlight.remove(flight: flight)) {
      emit(state.copyWith(
          message: messageDelete ?? "flight remove",
          status: HomePageStatus.done));
    } else {
      emit(state.copyWith(
          message: messageFailureDelate ?? "error remove fight",
          status: HomePageStatus.error));
    }
    emit(HomePageState(
        flightsToday: storageFlight.getTodayFlight(),
        flightsPassed: storageFlight.getPastFlight(),
        flightsFuture: storageFlight.getFutureFlight(),
        status: HomePageStatus.work));
  }

  /// Refresh data flight
  Future<void> refresh() async {
    List<Flight> listFlightUpdate = [];
    listFlightUpdate.addAll(state.flightsFuture.toList());
    listFlightUpdate.addAll(state.flightsPassed.toList());
    listFlightUpdate.addAll(state.flightsToday.toList());

    List<Flight> update =
        await repoApi.updateListFlight(listToUpdate: listFlightUpdate);
    emit(HomePageState(
        flightsToday: _getListToday(update),
        flightsPassed: _getListPass(update),
        flightsFuture: _getListFuture(update),
        status: HomePageStatus.work));
  }

  ///Update in local flight
  void updateFlight({required Flight flight, String? messageError}) {
    //check list content already update flight
    if (state.flightsFuture.contains(flight) ||
        state.flightsPassed.contains(flight) ||
        state.flightsToday.contains(flight)) return;

    //search and update flight
    if (state.flightsToday.where((f) => f.id == flight.id).isNotEmpty) {
      var list = storageFlight.getTodayFlight();
      list.removeWhere((f) => f.id == flight.id);
      list.add(flight);
      return emit(state.copyWith(flightsToday: list));
    }
    if (state.flightsFuture.where((f) => f.id == flight.id).isNotEmpty) {
      var list = storageFlight.getFutureFlight();
      list.removeWhere((f) => f.id == flight.id);
      list.add(flight);
      return emit(state.copyWith(flightsFuture: list));
    }
    if (state.flightsPassed.where((f) => f.id == flight.id).isNotEmpty) {
      var list = storageFlight.getPastFlight();
      list.removeWhere((f) => f.id == flight.id);
      list.add(flight);
      return emit(state.copyWith(flightsPassed: list));
    }
    emit(state.copyWith(
        status: HomePageStatus.error,
        message: messageError ?? "error update flight"));
  }

  List<Flight> _getListToday(List<Flight> update) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime tomorrow = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    return update
        .where((flight) =>
            flight.airportDeparture.estimateArrival.isAfter(today) &&
            flight.airportDeparture.estimateArrival.isBefore(tomorrow))
        .toList();
  }

  List<Flight> _getListPass(List<Flight> update) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return update
        .where(
            (flight) => flight.airportDeparture.estimateArrival.isBefore(today))
        .toList();
  }

  List<Flight> _getListFuture(List<Flight> update) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return update
        .where(
            (flight) => flight.airportDeparture.estimateArrival.isAfter(today))
        .toList();
  }
}
