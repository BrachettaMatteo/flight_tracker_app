import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Data/model/args_detail_page.dart';
import '../../Data/model/flight.dart';
import '../../core/Utility_UI.dart';
import '../BusinessLogic/bloc/flight_tracker_bloc.dart';
import 'DetailsPage/Clipper/costum_footer_clipper.dart';
import 'DetailsPage/Clipper/costum_header_clipper.dart';

class DetailsPage extends StatefulWidget {
  static String route = "/detailsPage";
  final ArgsDetailsPage args;
  const DetailsPage({super.key, required this.args});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Flight flight;
  late FocusNode _noteFocusNode;
  late TextEditingController _controllerNote;
  String oldValue = "";
  @override
  void initState() {
    _controllerNote = TextEditingController();
    _noteFocusNode = FocusNode();
    flight = widget.args.flight;
    oldValue = flight.note;
    _controllerNote.text = oldValue;
    super.initState();
  }

  @override
  void dispose() {
    _controllerNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          dragStartBehavior: DragStartBehavior.down,
          slivers: <Widget>[
            _header(),
            _numeberFlight(),
            _infoGrid(),
          ]),
      floatingActionButton: _addNote(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _header() => SliverToBoxAdapter(
        child: ClipPath(
          clipper: CostumHeaderCLip(),
          child: Container(
            color: flight.aiportDeparture.delay > 5
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
                            nameAirport: flight.aiportDeparture.nameAriport,
                            iata: flight.aiportDeparture.iata,
                            alingText: CrossAxisAlignment.start)),
                  ),
                  UtilityUI.iconCostum,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: _getInfoAirport(
                            nameAirport: flight.airportArrival.nameAriport,
                            iata: flight.airportArrival.iata,
                            alingText: CrossAxisAlignment.end)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _getInfoAirport(
          {required String nameAirport,
          required String iata,
          required CrossAxisAlignment alingText}) =>
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

  SliverGrid _infoGrid() =>
      SliverGrid.count(crossAxisCount: 2, childAspectRatio: 2, children: [
        _infoElement(
            label: "Departure",
            value: DateFormat('HH:mm')
                .format(flight.aiportDeparture.estimateArrival)),
        _infoElement(
            label: "Gate / Terminal",
            value:
                "${flight.aiportDeparture.gate} - ${flight.aiportDeparture.terminal}"),
        _infoElement(
            label: "Arrival",
            value: DateFormat('HH:mm')
                .format(flight.airportArrival.estimateArrival)),
        _infoElement(
          label: "Gate / Terminal",
          value:
              "${flight.airportArrival.gate} - ${flight.airportArrival.terminal}",
        ),
      ]);
  Widget _infoElement({
    required String label,
    required String value,
  }) {
    return GridTile(
      child: Container(
        decoration: const BoxDecoration(
            border: Border.symmetric(
          vertical: BorderSide(width: 0.1),
          horizontal: BorderSide(width: 0.1),
        )),
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
      ),
    );
  }

  Widget _numeberFlight() => SliverToBoxAdapter(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(flight.id,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
        ]),
      );

  Widget _addNote() => ClipPath(
        clipper: CostumFooterClipper(),
        child: Container(
            height: 150,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade300,
                Theme.of(context).scaffoldBackgroundColor
              ],
            )),
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(top: 150 * 0.15),
                  child: const Text(
                    "note",
                    style: TextStyle(color: Colors.black),
                  )),
              TextFormField(
                maxLines: 3,
                focusNode: _noteFocusNode,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _saveNote(),
                style: const TextStyle(color: Colors.black),
                controller: _controllerNote,
                textAlign: TextAlign.center,
                cursorColor: Colors.blue,
                showCursor: true,
                decoration: const InputDecoration(border: InputBorder.none),
              )
            ])),
      );

  _saveNote() {
    _noteFocusNode.unfocus();
    if (_controllerNote.text.toUpperCase() != oldValue.toUpperCase()) {
      BlocProvider.of<FlightTrackerBloc>(context).add(
          FlightTrackerEventUpdateFlight(
              flight:
                  flight.copyWith(note: _controllerNote.text.toLowerCase())));

      oldValue = _controllerNote.text.toLowerCase();
    }
  }
}
