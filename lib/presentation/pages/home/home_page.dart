import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/core/routes/app_router.dart';
import 'package:flight_tracker/presentation/pages/home/cubit/home_page_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/widget/flight_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utility_ui.dart';
import '../../../data/model/flight.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomePageCubit, HomePageState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) async {
            if (state.message != "") {
              ScaffoldMessenger.of(context).showSnackBar(UtilityUI.snackBar(
                  status: state.status, message: state.message));
            }
          },
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.status == Status.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.flightsFuture.isEmpty &&
                state.flightsPassed.isEmpty &&
                state.flightsToday.isEmpty) {
              return CustomScrollView(slivers: <Widget>[
                UtilityUI.appBarCustom(
                    context: context, title1: "Flight", title2: "Tracker"),
                _emptyFlights(context)
              ]);
            }
            return RefreshIndicator(
              color: Colors.white,
              strokeWidth: 2.0,
              onRefresh: () async {
                context.read<HomePageCubit>().refresh();
                return Future<void>.delayed(const Duration(seconds: 1));
              },
              child: CustomScrollView(slivers: <Widget>[
                UtilityUI.appBarCustom(
                    context: context, title1: "Flight", title2: "Tracker"),
                ..._getElementSection(
                    labelText: "Today", list: state.flightsToday),
                ..._getElementSection(
                    labelText: "Coming soon", list: state.flightsFuture),
                ..._getElementSection(
                    labelText: "Past", list: state.flightsPassed, opacity: 0.5)
              ]),
            );
          },
        ),
      ),
      floatingActionButton: _floatingButton(context),
    );
  }

  FloatingActionButton _floatingButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => context.router.push(const AddFlightRoute()),
        child: UtilityUI.iconCustom(),
      );

  List<Widget> _getElementSection(
      {required String labelText,
      required List<Flight> list,
      double? opacity}) {
    if (list.isNotEmpty) {
      return [
        UtilityUI.labelSection(
          label: labelText,
          infoText: null,
        ),
        FlightList(list: list),
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
                "assets/img/splash1.svg",
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              const Text("add flights to see tracking"),
            ],
          ),
        ),
      );
}
