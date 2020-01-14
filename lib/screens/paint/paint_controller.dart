
import 'package:cshannon3/screens/paint/paint_utils.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';

class PaintController extends ChangeNotifier {
  //int rows;
  //int columns;
  //double spotSize;
  Color _currentColor;
  double _currentStrokeWidth;
  List<Shape> _shapes;
  //List<ColoredLine> _coloredLines;
  List<CustomModel> _coloredLines;
  //List<PaintLayer> _paintLayers =[];
  //bool _gridOn;
  int _activeShapeIndex;
  // Way for listeners to know which changes affect them
  UpdateStatus updateStatus = UpdateStatus.UpToDate;

  double _piecesize, _verticalPadding, _horizontalPadding;
  Size _screenSize;
  int _rows, _columns;
  bool _gridOn;
  List<int> _gridLocations;

  /* TODO Grid System for location
   Not setup yet but this will make positions of shapes much more
   indexable by limiting possible locations to ~ 150 spots
   shapes will be added to the list by adding 1 to their line index
   //TODO update list when any shapes are removed or different way to index them
   TODO could make lines clickable by basically going through any block they
   paint through and, if empty add them, if filled by line compare points of current
   with the colored line in that position and set the one with the most in that position
   these will be set by multiplying by -1 then subtracting 1 so they are all negative
   Shapes will always override lines for location
  */

  PaintController({
    Color initialColor = Colors.blue,
    double initialStrokeWidth = 4.0,
  }) {
    _currentColor = initialColor;
    _currentStrokeWidth = initialStrokeWidth;
    _shapes = [];
    _coloredLines = [];
  }

  initGrid(Size screenSize, double pieceSize) {
    _piecesize = pieceSize;
    _screenSize = screenSize;
    _rows = (screenSize.height / _piecesize).floor();
    _columns = (screenSize.width / _piecesize).floor();
    _horizontalPadding = (screenSize.width % _piecesize) / 2;
    _verticalPadding = (screenSize.height % _piecesize) / 2;
    _gridOn = true;
    _gridLocations = List.filled(_columns * _rows, 0);
    notifyListeners();
  }

  updateMade({bool resetActiveShapeIndex = false}) {
    assert(updateStatus != UpdateStatus.UpToDate);
    if (resetActiveShapeIndex) _activeShapeIndex = null;
    updateStatus = UpdateStatus.UpToDate;
    notifyListeners();
  }

  updateMadeAdded(bool shape, int paintLayerIndex) {
    assert(updateStatus != UpdateStatus.UpToDate);
    updateStatus = UpdateStatus.UpToDate;
    notifyListeners();
  }

  int get activeShapeIndex => _activeShapeIndex;

  Color get currentColor => _currentColor;

  set currentColor(Color newColor) {
    if (_currentColor != newColor) {
      print("color change");
      _currentColor = newColor;
      updateStatus = UpdateStatus.ColorChange;
      notifyListeners();
    }
  }

  double get currentStrokeWidth => _currentStrokeWidth;

  set currentStrokeWidth(double newThickness) {
    if (_currentStrokeWidth != newThickness) {
      _currentStrokeWidth = newThickness;
      updateStatus = UpdateStatus.StrokeWidthChange;
      notifyListeners();
    }
  }

  /*
  SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
  */

  /* Anytime a shape is being modified or moved, it will become the active shape
  // and functions will be done in a stateful widget in the [ActivePaintArea] widget
  // Once modifications are complete, it will be 'saved'. Meaning if it was already added
  //  to that area before, it will be updated, otherwise it will be added to [PaintArea]
  */
  List<Shape> get shapes => _shapes;

  Shape getShape(int index) {
    //print(index);
    // assert(isIndexInList(index, _shapes.length));
    return _shapes[index];
  }

  // Undo button removes last shape
  removeLastShape() {
    if (_shapes.length > 0) {
      _shapes.removeLast();
      assert(_activeShapeIndex == null);
      // active shape must be completed before using this button

    }
  }

  /* To move a shape that is already on canvas,
      // Call comes from [ActivePaintArea] widget
      //
      // Will make sure shape exists, then set active shape index
      // When listeners are notified, [PaintArea] will respond by making
      // that shape invisible until new location is set
// This allows for a clean split between stateless and stateful apps
*/
  Shape activateShape(int shapeIndex) {
    // assert(isIndexInList(shapeIndex, _shapes.length));
    _activeShapeIndex = shapeIndex;
    updateStatus = UpdateStatus.ActiveShape;
    notifyListeners();
    return getActiveShape();
  }

  deactivateShape() {
    assert(_activeShapeIndex != null);
    updateStatus = UpdateStatus.ShapeChange;
  }

  Shape getActiveShape() {
    assert(_activeShapeIndex != null);
    return _shapes[_activeShapeIndex];
  }

  Shape getNewestShape() {
    return _shapes.last;
  }

  // TODO Add a Trash Can to remove shapes if they are at specific location
  /* When location is set, [Paint area] will check the shape of the active index
  // that it stored locally and update location
  */
  setShapeToLocation(Offset location) {
    assert(_activeShapeIndex != null);
    assert(_shapes[_activeShapeIndex].location != location);

    _shapes[_activeShapeIndex].location = location;
    updateStatus = UpdateStatus.ShapeChange;

    notifyListeners();
  }

  // When shape is dragged from template and placed down
  // It is added to [PaintArea] when it is placed down
  addNewShapeToCanvas(Shape newShape) {
    //newShape.location = location;
    _shapes.add(newShape);
    // set index of shape to grid location
    //print(getLocation(newShape.location));
    _gridLocations[getLocation(newShape.location)] = _shapes.length - 1;
    // _activeShapeIndex = _shapes.length -1;
    updateStatus = UpdateStatus.ShapeAdded;
    // When listeners are notified, [PaintArea] will check length
    // with shapes length to see if it needs to add last shape
    notifyListeners();
  }

  saveChangesToShape(Shape modifiedShape) {
    assert(_activeShapeIndex != null);
    _shapes[_activeShapeIndex] = modifiedShape;
    updateStatus = UpdateStatus.ShapeChange;

    notifyListeners();
  }

  /*
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS

   */
  // For the initial App, once a line is
  // TODO
 // List<ColoredLine> get coloredLines => _coloredLines;
List<CustomModel> get coloredLines => _coloredLines;

  CustomModel getColoredLine(int index) {
    assert(((index <= 0) && index < _coloredLines.length));
    //  isIndexInList(index, _coloredLines.length));
    return _coloredLines[index];
  }

  addNewColoredLine(var points) {
    CustomModel _cl = createColoredLine();
    _cl.vars["points"] = points;
    _coloredLines.add(_cl);
    //  _paintLayers.add(PaintLayer(_cl));
    updateStatus = UpdateStatus.LineAdded;
    notifyListeners();
  }

  //ColoredLine
  CustomModel getNewestLine() {
    // assert(_coloredLines.length > 0);
    return _coloredLines.last;
  }

  //ColoredLine 
  CustomModel createColoredLine() {
    CustomModel cm=CustomModel.fromLib2("coloredLine_sw_$_currentStrokeWidth");
    cm.vars["color"]= _currentColor;
    return cm;//ColoredLine(
        
        //points: [], strokeWidth: _currentStrokeWidth, color: _currentColor);
  }

  /*
  LOCATION/ Grid
  */

  //TODO PARAM THIS
  int getLocation(Offset location, {bool settingSpot = false}) {
    if (_gridOn) {
      int _piececolumn =
          ((location.dx - _horizontalPadding / 2) / (_piecesize + 3.0)).floor();
      int _piecerow =
          ((location.dy - _verticalPadding / 2) / (_piecesize + 3.0)).floor();
      int _pieceSpot = ((_piecerow) * (_columns)) + _piececolumn;
     // print(_pieceSpot);
      return _pieceSpot;
    }
    return null;
  }

  int isSpotFilled(Offset location) {
    return _gridLocations[getLocation(location)];
  }

  //List<PaintLayer> getPaintLayers(){return _paintLayers;}

  clearAll() {
    updateStatus = UpdateStatus.ClearAll;
    _activeShapeIndex = null;
    _shapes.clear();
    _coloredLines.clear();
    notifyListeners();
  }
}
