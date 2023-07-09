import 'package:flutter/material.dart';

class LabelSection extends StatelessWidget {
  final String label;
  const LabelSection({super.key, required this.label});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
          child: ListTile(
        subtitle: Text(label),
      ));
}
