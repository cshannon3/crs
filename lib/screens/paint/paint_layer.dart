

import 'package:cshannon3/screens/paint/main_painter.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';

class PaintLayerWidget extends StatelessWidget {
  //final ColoredLine coloredLine;
  //final ColoredLine coloredLine;
  final CustomModel coloredLine;
  const PaintLayerWidget({Key key, this.coloredLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter: MainPainter(model: coloredLine),//PaintLayer2(coloredLine),
        isComplex: true,
        willChange: false,
      ),
    );
  }
}

