
import 'package:flutter/material.dart';

class CircleIndentClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    double ax,bx,cx,ay,by,cy;
    
    // ax=0.18;
    // bx=0.24;
    // cx=0.3;
    // ay=0.0;
    // by=0.14;
    // cy=0.28;
    ax=0.2;bx=0.26;cx=0.32;
    ay=0.0;by=0.11;cy=0.22;

    path.lineTo(size.width*0.1, 0);
    //path.lineTo(size.width/2, size.height/5);
    path.quadraticBezierTo(size.width*ax, ay,
        size.width*bx, size.height*by);
    path.quadraticBezierTo(size.width*cx, size.height*cy,
        size.width/2, size.height*cy);
    path.quadraticBezierTo(size.width*(1-cx), size.height*cy,
        size.width*(1-bx), size.height*by);//0.86
    path.quadraticBezierTo(size.width*(1-ax),cy,
        size.width*0.9, 0.0);
    //path.lineTo(size.width*0.85,0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
 
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

