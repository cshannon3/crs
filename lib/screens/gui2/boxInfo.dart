import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/screens/gui2/dragbox.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

@immutable
class BoxInfo{
  final String color;
  final double opacity;
  final String shade;
  final String borderColor;
  final double borderThickness;
 final  bool centered;
  final bool decorate;
  final String imgUrl;
  final bool hasPadding;
 final  bool initiated;
 final  double borderRadius;
 final  CHILDTYPE childType;
 final  String text; 
 final Widget child;
  BoxInfo({
    this.color="blue", 
    this.opacity, 
    this.shade="",
     this.borderColor="", 
     this.borderThickness=0.0, 
     this.centered=false,  
     this.decorate=false, 
     this.imgUrl="", 
     this.hasPadding=false, 
     this.initiated=false, 
     this.borderRadius=0.0, 
     this.childType=CHILDTYPE.BOX, 
     this.text="",
     this.child
     });

  prnt(){
    print(opacity);
    print(color);

  }
 
  BoxInfo.fromMap(dynamic map, {Widget child}):
      this.childType= checkPath(map, ["childType","value"])[1],
      this.color=checkPath(map, ["color","value"])[1],
      this.decorate= checkPath(map, ["decorate","value"])[1],
      this.borderThickness= checkPath(map, ["borderThickness","value"])[1],
      this.borderColor= checkPath(map, ["borderColor","value"])[1],
      this.borderRadius= checkPath(map, ["borderRadius","value"])[1],
      this.hasPadding= checkPath(map, ["hasPadding","value"])[1],
      this.centered=  checkPath(map, ["centered","value"])[1],
      this.imgUrl=  checkPath(map, ["photoFromUrl","value"])[1],
      this.opacity=  checkPath(map, ["opacity","value"])[1],
      this.shade=  checkPath(map, ["shade","value"])[1], 
      this.child=child,
      this.text=  "TODO",
      this.initiated=  true;




  Color boxColor()=>colorFromString(color+shade,opacity: opacity);
  Widget ifCentered(Widget w)=>centered?Center(child: w,):w;
  Widget toDefault(){
    return Center(child: Text(""),);
  }
 

  Widget toWidget({Widget child}){
  //  print("object");
    
        return !initiated? toDefault():
        Container(
            decoration: 
            BoxDecoration(
              color:boxColor(),//boxColor,
              border: decorate?Border.all(width:borderThickness, color: colorFromString(borderColor),):null,
              borderRadius: decorate?BorderRadius.circular(borderRadius):null
            ),
            child: Padding(
              padding: EdgeInsets.all((hasPadding?8.0:0.0)),
              child: 
                     ifCentered(
                     (childType==CHILDTYPE.BOX)? child:
                      (childType==CHILDTYPE.IMAGE)? (imgUrl!="")?imgUrl.contains("http")? Image.network(imgUrl, fit: BoxFit.fill,):Image.asset(imgUrl, fit: BoxFit.fill,):Container():
                      //(photoFromAsset!="")?Image.asset("assets/images/$photoFromAsset"):Container():
                       (childType==CHILDTYPE.BUTTON)? Container():
                        (childType==CHILDTYPE.TEXT)?toRichText({
                          "token":"#",
                          "text":text
                        }):
                          Container()
                     ))
          );

  }
}


  // BoxInfo.fromMap(dynamic map):
  //     this.childType=map["childType"]["value"],
  //     this.color=map["color"]["value"],
  //     this.decorate= map["decorate"]["value"],
  //     this.borderThickness= map["borderThickness"]["value"],
  //     this.borderColor= map["borderColor"]["value"],
  //     this.borderRadius= map["borderRadius"]["value"],
  //     this.hasPadding= map["hasPadding"]["value"],
  //     this.centered=  map["centered"]["value"],
  //     this.imgUrl=  map["photoFromUrl"]["value"],
  //     this.opacity=  map["opacity"]["value"],
  //     this.shade=  map["shade"]["value"], 
  //     this.text=  "TODO",
  //     this.initiated=  true;
    
  // dynamic toMap(dynamic map){
  //     map["childType"]["value"]=childType;
  //     map["decorate"]["value"]=decorate;
  //     map["borderThickness"]["value"]=borderThickness;
  //      map["borderColor"]["value"]=borderColor;
  //     map["borderRadius"]["value"]=borderRadius;
  //     map["hasPadding"]["value"]=hasPadding;
  //     map["centered"]["value"]=centered;
  //    map["photoFromUrl"]["value"]=imgUrl;
  //    return map;
  // }