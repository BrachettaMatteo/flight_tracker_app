import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/application/presentation/components/element_list_flight.dart';
import 'package:flight_tracker/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../application/business_logic/bloc/flight_tracker_bloc.dart';
import '../../core/utility_ui.dart';
import '../../data/model/flight.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<FlightTrackerBloc, FlightTrackerState>(
        listenWhen: (previous, current) =>
            current is FlightTrackerStateFlightDeletedStatus,
        listener: (context, state) {
          if (state is FlightTrackerStateFlightDeletedStatus) {
            ScaffoldMessenger.of(context).showSnackBar(UtilityUI.snackBar(
                status: state.status, message: state.message));
          }
        },
        buildWhen: (previous, current) =>
            previous != current && current is FlightTrackerStateLoaded,
        builder: (context, state) {
          if (state is FlightTrackerStateLoaded) {
            if (state.future.isEmpty &&
                state.past.isEmpty &&
                state.today.isEmpty) {
              return CustomScrollView(slivers: <Widget>[
                UtilityUI.appBarCustom(
                    context: context, title1: "Flight", title2: "Tracker"),
                _emptyFlights(context)
              ]);
            }
            return CustomScrollView(slivers: <Widget>[
              UtilityUI.appBarCustom(
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
        onPressed: () => context.router.push(const AddFlightRoute()),
        child: UtilityUI.iconCustom,
      );

  List<Widget> _getElementSection(
      {required String labelText,
      required List<Flight> list,
      double? opacity}) {
    if (list.isNotEmpty) {
      return [
        UtilityUI.labelSection(
          label: labelText,
        ),
        ElementListFlight(
          listFlight: list,
          opacity: opacity,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10))
      ];
    }
    return [const SliverToBoxAdapter(child: SizedBox())];
  }

  _emptyFlights(BuildContext context) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "asset/img/splash1.svg",
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              const Text("add flights to see tracking"),
            ],
          ),
        ),
      );
}
