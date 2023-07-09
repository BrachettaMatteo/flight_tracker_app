import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// class Rapresent the theme of app
class ThemeCostum {
  ThemeData get lightTheme => ThemeData(
      primaryColor: Colors.blue.shade800,
      brightness: Brightness.light,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: globalFont,
      appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0),
      useMaterial3: true,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.white60));

  String get globalFont => "RobotoMono";

  ThemeData get dark => ThemeData(
      primaryColor: Colors.blue.shade800,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800,
      fontFamily: globalFont,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      useMaterial3: true,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.grey.shade600));
}
