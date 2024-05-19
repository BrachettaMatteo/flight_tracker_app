import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/presentation/pages/home/cubit/home_page_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Utility_UI.dart';

/// Page represent Ui for add flight on homepage
/// Version:1.1.0

@RoutePage()
class AddFlightPage extends StatefulWidget {
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
        body: CustomScrollView(slivers: <Widget>[
          UtilityUI.appBarCustom(
              context: context, title1: "New", title2: "Flight"),
          UtilityUI.labelSection(
              label: "Number Flight", infoText: "insert iata of flight"),
          _divider(),
          _inputNumberFlight(),
          _divider(),
          UtilityUI.labelSection(
              label: "Date Flight",
              infoText: "enter the departure date \n of the flight"),
          _divider(),
          _inputDateFlight(),
          _divider(),
        ]),
        floatingActionButton: _btnAddFLight(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
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
              child: Text('${date.month}-${date.day}-${date.year} ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color)),
            ),
          )));

  _btnAddFLight() => SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formFieldKey.currentState!.validate()) {
            await context
                .read<HomePageCubit>()
                .addFlight(gufi: _editingController.text)
                .then((val) {
              if (val) context.router.popForced();
            });
          }
        },
        child: Text(
          "add flight".toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ));
}
