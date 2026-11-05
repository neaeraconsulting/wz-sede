import 'dart:ui';
import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);       // Top Center Point
    path.lineTo(size.width, size.height);  // Line to Bottom Right
    path.lineTo(0, size.height);           // Line to Bottom Left
    path.close();                          // Connect back to Top Center
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}