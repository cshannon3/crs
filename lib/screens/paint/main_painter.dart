
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';

class MainPainter extends CustomPainter {
  //final ColoredLine coloredLine;
  CustomModel model;
  List<CustomModel> models;
  MainPainter({this.model, this.models});

  @override
  bool shouldRepaint(MainPainter oldDelegate) {
    return true;
  }

  void paint(Canvas canvas, Size size) {
    if(model!=null && model.calls.containsKey("paint")){
      model.calls["paint"](canvas, size);
    }
    if(models!=null && models!=[]){
      models.forEach((listModel){
        if(listModel.calls.containsKey("paint")){
          listModel.calls["paint"](canvas, size);
        }
      });
    }
  }
}
