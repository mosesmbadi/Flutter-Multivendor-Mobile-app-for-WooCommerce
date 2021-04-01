import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ClipperDesign extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height / 3.6);
    var firstControlPoint = new Offset(size.width / 8, size.height / 3.3);
    var firstEndPoint = new Offset(size.width / 2.4, size.height / 3 - 60);
    var secondControlPoint =
    new Offset(size.width - (size.width / 5), size.height / 4 - 45);
    var secondEndPoint = new Offset(size.width, size.height / 3 - 70);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}
