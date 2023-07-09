import 'package:flutter/material.dart';

class CostumFooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width * 0.4, 0, size.width * 0.4, 0);
    path.cubicTo(size.width * 0.4, 0, size.width / 2, size.height * 0.1,
        size.width / 2, size.height * 0.1);
    path.cubicTo(size.width / 2, size.height * 0.1, size.width * 0.6, 0,
        size.width * 0.6, 0);
    path.cubicTo(size.width * 0.6, 0, size.width, 0, size.width, 0);
    path.cubicTo(
        size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, 0, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
