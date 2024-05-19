import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// class Represent the theme of app
/// Version:1.1.0
class ThemeCustom {
  final Color _primaryColor = Colors.blue.shade800;
  ThemeData get lightTheme => ThemeData(
      primaryColor: _primaryColor,
      dividerTheme: const DividerThemeData(color: Colors.black38),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(_primaryColor),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              iconColor: const WidgetStatePropertyAll(Colors.white),
              elevation: const WidgetStatePropertyAll(20))),
      brightness: Brightness.light,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: globalFont,
      appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0),
      useMaterial3: true,
      canvasColor: _primaryColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: _primaryColor));

  String get globalFont => "RobotoMono";

  ThemeData get dark => ThemeData(
        primaryColor: Colors.blue.shade800,
        dividerTheme: const DividerThemeData(color: Colors.white38),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade800,
        fontFamily: globalFont,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
        useMaterial3: true,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: _primaryColor),
        canvasColor: _primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(_primaryColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                iconColor: const WidgetStatePropertyAll(Colors.white),
                elevation: const WidgetStatePropertyAll(20))),
      );
}
