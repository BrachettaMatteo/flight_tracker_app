import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/business_logic/bloc/flight_tracker_bloc.dart';
import '../../core/Utility_UI.dart';
import 'home_page.dart';

class AddFlightPage extends StatefulWidget {
  static const String route = "/addFlight";

  const AddFlightPage({super.key});

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  late TextEditingController _editingController;
  late GlobalKey<FormFieldState> _formFieldKey;
  late DateTime date;

  @override
  void initState() {
    _editingController = TextEditingController();
    _formFieldKey = GlobalKey<FormFieldState>();
    date = DateTime.now();
    super.initState();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FlightTrackerBloc, FlightTrackerState>(
        listenWhen: (previous, current) =>
            previous != current &&
            current is FlightTrackerStateFlightAddedStatus,
        listener: (context, state) {
          if (state is FlightTrackerStateFlightAddedStatus) {
            log("call flight ${state.status.toString()}");
            ScaffoldMessenger.of(context).showSnackBar(UtilityUI.snackBar(
                status: state.status, message: state.message));
            if (state.status == Status.done) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(HomePage.route, (route) => false);
            }
          }
        },
        child: CustomScrollView(slivers: <Widget>[
          UtilityUI.appBarCustom(
              context: context, title1: "New", title2: "Flight"),
          UtilityUI.labelSection(label: "Number Flight"),
          _divider(),
          _inputNumberFlight(),
          _divider(),
          UtilityUI.labelSection(label: "Date Flight"),
          _divider(),
          _inputDateFlight(),
          _divider(),
        ]),
      ),
      floatingActionButton: _btnAddFLight(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _inputNumberFlight() => SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: TextFormField(
            key: _formFieldKey,
            textCapitalization: TextCapitalization.characters,
            controller: _editingController,
            validator: (value) {
              if ((value ?? "").isEmpty) {
                return 'Please enter some text';
              }
              if ((value ?? "").length < 5) {
                return "insert IATA of flight";
              }
              return null;
            },
            decoration: const InputDecoration(
                hintText: "ES: AB777", border: InputBorder.none),
          ),
        ),
      );

  _divider() => const SliverToBoxAdapter(child: Divider());

  _inputDateFlight() => SliverToBoxAdapter(
      child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: CupertinoButton(
            // Display a CupertinoDatePicker in dateTime picker mode.
            onPressed: () => _showDialog(
              CupertinoDatePicker(
                initialDateTime: date,
                mode: CupertinoDatePickerMode.date,
                showDayOfWeek: true,
                // This is called when the user changes the dateTime.
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => date = newDateTime);
                },
              ),
            ),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                '${date.month}-${date.day}-${date.year} ',
                textAlign: TextAlign.start,
              ),
            ),
          )));

  _btnAddFLight() => SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formFieldKey.currentState!.validate()) {
            BlocProvider.of<FlightTrackerBloc>(context).add(
                FlightTrackerEventAddFlight(
                    idFlight: _editingController.text.trim().toUpperCase()));
          }
        },
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child: Text("add flight".toUpperCase()),
      ));
}
