import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/core/routes/app_router.dart';
import 'package:flight_tracker/presentation/pages/home/logic/home_page_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/pages/notification_page/logic/bloc/notification_bloc.dart';
import 'package:flight_tracker/presentation/pages/home/widget/flight_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui_kit/ui_kit.dart';
import '../../../../data/model/flight.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(UIKit.snackBar(
                  isCorrect: state.status == HomePageStatus.done,
                  message: state.message));
            }
          },
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.status == HomePageStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.flightsFuture.isEmpty &&
                state.flightsPassed.isEmpty &&
                state.flightsToday.isEmpty) {
              return CustomScrollView(slivers: <Widget>[
                UIKit.appBar(
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
                UIKit.appBar(
                    context: context,
                    title1: "Flight",
                    title2: "Tracker",
                    actions: [
                      BlocBuilder<NotificationBloc, NotificationState>(
                        buildWhen: (previous, current) =>
                            previous.notificationToSee !=
                            current.notificationToSee,
                        builder: (context, state) => IconButton(
                            onPressed: () =>
                                context.router.push(const NotificationRoute()),
                            icon: Badge(
                                label: Text(state.notificationToSee.toString()),
                                isLabelVisible: state.notificationToSee > 0,
                                child: const Icon(Icons.notifications))),
                      )
                    ]),
                ..._getElementSection(
                    labelText:
                        AppLocalizations.of(context)!.section_today_homePage,
                    list: state.flightsToday),
                ..._getElementSection(
                    labelText: AppLocalizations.of(context)!
                        .section_comingSoon_homePage,
                    list: state.flightsFuture),
                ..._getElementSection(
                    labelText:
                        AppLocalizations.of(context)!.section_past_homePage,
                    list: state.flightsPassed,
                    opacity: 0.5)
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
        child: UIKit.icon(),
      );

  List<Widget> _getElementSection(
      {required String labelText,
      required List<Flight> list,
      double? opacity}) {
    if (list.isNotEmpty) {
      return [
        UIKit.labelSection(
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
              Text(AppLocalizations.of(context)!.message_empty_homepage),
            ],
          ),
        ),
      );
}