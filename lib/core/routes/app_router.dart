import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/presentation/pages/details_flight/details_flight_page.dart';
import 'package:flight_tracker/presentation/pages/home/pages/notification_page/notification_page.dart';
import 'package:flutter/material.dart';

import '../../presentation/pages/add_flight/add_flight_page.dart';
import '../../presentation/pages/home/pages/home_page.dart';
import '../../presentation/onboarding/welcome_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final bool welcomePageShow;
  AppRouter({required this.welcomePageShow});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: !welcomePageShow),
        AutoRoute(page: WelcomeRoute.page, initial: welcomePageShow),
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: DetailsFlightRoute.page),
        AutoRoute(page: AddFlightRoute.page)
      ];
}
