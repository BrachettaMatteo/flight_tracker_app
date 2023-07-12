import 'package:flight_tracker/Data/my_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/business_logic/bloc/flight_tracker_bloc.dart';
import 'data/flight_tracker_api_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
              repoApi: FlightTrackerApiLocal(
                  pathJsonResource: "assets/json/data.json",
                  pathJsonResourceUpdate: 'assets/json/update.json'),
            )..add(FlightTrackerEventInit()))
  ], child: MyApp(showWelcomePage: shoWelcomePage ?? false)));
}
