

import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';
Map<String, Color> catColors = {
  "Neuroscience":Colors.green,
  "Networks":Colors.blue,
  "AI": Colors.red,
  "Math": Colors.amber,
  "Music":Colors.deepPurple,
  "General":Colors.deepOrange,
  "Youtube":Colors.white,
  "Computers":Colors.cyan
};

final Color menuButton = Colors.white.withOpacity(0.1);


final BoxDecoration mainBackground = BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(195, 20, 50, 1.0),
                Color.fromRGBO(36, 11, 54, 1.0)
              ]),
        );
  
final BoxDecoration  quotesDec= BoxDecoration(
    color: RandomColor.next()
    .withOpacity(0.2),
      borderRadius: BorderRadius.circular(20.0),
    border: Border.all(
        color: Colors.black, width: 2.0));

BoxDecoration getBubbleDecoration(CustomModel node){

  if(node.vars["categories"].isEmpty) return BoxDecoration( shape: BoxShape.circle,);
  List<Color> colors = [];
  node.vars["categories"].forEach((c){
    if(catColors.containsKey(c))colors.add(catColors[c]);
  });
  if(colors.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
  if (colors.length==1)
      return new BoxDecoration( shape: BoxShape.circle,color: colors[0] );
  else 
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient:new LinearGradient(
      colors:colors,
    ),
    );
}