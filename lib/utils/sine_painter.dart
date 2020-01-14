import 'package:cshannon3/utils/mathish.dart';
import 'package:flutter/material.dart';

/// A Custom Painter used to generate the trace line from the supplied dataset
class SinePainter extends CustomPainter {
  final double amplitude;
  final double phaseShift;
  final double frequency;
  final Color traceColor;
  double height;
  double startH;
  double decay;
  final double yRange;

  SinePainter( 
      {
      this.amplitude, 
      this.frequency,
      this.yRange,
      this.phaseShift=0.0,
      this.decay=0.0,
      this.height=1.0,
this.startH=0.0,
      this.traceColor = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    
   
    Path trace = Path();
    height??=1.0;
    if(height>1.0)height=1.0;
    else if(height<0.0)height=0.0;
    double h = height*size.height;
    startH??=0.0;
    if(startH>1.0)return;

    if(startH<0.0)startH=0.0;
    double h2 = startH*size.height;
    
   //print(size.height);
   trace.moveTo(size.width/2+amplitude*size.width*K(phaseShift+ h2*frequency*2)/2, (size.height -h2).toDouble());//
   for(int i=h2.floor(); i<h;i++){
     double y=(size.height -i).toDouble();
     double a = amplitude-(decay*i/size.height);
     if(a<0.0)a=0.0;
   // print(a);
     trace.lineTo(size.width/2+a
          *size.width*K(phaseShift+ i*frequency*2)/2, y);//
   }

    canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
  
  }

  @override
  bool shouldRepaint(SinePainter old) => true;
}