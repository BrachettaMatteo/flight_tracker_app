import 'package:flight_tracker/core/ui_kit/widget/app_bar_custom.dart';
import 'package:flight_tracker/core/ui_kit/widget/icon_custom.dart';
import 'package:flight_tracker/core/ui_kit/widget/label_section_custom.dart';
import 'package:flight_tracker/core/ui_kit/widget/snack_bar_custom.dart';
import 'package:flutter/material.dart';

class UIKit {
  static icon([Color? color]) => iconCustom(color);

  static SliverAppBar appBar(
          {required BuildContext context,
          required String title1,
          required String title2}) =>
      appBarCustom(context: context, title1: title1, title2: title2);

  static SnackBar snackBar(
          {required bool isCorrect, required String message}) =>
      snackBarCustom(isCorrect: isCorrect, message: message);

  static SliverToBoxAdapter labelSection(
          {required label, required String? infoText}) =>
      labelSectionCustom(label: label, infoText: infoText);
}
