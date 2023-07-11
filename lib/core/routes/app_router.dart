import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../application/presentation/add_flight_page.dart';
import '../../application/presentation/details_page.dart';
import '../../application/presentation/home_page.dart';
import '../../application/presentation/welcome_page.dart';
import '../../data/model/flight.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final bool welcomePageShow;
  AppRouter({required this.welcomePageShow});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: !welcomePageShow),
        AutoRoute(page: WelcomeRoute.page, initial: welcomePageShow),
        AutoRoute(page: DetailsRoute.page),
        AutoRoute(page: AddFlightRoute.page)
      ];
}
