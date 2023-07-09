import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/model/flight.dart';
import '../../../Data/model/storage_flight.dart';
import '../../../Domain/Repository/database_repository.dart';
import '../../../Domain/Repository/flight_tracker_api_repository.dart';

part 'flight_tracker_event.dart';
part 'flight_tracker_state.dart';

class FlightTrackerBloc extends Bloc<FlightTrackerEvent, FlightTrackerState> {
  late StorageFlight storageFlight;
  DatabaseRepository db;
  FightTrackerApiRepository repoApi;
  FlightTrackerBloc({required this.db, required this.repoApi})
      : super(FlightTrackerInitial()) {
    on<FlightTrackerEventInit>(_initAction);
    on<FlightTrackerEventAddFlight>(_addFlight);
    on<FlightTrackerEventRefreshFlight>(_refresListFlight);
    on<FlightTrackerEventRemoveFlight>(_removeFlight);
    on<FlightTrackerEventUpdateFlight>(_updateAction);
  }

  FutureOr<void> _initAction(
      FlightTrackerEventInit event, Emitter<FlightTrackerState> emit) async {
    storageFlight = StorageFlight(db: db, api: repoApi);
    await storageFlight.init();
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  FutureOr<void> _addFlight(FlightTrackerEventAddFlight event,
      Emitter<FlightTrackerState> emit) async {
    bool response = await storageFlight.addById(idFlight: event.idFlight);

    if (response) {
      emit(
          FlightTrackerStateStatus(message: "flight add", status: Status.done));
    } else {
      emit(FlightTrackerStateStatus(
          message: "error add fight", status: Status.error));
    }
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  FutureOr<void> _refresListFlight(FlightTrackerEventRefreshFlight event,
      Emitter<FlightTrackerState> emit) async {
    await storageFlight.refresh();
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  FutureOr<void> _removeFlight(FlightTrackerEventRemoveFlight event,
      Emitter<FlightTrackerState> emit) async {
    //list release
    if (await storageFlight.remove(flight: event.flight)) {
      emit(FlightTrackerStateStatus(
          message: "flight ${event.flight.id} remove ", status: Status.done));
    } else {
      emit(FlightTrackerStateStatus(
          message: "error remove flight", status: Status.error));
    }
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  Future<FutureOr<void>> _updateAction(FlightTrackerEventUpdateFlight event,
      Emitter<FlightTrackerState> emit) async {
    Flight? update = await storageFlight.updateFlight(flight: event.flight);
    log("_update action ${update.toString()}");
    if (update != null) {
      emit(FlightTrackerStateLoaded(
          future: storageFlight.getFutureFlight(),
          past: storageFlight.getPastFlight(),
          today: storageFlight.getTodayFlight()));
      emit(FlightTrackerStateFlightUpdate(flight: update));
    } else {
      emit(FlightTrackerStateFlightUpdate(flight: event.flight));
    }
  }
}
