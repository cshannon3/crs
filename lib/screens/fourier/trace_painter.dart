
import 'package:flutter/material.dart';


/// A Custom Painter used to generate the trace line from the supplied dataset
class TracePainter extends CustomPainter {
  final List dataSet;
  final Color traceColor;
  TracePainter(
      { this.dataSet,
      this.traceColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..strokeWidth = 1.0
      ..color =Colors.white;

    // only start plot if dataset has data
    int length = dataSet.length;
    if (length > 0) {
     
      Path trace = Path();
      trace.moveTo(0.0, dataSet[0].toDouble()+size.height/2);
      // generate trace path
      for (int p = 0; p < length; p++) {
        trace.lineTo(p.toDouble(), dataSet[p].toDouble()+size.height/2);
      }
      canvas.drawPath(trace, tracePaint);
        Offset yStart = Offset(0.0, size.height/2);// - (0.0 - yMin)) * yScale);
        Offset yEnd = Offset(size.width, size.height/2);// - (0.0 - yMin) _;//* yScale);
        canvas.drawLine(yStart, yEnd, axisPaint);

    }
  }

  @override
  bool shouldRepaint(TracePainter old) => true;
}


 // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
      // if (length > size.width) {
      //   dataSet.removeAt(0);
      //   length = dataSet.length;
      // }
      // Create Path and set Origin to first data point