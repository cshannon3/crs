import 'dart:math';

import 'package:cshannon3/utils/mathish.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';



enum UpdateStatus {
  ColorChange,
  StrokeWidthChange,
  ShapeChange,
  ShapeAdded,
  LineAdded,
  ActiveShape,
  ShapeRemoved,
  LineRemoved,
  ClearAll,
  UpToDate,
}




List<Color> colorOptions = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.black,
  Colors.amber,
];
final List<Shape> templateShapes = [
  Shape(
    shapeType: ShapeType.circle,
    circle: Circle(radius: 20.0),
  ),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 50.0, sides: 3)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 40.0, sides: 4)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 30.0, sides: 5)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 25.0, sides: 6)),
];

class Polygon {
  final double sidelen;
  final int sides;

  Polygon({
    @required this.sidelen,
    @required this.sides,
  });
}

class Circle {
  final double radius;
  Circle({
    @required this.radius,
  });
}

class Shape {
  final ShapeType shapeType;
  Color color;
  Offset location;
  Circle circle;
  Polygon polygon;
  int paintLayerIndex; // Specific for paint application
  Shape({
    this.shapeType,
    this.color = Colors.blue,
    this.location = const Offset(0.0, 0.0),
    this.polygon,
    this.circle,
  });

  Shape.fromOld(Shape oldShape, {Circle newCircle, Polygon newPolygon})
      : shapeType = oldShape.shapeType,
        location = oldShape.location,
        color = oldShape.color,
        polygon = newPolygon,
        circle = newCircle;
}

enum ShapeType { polygon, circle }




class PolygonPainter extends CustomPainter {
  final Polygon polygon;
  final Color color;
  double maxheight = 0.0;

  PolygonPainter({@required this.polygon, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    double angles = 400 / (polygon.sides);
    double currentprogressangle = angles;

    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    Point lastPoint = Point(size.width / 2, size.height / 2);

    for (int i = 0; i < polygon.sides; i++) {
      currentprogressangle = (i) * angles;
      double xpoint = lastPoint.x + polygon.sidelen * Z(currentprogressangle);
      double ypoint = lastPoint.y + polygon.sidelen * K(currentprogressangle);
      if (ypoint > maxheight) maxheight = ypoint;
      path.lineTo(xpoint, ypoint);
      lastPoint = Point(xpoint, ypoint);
    }

    path.close();
    canvas.translate(
        -polygon.sidelen / 2, -(maxheight - (size.height / 2)) / 2);

    //canvas.rotate(radians) Need To rotate odd numbers
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShapeCentered extends StatelessWidget {
  final Shape shape;
  final Size size;

  ShapeCentered(
      {Key key, this.shape, this.size = const Size(100.0, 100.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape.shapeType) {
      case ShapeType.polygon:
        //shape.polygon.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: CustomPaint(
              painter:
                  PolygonPainter(polygon: shape.polygon, color: shape.color),
              child: SizedBox.fromSize(
                size: size,
              ) 
              ),
        );
        break;
      case ShapeType.circle:
        //shape.circle.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: SizedBox.fromSize(
            size: size,
            child: Center(
              child: Container(
                height: 2 * shape.circle.radius,
                width: 2 * shape.circle.radius,
                decoration:
                    BoxDecoration(color: shape.color, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      default:
      return Container();
        break;
    }
  }
}

class ShapeCenteredAboutNode extends StatelessWidget {
  final Shape shape;
  final Size size;

  const ShapeCenteredAboutNode(
      {Key key, this.shape, this.size = const Size(100.0, 100.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape.shapeType) {
      case ShapeType.polygon:
        //shape.polygon.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: CustomPaint(
                painter:
                    PolygonPainter(polygon: shape.polygon, color: shape.color),
                child: SizedBox.fromSize(
                  size: size,
                ) 
                ),
          ),
        );
        break;
      case ShapeType.circle:
        //shape.circle.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: SizedBox.fromSize(
              size: size,
              child: Center(
                child: Container(
                  height: 2 * shape.circle.radius,
                  width: 2 * shape.circle.radius,
                  decoration:
                      BoxDecoration(color: shape.color, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        );
      default:
        break;
    }
  }
}



