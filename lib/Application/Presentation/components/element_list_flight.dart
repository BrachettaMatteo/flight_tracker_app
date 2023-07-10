import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../application/business_logic/bloc/flight_tracker_bloc.dart';
import '../../../data/model/args_detail_page.dart';
import '../../../data/model/flight.dart';
import '../details_page.dart';

class ElementListFlight extends StatefulWidget {
  final List<Flight> listFlight;
  final double? opacity;
  const ElementListFlight({super.key, required this.listFlight, this.opacity});

  @override
  State<ElementListFlight> createState() => _ElementListFlightState();
}

class _ElementListFlightState extends State<ElementListFlight> {
  @override
  Widget build(BuildContext context) {
    return widget.listFlight.isNotEmpty
        ? SliverList.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return index == 0 || index == widget.listFlight.length + 1
                  ? const SizedBox.shrink()
                  : elementFlight(flight: widget.listFlight[index - 1]);
            },
            itemCount: widget.listFlight.length + 2,
          )
        : SliverToBoxAdapter(child: Container());
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

  void _openDetails({required Flight flight}) {
    //update flight
    BlocProvider.of<FlightTrackerBloc>(context)
        .add(FlightTrackerEventUpdateFlight(flight: flight));
    final state = BlocProvider.of<FlightTrackerBloc>(context).state;
    if (state is FlightTrackerStateFlightUpdate) {
      Navigator.of(context).pushNamed(DetailsPage.route,
          arguments: ArgsDetailsPage(state.flight));
    }
  }

  Widget elementFlight({required Flight flight}) => Dismissible(
        key: Key(flight.id),
        background: Container(color: Colors.red),
        onDismissed: (direction) => BlocProvider.of<FlightTrackerBloc>(context)
            .add(FlightTrackerEventRemoveFlight(flight: flight)),
        child: InkWell(
          onTap: () => _openDetails(flight: flight),
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
                      .withOpacity(widget.opacity ?? 1)),
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
