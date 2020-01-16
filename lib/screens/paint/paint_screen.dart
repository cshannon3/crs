import 'package:cshannon3/screens/paint/color_list.dart';
import 'package:cshannon3/screens/paint/paint_areas.dart';
import 'package:cshannon3/screens/paint/paint_controller.dart';
import 'package:cshannon3/screens/paint/stroke_width_slider.dart';
import 'package:cshannon3/screens/paint/undo_button.dart';
import 'package:flutter/material.dart';

class PaintDemo extends StatelessWidget {
  PaintDemo({Key key}) : super(key: key);

  PaintController paintController;
  ColorList colorList;
  StrokeWidthSlider strokeWidthSlider;
  UndoButtonBar undoButtonBar;
  PaintArea paintArea;
  @override
  @override
  Widget build(BuildContext context) {
    paintController = PaintController();
    colorList = ColorList(
      paintController: paintController,
    );
    strokeWidthSlider = StrokeWidthSlider(
      paintController: paintController,
    );
    undoButtonBar = UndoButtonBar(paintController: paintController);

    paintArea = PaintArea(
      paintController: paintController,
    );

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:50.0),
          child: paintArea,
        ),
         Align(alignment: Alignment.bottomCenter,
        child:strokeWidthSlider),
          Align(
          alignment: Alignment.bottomRight,
        child:undoButtonBar),
        Align(
          alignment: Alignment.topCenter,
          child: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
              child: colorList),
        ),
      ],
    );
  }
}
