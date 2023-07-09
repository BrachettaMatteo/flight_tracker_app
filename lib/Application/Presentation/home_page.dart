import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Data/model/args_detail_page.dart';
import '../../Data/model/flight.dart';
import '../../core/utility_ui.dart';
import '../BusinessLogic/bloc/flight_tracker_bloc.dart';
import 'add_flight_page.dart';
import 'components/label_section.dart';
import 'components/list_costum.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  static String route = "/";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<FlightTrackerBloc, FlightTrackerState>(
        listenWhen: (previous, current) =>
            previous != current &&
            (current is FlightTrackerStateStatus ||
                current is FlightTrackerStateFlightUpdate),
        listener: (context, state) {
          log("check listen");
          if (state is FlightTrackerStateStatus) {
            log("call status: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(UtilityUI.snackBar(
                status: state.status, message: state.message));
          }
          if (state is FlightTrackerStateFlightUpdate) {
            Navigator.of(context).pushNamed(DetailsPage.route,
                arguments: ArgsDetailsPage(state.flight));
          }
        },
        buildWhen: (previous, current) =>
            previous != current && current is FlightTrackerStateLoaded,
        builder: (context, state) {
          if (state is FlightTrackerStateLoaded) {
            if (state.future.isEmpty &&
                state.past.isEmpty &&
                state.today.isEmpty) {
              _emptyFlights(context);
            }
            return CustomScrollView(slivers: <Widget>[
              UtilityUI.appBarCostum(
                  context: context, title1: "Flight", title2: "Tracker"),
              ..._getElementSection(labelText: "Today", list: state.today),
              ..._getElementSection(
                  labelText: "Coming soon", list: state.future),
              ..._getElementSection(
                  labelText: "Past", list: state.past, opacity: 0.5)
            ]);
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),
      floatingActionButton: _floatingButton(context),
    );
  }

  FloatingActionButton _floatingButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AddFlightPage.route),
        child: UtilityUI.iconCostum,
      );

  List<Widget> _getElementSection(
      {required String labelText,
      required List<Flight> list,
      double? opacity}) {
    if (list.isNotEmpty) {
      return [
        LabelSection(
          label: labelText,
        ),
        ListCostum(
          listFlight: list,
          opacity: opacity,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10))
      ];
    }
    return [const SliverToBoxAdapter(child: SizedBox())];
  }

  _emptyFlights(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              "asset/img/splash1.svg",
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            const Text("add flights to see the progress"),
          ],
        ),
      );
}
