import 'package:equatable/equatable.dart';
import 'package:flight_tracker/data/model/flight.dart';
import 'package:flight_tracker/domain/repository/database_repository.dart';
import 'package:flight_tracker/presentation/pages/home/cubit/home_page_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_flight_state.dart';

class DetailsFlightCubit extends Cubit<DetailsFlightState> {
  final DatabaseRepository db;
  DetailsFlightCubit(this.db)
      : super(DetailsFlightState(flight: Flight.empty()));

  ///Action for init cubit
  Future<void> init({required Flight flight}) async => emit(state.copyWith(
      flight: flight,
      noteWriting: flight.note,
      flightIsDelay:
          flight.airportArrival.estimateArrival.isBefore(DateTime.now())));

  ///Action for change note
  Future<void> changeNote({required String note}) async =>
      emit(state.copyWith(noteWriting: note));

  ///Action for save note
  Future<void> saveNote({required BuildContext context}) async {
    Flight flight = state.flight.copyWith(note: state.noteWriting);
    await db.updateFlight(flight).then((_) => {
          context.read<HomePageCubit>().updateFlight(
              flight: state.flight.copyWith(note: state.noteWriting))
        });
  }
}
