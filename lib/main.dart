import 'package:flight_tracker/Data/my_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Application/BusinessLogic/bloc/flight_tracker_bloc.dart';
import 'Data/flight_tracker_api_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  bool? shoWelcomePage;
  if (pref.getBool("first_login") ?? true) {
    pref.setBool("first_login", false);
    shoWelcomePage = true;
  }

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => FlightTrackerBloc(
              db: MyDB(),
              repoApi: FligthTrackerApiLocal(
                  pathJsonResource: "asset/json/data.json",
                  pathJsonResourceUpdate: 'asset/json/update.json'),
            )..add(FlightTrackerEventInit()))
  ], child: MyApp(showWelcomePage: shoWelcomePage ?? false)));
}
