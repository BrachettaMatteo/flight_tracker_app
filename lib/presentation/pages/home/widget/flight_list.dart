import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flight_tracker/core/routes/app_router.dart';
import 'package:flight_tracker/data/model/flight.dart';
import 'package:flight_tracker/presentation/pages/details_flight/cubit/details_flight_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/cubit/home_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FlightList extends StatelessWidget {
  final List<Flight> list;
  const FlightList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? SliverList.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return index == 0 || index == list.length + 1
                  ? const SizedBox.shrink()
                  : elementFlight(flight: list[index - 1], context: context);
            },
            itemCount: list.length + 2,
          )
        : const SliverToBoxAdapter(child: SizedBox());
  }

  elementFlight({required Flight flight, required BuildContext context}) {
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Dismissible(
      key: Key(flight.id),
      background: Container(color: Colors.red),
      onDismissed: (_) =>
          context.read<HomePageCubit>().removeFlight(flight: flight),
      child: InkWell(
        onTap: () => _openDetails(flight: flight, context: context),
        child: ListTile(
          title: AutoSizeText(
            "${flight.airportDeparture.nameAirport} - ${flight.airportArrival.nameAirport}",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.color!
                    .withOpacity(
                        flight.airportDeparture.estimateArrival.isBefore(now)
                            ? 0.5
                            : 1)),
          ),
          subtitle: Text(
            _getTime(
                startFlight: flight.airportDeparture.estimateArrival,
                endFlight: flight.airportArrival.estimateArrival),
            style: TextStyle(color: Theme.of(context).dividerColor),
          ),
          trailing: const Icon(
            Icons.chevron_right,
          ),
        ),
      ),
    );
  }

  String _getTime(
      {required DateTime startFlight, required DateTime endFlight}) {
    DateTime now = DateTime.now();
    if (startFlight.year == now.year &&
        startFlight.month == now.month &&
        startFlight.day == now.day) {
      return "${startFlight.hour}:${startFlight.minute} - ${endFlight.hour}:${endFlight.minute}";
    }
    if (startFlight.year == now.year) {
      return DateFormat("dd MMMM").format(startFlight);
    }
    return DateFormat('yyyy-MM-dd').format(startFlight);
  }

  void _openDetails({required Flight flight, required BuildContext context}) {
    context.read<DetailsFlightCubit>().init(flight: flight);
    context.router.push(const DetailsFlightRoute());
  }
}
