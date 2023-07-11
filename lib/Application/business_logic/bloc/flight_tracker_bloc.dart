import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/flight.dart';
import '../../../data/model/storage_flight.dart';
import '../../../domain/repository/database_repository.dart';
import '../../../domain/repository/flight_tracker_api_repository.dart';

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
    on<FlightTrackerEventRefreshFlight>(_refreshListFlight);
    on<FlightTrackerEventRemoveFlight>(_removeFlight);
    on<FlightTrackerEventUpdateFlight>(_updateAction);
    on<FlightTrackerEventOpenDetails>(_openDetails);
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
    if (await storageFlight.addById(idFlight: event.idFlight)) {
      emit(FlightTrackerStateFlightAddedStatus(
          message: "flight add", status: Status.done));
    } else {
      emit(FlightTrackerStateFlightAddedStatus(
          message: "error add fight", status: Status.error));
    }
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  FutureOr<void> _refreshListFlight(FlightTrackerEventRefreshFlight event,
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
      emit(FlightTrackerStateFlightDeletedStatus(
          message: "flight ${event.flight.id} remove ", status: Status.done));
    } else {
      emit(FlightTrackerStateFlightDeletedStatus(
          message: "error remove flight", status: Status.error));
    }
    emit(FlightTrackerStateLoaded(
        future: storageFlight.getFutureFlight(),
        past: storageFlight.getPastFlight(),
        today: storageFlight.getTodayFlight()));
  }

  Future<FutureOr<void>> _updateAction(FlightTrackerEventUpdateFlight event,
      Emitter<FlightTrackerState> emit) async {
    bool response = await storageFlight.updateNote(event.flight);
    if (response) {
      emit(FlightTrackerStateLoaded(
          future: storageFlight.getFutureFlight(),
          past: storageFlight.getPastFlight(),
          today: storageFlight.getTodayFlight()));
    }
  }

  Future<FutureOr<void>> _openDetails(FlightTrackerEventOpenDetails event,
      Emitter<FlightTrackerState> emit) async {
    Flight? update = await storageFlight.updateFlight(flight: event.flight);
    if (update != null) {
      emit(FlightTrackerStateLoaded(
          future: storageFlight.getFutureFlight(),
          past: storageFlight.getPastFlight(),
          today: storageFlight.getTodayFlight()));
      emit(FlightTrackerStateFlightOpenDetail(update));
    } else {
      emit(FlightTrackerStateFlightOpenDetail(event.flight));
    }
  }
}
