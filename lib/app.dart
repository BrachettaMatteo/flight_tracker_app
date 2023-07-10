import 'package:flutter/material.dart';

import 'application/presentation/add_flight_page.dart';
import 'application/presentation/details_page.dart';
import 'application/presentation/home_page.dart';
import 'application/presentation/welcome_page.dart';
import 'data/model/args_detail_page.dart';
import 'theme/theme_custom.dart';

class MyApp extends StatelessWidget {
  final bool showWelcomePage;
  const MyApp({super.key, required this.showWelcomePage});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Tracker',
      initialRoute: showWelcomePage ? WelcomePage.route : HomePage.route,
      theme: ThemeCustom().lightTheme,
      darkTheme: ThemeCustom().dark,
      onGenerateRoute: (settings) {
        final routes = {
          HomePage.route: (_) => const HomePage(),
          AddFlightPage.route: (_) => const AddFlightPage(),
          DetailsPage.route: (_) =>
              DetailsPage(args: settings.arguments as ArgsDetailsPage),
          WelcomePage.route: (_) => const WelcomePage()
        };
        return MaterialPageRoute(builder: routes[settings.name]!);
      },
    );
  }
}
