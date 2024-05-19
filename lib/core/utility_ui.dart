import 'package:flight_tracker/presentation/pages/home/cubit/home_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UtilityUI {
  static iconCustom([Color? color]) => Transform.rotate(
        angle: 0.8,
        child: Icon(
          FontAwesomeIcons.planeUp,
          color: color ?? Colors.white,
        ),
      );

  static SliverAppBar appBarCustom(
          {required BuildContext context,
          required String title1,
          required String title2}) =>
      SliverAppBar(
          pinned: true,
          floating: true,
          elevation: 20,
          centerTitle: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UtilityUI.iconCustom(Theme.of(context).iconTheme.color),
              const SizedBox(width: 10),
              Text(title1,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6))),
              Text(title2,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface))
            ],
          ));

  static SnackBar snackBar({required Status status, required String message}) {
    return SnackBar(
        content: Text(message),
        backgroundColor: status == Status.done
            ? Colors.green.shade400
            : Colors.redAccent.shade400);
  }

  static SliverToBoxAdapter labelSection(
          {required label, required String? infoText}) =>
      SliverToBoxAdapter(
          child: ListTile(
              title: infoText != null
                  ? Row(children: [
                      Text(label),
                      const SizedBox(width: 10),
                      Tooltip(
                        preferBelow: false,
                        triggerMode: TooltipTriggerMode.tap,
                        message: infoText,
                        textAlign: TextAlign.center,
                        enableFeedback: true,
                        child: const Icon(Icons.info_outline),
                      ),
                    ])
                  : Text(label)));
}
