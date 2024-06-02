import 'package:flight_tracker/Data/my_db.dart';
import 'package:flight_tracker/core/observer/global_bloc_observer.dart';
import 'package:flight_tracker/domain/repository/database_repository.dart';
import 'package:flight_tracker/presentation/pages/details_flight/logic/details_flight_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/logic/home_page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/flight_tracker_api_local.dart';

/// Version:1.1.0
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // initialize observer for bloc
  Bloc.observer = MyGlobalObserver();
  final pref = await SharedPreferences.getInstance();
  bool? shoWelcomePage;

  if (pref.getBool("first_login") ?? true) {
    pref.setBool("first_login", false);
    shoWelcomePage = true;
  }
  final DatabaseRepository db = MyDB();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<HomePageCubit>(
        create: (_) => HomePageCubit(
              db: db,
              repoApi: FlightTrackerApiLocal(
                  pathJsonResource: "assets/json/data.json",
                  pathJsonResourceUpdate: 'assets/json/update.json'),
            )..init()),
    BlocProvider<DetailsFlightCubit>(create: (_) => DetailsFlightCubit(db))
  ], child: MyApp(showWelcomePage: shoWelcomePage ?? false)));
}
