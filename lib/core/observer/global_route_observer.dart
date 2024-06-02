import 'package:auto_route/auto_route.dart';
import 'package:flight_tracker/core/logger.dart';
import 'package:flutter/widgets.dart';

/// It used to communicate to the developer the behavior of the routes of the application.
///
/// Version 2.0.0
class GlobalRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    logger.d('New route pushed: ${route.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logger.d('Tab route visited: ${route.name} from ${previousRoute?.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    logger.d('Tab route re-visited: ${route.name} from ${previousRoute.name}');
  }
}
