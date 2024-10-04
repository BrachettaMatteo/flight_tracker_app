import 'package:flight_tracker/core/ui_kit/widget/icon_custom.dart';
import 'package:flutter/material.dart';

SliverAppBar appBarCustom(
        {required BuildContext context,
        required String title1,
        required String title2,
        List<Widget>? actions}) =>
    SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 20,
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconCustom(Theme.of(context).iconTheme.color),
          const SizedBox(width: 10),
          Text(title1,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
          Text(title2,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface))
        ],
      ),
      actions: actions,
    );
