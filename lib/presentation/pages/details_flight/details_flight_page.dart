import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flight_tracker/presentation/pages/details_flight/cubit/details_flight_cubit.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/flight.dart';
import '../../../../core/Utility_UI.dart';
import 'clipper/custom_footer_clipper.dart';
import 'clipper/custom_header_clipper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Page represent Ui for details flight
/// Version:1.1.0
@RoutePage()
class DetailsFlightPage extends StatelessWidget {
  const DetailsFlightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailsFlightCubit, DetailsFlightState>(
        builder: (context, state) {
          return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.down,
              slivers: <Widget>[
                _header(context: context),
                _numberFlight(id: state.flight.id),
                _infoGrid(flight: state.flight, context: context),
              ]);
        },
      ),
      floatingActionButton: _addNote(context: context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _header({required BuildContext context}) => SliverToBoxAdapter(
        child: BlocBuilder<DetailsFlightCubit, DetailsFlightState>(
          builder: (context, state) {
            return ClipPath(
              clipper: CustomHeaderCLip(),
              child: Container(
                color: state.flightIsDelay
                    ? Colors.red.shade400
                    : Colors.green.shade400,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: _getInfoAirport(
                                nameAirport:
                                    state.flight.airportDeparture.nameAirport,
                                iata: state.flight.airportDeparture.iata,
                                alingText: CrossAxisAlignment.start,
                                context: context)),
                      ),
                      UtilityUI.iconCustom(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: _getInfoAirport(
                                nameAirport:
                                    state.flight.airportArrival.nameAirport,
                                iata: state.flight.airportArrival.iata,
                                alingText: CrossAxisAlignment.end,
                                context: context)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _getInfoAirport(
          {required String nameAirport,
          required String iata,
          required CrossAxisAlignment alingText,
          required BuildContext context}) =>
      Column(
        crossAxisAlignment: alingText,
        children: [
          AutoSizeText(
            nameAirport,
            textAlign: alingText == CrossAxisAlignment.start
                ? TextAlign.start
                : TextAlign.end,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          AutoSizeText(iata),
        ],
      );

  SliverGrid _infoGrid(
          {required Flight flight, required BuildContext context}) =>
      SliverGrid.count(crossAxisCount: 2, childAspectRatio: 2, children: [
        _infoElement(
            label:
                AppLocalizations.of(context)!.label_departure_detailsFlightPage,
            value: DateFormat('HH:mm')
                .format(flight.airportDeparture.estimateArrival),
            context: context),
        _infoElement(
            label: AppLocalizations.of(context)!
                .label_gateTerminal_detailsFlightPage,
            value:
                "${flight.airportDeparture.gate} - ${flight.airportDeparture.terminal}",
            context: context),
        _infoElement(
            label:
                AppLocalizations.of(context)!.label_arrival_detailsFlightPage,
            value: DateFormat('HH:mm')
                .format(flight.airportArrival.estimateArrival),
            context: context),
        _infoElement(
            label: AppLocalizations.of(context)!
                .label_gateTerminal_detailsFlightPage,
            value:
                "${flight.airportArrival.gate} - ${flight.airportArrival.terminal}",
            context: context),
      ]);

  Widget _infoElement(
      {required String label,
      required String value,
      required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerTheme.color!,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ],
      ),
    );
  }

  Widget _numberFlight({required id}) => SliverToBoxAdapter(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(id,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
        ]),
      );

  Widget _addNote({required BuildContext context}) => ClipPath(
        clipper: CustomFooterClipper(),
        child: Container(
            height: 150,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.grey.shade200,
                Theme.of(context).scaffoldBackgroundColor
              ],
            )),
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(top: 150 * 0.15),
                  child: Text(AppLocalizations.of(context)!.label_note)),
              BlocBuilder<DetailsFlightCubit, DetailsFlightState>(
                builder: (context, state) {
                  return TextFormField(
                    initialValue: state.noteWriting,
                    maxLines: 3,
                    onChanged: (value) => context
                        .read<DetailsFlightCubit>()
                        .changeNote(note: value),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) async {
                      await context.read<DetailsFlightCubit>().saveNote(
                          context: context,
                          messageError: AppLocalizations.of(context)!
                              .message_error_updateFlight);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    textAlign: TextAlign.center,
                    cursorColor: Colors.blue,
                    showCursor: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                  );
                },
              ),
            ])),
      );
}
