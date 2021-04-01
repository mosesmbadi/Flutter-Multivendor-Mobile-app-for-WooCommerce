import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  CurvePainter({
    @required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.17, size.height * 0.4,
        size.width * 0.5, size.height * 0.4);

    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.4, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter2 extends CustomPainter {
  CurvePainter2({
    @required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 1);
    path.quadraticBezierTo(size.width * 0.17, size.height * 0.9,
        size.width * 0.5, size.height * 0.9);

    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.9, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
