import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final Color color;

  CurvePainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height,
        size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}