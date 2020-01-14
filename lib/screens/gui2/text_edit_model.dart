

import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

class TextEditModel{
  FontWeight fw;
  FontStyle fs;
  String color ;
  double fontSize;
  String text;
  int newLines=0;

  TextEditModel({this.text="", this.color="black", this.fs=FontStyle.normal, this.fontSize=16.0, this.fw=FontWeight.normal});
 //TODO convert FontWeight and style to strings so they can be added more easily
  String toStr()=>text;
    
    

  dynamic toWidget({var children, var recognizers,var recognizer }){
    var style = TextStyle(
      color: colorFromString(color??"black"),
      fontSize: fontSize,
      fontWeight: fw,
      fontStyle: fs
    );
    bool isNotNull= (recognizers !=null);
    return (children!=null)?
    RichText(text: TextSpan(recognizer: isNotNull?recognizers[0]:null,
      text: text+"\n"*newLines, style: style,
    children: List.generate(children.length,((i){
      return children[i].toWidget(recognizer:isNotNull?recognizers[i+1]:null);
    }))),
  ):
    
    TextSpan(text: text+"\n"*newLines, style: style, recognizer: recognizer);
  }



}