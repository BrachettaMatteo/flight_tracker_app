import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'theme/theme_custom.dart';

class MyApp extends StatelessWidget {
  final bool showWelcomePage;

  MyApp({super.key, required this.showWelcomePage});

  late final _appRouter = AppRouter(welcomePageShow: showWelcomePage);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'Flight Tracker',
      theme: ThemeCustom().lightTheme,
      darkTheme: ThemeCustom().dark,
    );
  }
}
