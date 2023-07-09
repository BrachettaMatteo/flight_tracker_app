import 'package:flutter/material.dart';

import 'Application/Presentation/add_flight_page.dart';
import 'Application/Presentation/details_page.dart';
import 'Application/Presentation/home_page.dart';
import 'Application/Presentation/welcome_page.dart';
import 'Data/model/args_detail_page.dart';
import 'Theme/theme_costum.dart';

class MyApp extends StatelessWidget {
  final bool showWelcomePage;
  const MyApp({super.key, required this.showWelcomePage});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Tracker',
      initialRoute: showWelcomePage ? WelcomePage.route : HomePage.route,
      theme: ThemeCostum().lightTheme,
      darkTheme: ThemeCostum().dark,
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
