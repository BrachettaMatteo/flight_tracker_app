import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../application/business_logic/bloc/flight_tracker_bloc.dart';

class UtilityUI {
  static get iconCustom => Transform.rotate(
        angle: 0.8,
        child: const Icon(FontAwesomeIcons.planeUp),
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
              UtilityUI.iconCustom,
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

  static SliverToBoxAdapter labelSection({required String label}) =>
      SliverToBoxAdapter(
          child: ListTile(
        subtitle: Text(label),
      ));
}
