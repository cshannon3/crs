

import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

              
RichText toRichText(var tokens){
    	return RichText(text: TextSpan(children: toTextSpan(tokens)));
}

List<TextSpan> toTextSpan(var tokens){
   
    var vars={
      
      "text": tokens.containsKey("text")? (tokens["text"] is List)?tokens["text"].join():tokens["text"]:"",
        "token": tokens.containsKey("token")?tokens["token"]:"@@",// "#"
        "isBold": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?FontWeight.bold : FontWeight.normal,
        "isHighlighted": tokens.containsKey("highlight")? ["true", "True", "t"].contains(tokens["highlighted"]) : false,
        "isItalic": tokens.containsKey("italic")&& ["true", "True", "t"].contains(tokens["italic"]) ?FontStyle.italic: FontStyle.normal,
        "fontSize":tryParse(tokens, ["fontSize", "size", "fs"])??16.0,
        "color":parseMap["color"](tokens)??Colors.black, 
        "fontWeight": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?FontWeight.bold : FontWeight.normal,
        "fontFamily":null,
        "fontType":FontStyle.normal
    };
     List<String> links=[];
     bool hasLink=false;

      List<TextSpan> textWidgets=[];
      List v = ["100","200","300","400","500","600","700","800","900" ];
      
        vars["text"].split(vars["token"]).forEach((textSeg)
        {
        if(textSeg=="bold") vars["fontWeight"]= FontWeight.bold;
        else if(textSeg=="/bold") vars["fontWeight"]=FontWeight.normal;
        else if(textSeg=="normal") vars["fontWeight"]=FontWeight.normal;
        else if(textSeg.contains("fw") && v.contains(textSeg.substring(2))) vars["fontWeight"]=FontWeight.values[v.indexOf(textSeg.substring(2))];
        else if(textSeg=="italic") vars["fontType"]= FontStyle.italic;
        else if(textSeg=="/italic") vars["fontType"]= FontStyle.normal;
        else if(textSeg.contains("color")) vars["color"] =colorFromString(textSeg.substring("color".length))??Colors.black;
        else if(textSeg.contains("/color")) vars["color"]=Colors.black;  // else if(textSeg.contains("highlight")) vars["isHighlighted"]= !isHighlighted;
        else if(textSeg.contains("size"))vars["fontSize"]=double.tryParse(textSeg.substring("size".length)) ?? 12.0;
        else if(textSeg.contains("/size"))vars["fontSize"]=16.0;
        else if(textSeg.contains("/link"))hasLink=false;
        else if(textSeg.contains("link")){hasLink=true;links.add(textSeg.substring("link".length));}
        
        
        else{
        // 
          final int o= links.length-1;
          if(hasLink){
            // print(textSeg);
            textWidgets.add(
            TextSpan(
              text: textSeg, 
              recognizer: TapGestureRecognizer()
              ..onTap= (){
              //  print("launch ${links[o]}");
                launch(links[o]);},
              style:TextStyle(
                fontSize: vars["fontSize"], 
                fontWeight: vars["fontWeight"], 
                fontStyle:vars["fontType"], 
                color: Colors.blue,
                decoration: TextDecoration.underline,//vars["color"]
                )));
          }else{
      
          textWidgets.add(
            TextSpan(
              text: textSeg, 
              style:GoogleFonts.merriweather(textStyle: TextStyle(
                fontSize: vars["fontSize"], 
                fontWeight: vars["fontWeight"], 
                fontStyle:vars["fontType"], 
                color: vars["color"]))));
             //   backgroundColor: isHighlighted ? Colors.yellowAccent:null)));
          }
        }

      });
      return textWidgets;
  }

  //final String templatetoken = "%%";
//String token = "@@";
// List<Widget>  toComplexText(String text, {Map templates, String templateTokens="%%", String token="#"}){
//   List<Widget> out = [];
//   List<String> textSegs= text.split(templateTokens);
//   String currentTemplate;
//   textSegs.forEach((textSeg){
//     if(templates.containsKey(textSeg)){
//       currentTemplate=textSeg;
//     }else if (currentTemplate!=null){
//      // if(currentTemplate.contains("image")){
//         out.add(templates[currentTemplate](textSeg));
//       // }else
//       // out.add(templates[currentTemplate](toRichText( {
//       //      "text": textSeg,
//       //       "token":"#"
//       // })));
//     }
//   });
//   return out;
// }
// List<Widget> toComplexTexts(var tokens){


// }
