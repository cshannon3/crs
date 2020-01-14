
import 'package:cshannon3/screens/paint/main_painter.dart';
import 'package:cshannon3/screens/paint/paint_controller.dart';
import 'package:cshannon3/screens/paint/paint_layer.dart';
import 'package:cshannon3/screens/paint/paint_utils.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';

class PaintArea extends StatefulWidget {
  final PaintController paintController;

  PaintArea({Key key, @required this.paintController}) : super(key: key);

  @override
  _PaintAreaState createState() => _PaintAreaState();
}

class _PaintAreaState extends State<PaintArea> {
  PaintController paintController;
  // Paint layers
  List<Widget> paintLayers = [];
  ActivePaintArea activePaintArea;
  // use this to index paintLayers
  List<int> paintLayerOrder = [];
  String img;
  // shape or line layer is the index of the paint order list
  // and shape or coloredLine index is the actual value,
  // the shape index will be the negative version -1
  // coloredlines will be pos +1 and 0 will be open/placeholder

  // Grid

  // Shapes and Lines have param PaintLayerIndex so that they can be
  // stacked in layers above and below
  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    activePaintArea = ActivePaintArea(
      paintController: paintController,
    );

    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.LineAdded:
          // Add line to widgets

          paintLayers.add(
              PaintLayerWidget(coloredLine: paintController.getNewestLine()));
          // Add position of Widget in list to paintOrder list
          // the position of the widget and index will be at same place so the index
          // of the paint layer can be found by searching for the index in paint layer order
          paintLayerOrder.add(paintController.coloredLines.length);

          // Send Acknowledgement to Paint Controller
          // Not Sure if this is implemented properly/is necessary yet
          paintController.updateMadeAdded(false, paintLayers.length - 1);
          // rebuild with new widget added to list, will appear on top(below activePaintArea)
          setState(() {});
          break;
        case UpdateStatus.LineRemoved:
          break;

        case UpdateStatus.ShapeAdded:
          paintLayers.add(ShapeCentered(
            shape: paintController.getNewestShape(),
          ));
          final int len = -paintController.shapes.length;
          paintLayerOrder.add(len);
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;
        case UpdateStatus.ActiveShape:
          // Replace shape replace shape widget with placeholder
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder
              .indexOf(-(paintController.activeShapeIndex + 1))] = SizedBox();
          setState(() {});
          break;

        case UpdateStatus.ShapeChange:
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder.indexOf(
              -(paintController.activeShapeIndex + 1))] = ShapeCentered(
            shape: paintController.getActiveShape(),
          );
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;

        case UpdateStatus.ShapeRemoved:
          // TODO remove the Layer Widget from list and from Layer Order List
          break;

        case UpdateStatus.ClearAll:
          paintLayers.clear();
          paintLayerOrder.clear();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Making Grid ..
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: Stack(
        children: [

      
         Align(alignment:Alignment.center,child: 
        SizedBox.fromSize(
           size: screenSize,
           child: (img==null)?Container(): Opacity(
             opacity: 0.5,
             child: Image.network(img,fit: BoxFit.fill)),
         ),),
         
    
        ]
          ..addAll(paintLayers)
          ..add(activePaintArea)
          ..add(
  Align(alignment: Alignment.topLeft,
            child: Row(children: <Widget>[
              FlatButton(child: Text("Blank"),onPressed: (){
                setState(() {
                  img=null;
                });
              },),
              FlatButton(child: Text("Beach"),onPressed: (){
                print("press");
                img="https://i.ytimg.com/vi/B1T06UhcX0Q/maxresdefault.jpg";
                setState(() {
                  
                });
              },),
              FlatButton(child: Text("Mountians"),onPressed: (){
                img= "https://imagevars.gulfnews.com/2018/12/11/RDS_181211_Pakistan's_mountains_1_16a0853f269_large.jpg";
                  
                setState(() {
                  
                });
              },),
              FlatButton(child: Text("Dots"),onPressed: (){
                img="http://getdrawings.com/images/connect-the-dot-drawing-4.gif";
              //  "https://imagevars.gulfnews.com/2018/12/11/RDS_181211_Pakistan's_mountains_1_16a0853f269_large.jpg";
                  
                setState(() {
                  
                });
              },),
            ],),)
          )
      ),
    );
  }
}


class ActivePaintArea extends StatefulWidget {
  final PaintController paintController;

  const ActivePaintArea({Key key, this.paintController}) : super(key: key);

  @override
  _ActivePaintAreaState createState() => _ActivePaintAreaState();
}

// Have Shape Slider here initially
class _ActivePaintAreaState extends State<ActivePaintArea> {
  bool gridOn = false;
  bool shapesShown = false;
  PaintController paintController;

  CustomModel _activeColoredLine;
  Shape _selectedShape;
  int totalLen = 0;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    _activeColoredLine = paintController.createColoredLine();
    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.ColorChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.StrokeWidthChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });

          break;
        case UpdateStatus.ClearAll:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.UpToDate:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter:  MainPainter(model: _activeColoredLine),// PaintLayer2(_activeColoredLine),
      ),
    );
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTapDown: (details) {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            if (paintController.isSpotFilled(point) != 0) {
              setState(() {
                if (_selectedShape == null) {
                  //_selectedShape = paintController
                  _selectedShape = paintController
                      .activateShape(paintController.isSpotFilled(point));
                } else {
                  paintController.saveChangesToShape(_selectedShape);
                  _selectedShape = null;
                }
              });
              // Want a stopwatch to test if long press or pan.. could add long press
              // but don't want to inhibit pan if it is painting instead of selecting
              // an item
              print("Tap down");
            }
          },
          onPanStart: (DragStartDetails details) {
            // TODO if shape is selected move shape instead of create line
            if (_activeColoredLine.vars["points"] != null)
              _activeColoredLine.vars["points"] = [];
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox box = context.findRenderObject();
              Offset point = box.globalToLocal(details.globalPosition);

              _activeColoredLine.calls["addPt"](point);
            });
          },
          onPanEnd: (DragEndDetails details) {
            // print(totalLen);
            // W/ PaintLayer2 Og settings 1349 ponits before red
            // W/ all being rendered every frame 857 points
            // W/ PaintLayer2 should repaint = true ~ 1200 points
            //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and isComplex: true,
            //        willChange: true, ~ 1300
            //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and  no extra settings ~ 1300
            _activeColoredLine.vars["points"].add(null);
            var _pts = _activeColoredLine.vars["points"];
            paintController.addNewColoredLine(_pts);
          },
          child: sketchArea,
        ),
       
      ],
    );
  }
}

