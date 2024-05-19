import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/routes/app_router.dart';
import 'theme/theme_custom.dart';

/// Version:1.1.0
class MyApp extends StatelessWidget {
  final bool showWelcomePage;

  MyApp({super.key, required this.showWelcomePage});

  late final _appRouter = AppRouter(welcomePageShow: showWelcomePage);
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'Flight Tracker',
      theme: ThemeCustom().lightTheme,
      darkTheme: ThemeCustom().dark,
    );
  }
}
