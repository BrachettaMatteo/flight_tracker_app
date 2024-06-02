import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

iconCustom([Color? color]) => Transform.rotate(
      angle: 0.8,
      child: Icon(
        FontAwesomeIcons.planeUp,
        color: color ?? Colors.white,
      ),
    );
