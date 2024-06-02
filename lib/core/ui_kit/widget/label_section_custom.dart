import 'package:flutter/material.dart';

SliverToBoxAdapter labelSectionCustom(
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
