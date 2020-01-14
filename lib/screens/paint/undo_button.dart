
import 'package:cshannon3/screens/paint/paint_controller.dart';
import 'package:flutter/material.dart';

class UndoButtonBar extends StatelessWidget {
  final PaintController paintController;

  const UndoButtonBar({Key key, @required this.paintController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
  
      Padding(padding:EdgeInsets.only(right: 5.0, bottom: 10.0),
      child:Container(
        width:50, height:150, child:
        FloatingActionButton(
          tooltip: 'clear Screen',
          backgroundColor: Colors.grey,
          child: Icon(Icons.undo),
          onPressed: () {
            paintController.clearAll();
          },
        ))
      
  
    );
  }
}