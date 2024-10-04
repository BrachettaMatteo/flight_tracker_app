import 'dart:developer';

import 'package:flight_tracker/Data/my_db.dart';
import 'package:flight_tracker/core/notification_service.dart';
import 'package:flight_tracker/core/observer/global_bloc_observer.dart';
import 'package:flight_tracker/domain/repository/database_repository.dart';
import 'package:flight_tracker/presentation/pages/details_flight/logic/details_flight_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/logic/home_page_cubit.dart';
import 'package:flight_tracker/presentation/pages/home/pages/notification_page/logic/bloc/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/flight_tracker_api_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Version:1.1.0
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  log(tz.local.toString());
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialized in the `main` function
  NotificationService serviceNotification = NotificationService()
    ..initNotification();
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
    BlocProvider<DetailsFlightCubit>(
      create: (_) => DetailsFlightCubit(db),
    ),
    BlocProvider<NotificationBloc>(
        create: (_) =>
            NotificationBloc()..add(Initialized(service: serviceNotification)))
  ], child: MyApp(showWelcomePage: shoWelcomePage ?? false)));
}
