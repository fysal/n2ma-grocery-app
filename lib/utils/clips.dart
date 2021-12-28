
import 'package:flutter/material.dart';

class MyClip extends CustomClipper<Path> {
  @override
  getClip(Size size) {

    Path path = Path();
    path.lineTo(0.0, size.height - 200);
    path.quadraticBezierTo(
        0.0, size.height - 120, size.width / 6, size.height - 150);
    path.quadraticBezierTo(size.width / 6 + 80, size.height - 190,
        size.width - 205, size.height - 140);
    path.quadraticBezierTo(
        size.width - 30, size.height, size.width, size.height - 80);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class DetailClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height- 20);
    path.quadraticBezierTo(30.0, size.height, 70, size.height - 75 );
    path.quadraticBezierTo(100, size.height - 120 , 200, size.height - 40);
    path.quadraticBezierTo(250, size.height, 350, size.height - 80);
    path.quadraticBezierTo(400, size.height - 80, size.width - 50, 0);

    path.lineTo(size.width - 50, size.height);
    path.lineTo(size.width - 50, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}

class ClipBackground extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height - 300);
    path.quadraticBezierTo(0, size.height - 180, 30, size.height - 150);
    path.quadraticBezierTo(60, size.height - 120, 200, size.height - 120);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>  false;
}

class LineUpClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height );
    path.quadraticBezierTo(0.0, size.height - 10, 35, size.height - 40);
    path.quadraticBezierTo(80, size.height - 80, 180, size.height - 35);
    path.quadraticBezierTo(250, size.height , 350, size.height - 80);
    path.quadraticBezierTo(size.width - 40, size.height - 100, size.width, size.height - 150);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;

}