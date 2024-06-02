import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/routes/app_router.dart';
import 'theme/theme_custom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flight Tracker',
      theme: ThemeCustom().lightTheme,
      darkTheme: ThemeCustom().dark,
    );
  }
}
