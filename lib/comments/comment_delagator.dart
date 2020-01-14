import 'dart:math';

import 'package:cshannon3/screens/gui2/guibox.dart';
import 'package:flutter/material.dart';

class CommentDelagator extends ChangeNotifier {
  //Set context for each setstate in order to  have access to widget tree info
  BuildContext context;
  Size size;
 final Function(/*BoxInfo*/dynamic map) setFocus;

  GuiBox rootBox;
  Point currentTapLocation;
  bool focus=false;

  CommentDelagator(this.setFocus);

  double getH() => size.height;
  double getW() => size.width;

  
  updateTapLocation(Offset screenpos) =>
      currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());

  delegateTap(Offset screenpos) {
    currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());
    //currentBox = (i<CommentBoxes.length)?i:null;
  }

  onTapUp(TapUpDetails details) {
    print("TAP UP");
    //updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.resetFocuses();
    focus= rootBox.handleClick(currentTapLocation, setFocus);
    notifyListeners();
  }

  onPanStart(DragStartDetails details) {
    print("PAN START");
    focus=false;
    //updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.handleDrag(currentTapLocation);
  }

  onPanUpdate(DragUpdateDetails details) {
    // updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.updateDrag(currentTapLocation);
    notifyListeners();
  }

  onPanEnd(DragEndDetails details) {
    focus=true;
    rootBox.endDrag();
    notifyListeners();
  }
}
