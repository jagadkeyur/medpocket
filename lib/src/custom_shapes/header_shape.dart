import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double radius=30.0;

    var path = Path();
    path.lineTo(0, height-10);
    path.lineTo(80, height-10);
    path.lineTo(100, height);
    path.lineTo((width-100), height);
    path.lineTo((width-80), height-10);
    // path.quadraticBezierTo((width-100), height, width-90, height-10);
    // path.quadraticBezierTo(width-90, height-10, width-80, height-20);
    path.lineTo(width, height-10);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}