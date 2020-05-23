
import 'package:cshannon3/utils/mathish.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

String token = "_";
class CustomModel {
  // final Widget child;
  
  Map<String, dynamic> vars;
  var calls;
  CustomModel({
    this.vars,
    this.calls
  });
  
  CustomModel.fromLib(var data){
    if (data is String){
      var info = data.contains("_")? data.split("_"): [data];
      vars = mymodelsLib[info[0]]["vars"](info.sublist(1));
      calls = mymodelsLib[info[0]]["functions"](this);
    }
    if (data is Map){
      vars = mymodelsLib[data["name"]]["vars"](data["vars"]);
      calls = mymodelsLib[data["name"]]["functions"](this);
    }
  }
  CustomModel.fromLib2(var data){
    if (data is String){
      var info = data.contains("_")? data.split("_"): [data];
      vars = otherModelsLib[info[0]]["vars"](info.sublist(1));
      calls = otherModelsLib[info[0]]["functions"](this);
    }
    if (data is Map){
      vars = otherModelsLib[data["name"]]["vars"](data["vars"]);
      calls = otherModelsLib[data["name"]]["functions"](this);
    }
  }
  

  CustomModel.fromMap(var data){
      vars = data["vars"]({});
      calls = data["functions"](this);
  }


  List<CustomModel> listFromLib(var dataList) 
    => List<CustomModel>.generate(dataList.length, (i)=> CustomModel.fromLib(dataList[i]));
    
}

Map<String, dynamic> mymodelsLib = {
    "blog": {
    "vars": (
      var tokens,) =>
        {
          "name": tokens.containsKey("author")?tokens["author"]:"",
          "author":  tokens.containsKey("author")?tokens["author"]:"",
          "url":  tokens.containsKey("url")?tokens["url"]:"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:""
        },
    "functions": (CustomModel self) => {
        }
  },
  "book": {
    "vars": (
      var tokens,
    ) {
        return {
          "id": 0,
         "loc":null,
          "name": tokens.containsKey("title")?tokens["title"]:"",
            "url": tokens.containsKey("url")?tokens["url"]:"",
          "author":tokens.containsKey("author")?tokens["author"]:"",
          "categories": tokens.containsKey("categories")?new List<String>.from(tokens["categories"]):[],
          "year": 1999,//tokens.containsKey("year")?int.tryParse(tokens["year"]):"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:"",
          "recommendedBy": tokens.containsKey("recommendedBy")?tokens["recommendedBy"]:"",
           "description":tokens.containsKey("description")? (tokens["description"] is List)?tokens["description"].join():tokens["description"]:"",
        };
    },
    "functions": (CustomModel self) => {
          
        }
  },
  "quote": {
    "vars": (
      var tokens,
    ) =>
        {
          "id": 0,
           "text": tokens.containsKey("text")?new List<String>.from(tokens["text"]).join():"",//(tokens["text"] is List)?tokens['text']:
            "author": tokens.containsKey("author")?tokens["author"]:"", 
            "categories": tokens.containsKey("categories")?new List<String>.from(tokens['categories']):[],
             "source":""//tokens.containsKey("source")?tokens["source"]:"",
             },
    "functions": (CustomModel self) => {
          "toStr":(){
            self.vars["text"]=self.vars["text"].replaceAll("@@", "#")..replaceAll(":", "");
            var text = "\""+ self.vars["text"]+ "\""+ "#bold##italic##colorblue#\n\n -${self.vars["author"]}";
            return '''customText(text:$text)''';//padding(all:8)~container(all:8_color:green200)~center()~
          },
          "toLabel":(){
            self.vars["text"]=self.vars["text"].replaceAll("@@", "#")..replaceAll(":", "");
            return ExpansionTile(title: Text(self.vars["author"]),children: <Widget>[Text(self.vars["text"])],);
          }

        },

  },
  "category":{
     "vars": (
      var tokens,
    ) {
        return {
          "id": 0,
          "name": tokens.containsKey("name")?tokens["name"]:"",
          "color": parseMap["color"](tokens),
          "loc":null,
          "size":1,//tokens.containsKey("size")?int.tryParse(tokens["size"]):2,
          "nodes":[]
        };
    },
    "functions": (CustomModel self) => {
         // "toModel":()=>CategoryBubble(name: self.vars["name"], id:self.vars["id"])
        }
  },
  "site":{
     "vars": (
      var tokens,
    ) {
        return {
          "id": 0,
          "name": tokens.containsKey("name")?tokens["name"]:"",
          "fontColor": parseMap["color"](tokens),
          "loc":null,
          "categories":tokens.containsKey("categories")?new List<String>.from(tokens["categories"]):[],
          "url": tokens.containsKey("url")?tokens["url"]:"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:"",
          "description":tokens.containsKey("description")? (tokens["description"] is List)?tokens["description"].join():tokens["description"]:"",
        };
    },
    "functions": (CustomModel self) => {
          
        }
  },
   "youtube":{
     "vars": (
      var tokens,
    ) {
        return {
          "id": 0,
          "name": tokens.containsKey("name")?tokens["name"]:"",
          "fontColor": parseMap["color"](tokens),
          "loc":null,
          "categories":tokens.containsKey("categories")?new List<String>.from(tokens["categories"]):[],
          "url": tokens.containsKey("url")?tokens["url"]:"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:"",
          "description":tokens.containsKey("description")? (tokens["description"] is List)?tokens["description"].join():tokens["description"]:"",
        };
    },
    "functions": (CustomModel self) => {
          
        }
  },
  "project":{
     "vars": (
      var tokens,
    ) {
        return {
          "id": 0,
          "name": ifIs(tokens,"name"),
          "githubUrl": ifIs(tokens,"githubUrl"),
          "demoPath": ifIs(tokens, "demoPath"),
          "loc":null,
          "categories": tokens.containsKey("categories")?new List<String>.from(tokens["categories"]):[],
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:"",
          "description":ifIs(tokens,"description"),
          "expanded":ifIs(tokens,"description"),
        };
    },
    "functions": (CustomModel self) => {
        }
  },
};

Map<String, dynamic> otherModelsLib = { 

  "point": {
    "vars": (
      var tokens,
    ) =>
        {"x": parseMap["x"](tokens) ?? 0.0, "y": parseMap["y"](tokens) ?? 0.0},
    "functions": (CustomModel self) => {
          "toOffset": ({double scale = 1.0}) =>
              Offset(scale * self.vars["x"], scale * self.vars["y"])
              // "#widget#offset_dx_#m_*_^scale_@x_#\m_dy_#m_*_^scale_@y_#\m"
        },
  },
  
  "line2d": {
    "vars": (var tokens) => {
          "node": tryParse(tokens, ["node"]) ?? 0,
          "color": parseMap["color"](tokens),
          "conNode": tryParse(tokens, ["conNode"]) ?? -1,
          "length": parseMap["length"](tokens) ?? 0,
          "freqMult": tryParse(tokens, ["freqMult", "fm"]) ?? 0,
          "nodeLoc": tokens.contains("nodeLoc")
              ? Offset(double.parse(tokens[tokens.indexOf("nodeLoc") + 1]),
                  double.parse(tokens[tokens.indexOf("nodeLoc") + 2]))
              : Offset(0.0, 0.0),
          "endNodeLoc": null,
          "absProg": false,
          "root": tokens.contains("root") ? true : false,
          "progress": 0.0
        },
    "functions": (CustomModel self) => {
          "setPosition": ({Offset startlocation, double stepPerUpdate}) {
            if (stepPerUpdate != null)
              self.vars["progress"] += stepPerUpdate * self.vars["freqMult"];
            if (startlocation != null) self.vars["nodeLoc"] = startlocation;
            self.vars["endNodeLoc"] = Offset(
                self.vars["nodeLoc"].dx +
                    Z(self.vars["progress"]) * self.vars["length"],
                self.vars["nodeLoc"].dy +
                    K(self.vars["progress"]) * self.vars["length"]);
            return [self.vars["nodeLoc"], self.vars["endNodeLoc"]];
          },
          "compare": (CustomModel node2) =>
              self.vars["node"].compareTo(node2.vars["node"]),
   }
  },
 
  "wave": {
    "vars": (var tokens) => {
          "weight": tryParse(tokens, ["weight", "w"]) ?? 1.0,
          "freq": tryParse(tokens, ["freq", "progressPerFrame", "ppf"]) ?? 1.0,
          "progress": tryParse(tokens, ["progress", "p"]) ?? 0.0,
          "trace": [],
          "color": parseMap["color"](tokens),
          "waveVals": [],
          "radius": 100.0
        },
    "functions": (CustomModel self) => {
          "z": () => self.vars["weight"] *Z(self.vars["progress"]),
          "k": () => self.vars["weight"] *K(self.vars["progress"]),
          "progToRad": () => rad(self.vars["progress"]),
          "updateWave": (double stepPerUpdate) {
            self.vars["trace"].add(self.vars["weight"]*K(self.vars["progress"]));
            self.vars["progress"] +=  stepPerUpdate * self.vars["freq"];
            //self.vars["PPF"] * newProgress;
            return CustomModel.fromLib2(
                "waveVal_k_${self.vars["weight"]*K(self.vars["progress"])}_z_${self.vars["weight"]*Z(self.vars["progress"])}_rot_${rad(self.vars["progress"])}");
          },
          "toWidget":(var tokens){
           return Center(
                        child: Transform(
                          transform: Matrix4.translationValues(
                              self.vars["radius"] * 
                              self.calls["z"](),
                              -self.vars["radius"] * self.calls["k"](),
                              0.0)
                            ..rotateZ(
                              -self.calls["progToRad"](),
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              color: self.vars["color"],
                            ),
                          ),
                        ),
                      );
          }
      
        }
  },
  "waveVal": {
    "vars": (var tokens) => {
          "k": tryParse(tokens, ["k"]) ?? 0.0,
          "z": tryParse(tokens, ["z"]) ?? 0.0,
          "rot": tryParse(tokens, ["rot"])??0.0,
        },
    "functions": (CustomModel self) => {
          "zero": () {
            self.vars["k"] = 0.0;
            self.vars["z"] = 0.0;
            self.vars["rot"] = 0.0;
          },
          "add": (CustomModel wv) {
            self.vars["k"] += wv.vars["k"];
            self.vars["z"] += wv.vars["z"];
            self.vars["rot"] += wv.vars["rot"];
          }
        },
  },
  "coloredLine": {
    "vars": (var tokens) => {
          "points": [],//List<Offset>.from([]),
          "color": parseMap["color"](tokens),
          "strokeWidth": tryParse(tokens, ["sw", "strokeWidth"]) ?? 4.0,
          "active": false,
          "shouldRepaint": false,
          "paintLayerIndex": null
        },
    "functions": (CustomModel self) => {
          "fromMap": (Map<String, dynamic> map) {
            self.vars["points"] = new List<Offset>.from(map["points"]);
            self.vars["color"] = map.containsKey("color")
                ? colorFromString(map["color"])
                : Colors.black;
            self.vars["strokeWidth"] = map['strokeWidth'];
            self.vars["active"] =
                map.containsKey("active") ? map["active"] : false;
          },
          "addPt": (Offset pt) {
            self.vars["points"].add(pt);
            self.vars["shouldRepaint"] = true;
          },
          "repaint": () {
            if (self.vars["shouldRepaint"]) {
              self.vars["shouldRepaint"] = false;
              return true;
            }
            return false;
          },
          "getPoints": () =>self.vars["points"] ,
          "paint": (Canvas canvas, Size size){
              Paint paint = Paint()
              ..color = self.vars["color"]
              ..strokeCap = StrokeCap.round
              ..strokeWidth = self.vars["strokeWidth"];
              for (int i = 0; i < self.calls["getPoints"]().length - 1; i++) {
                if (self.calls["getPoints"]()[i] != null &&
                    self.calls["getPoints"]()[i + 1] != null) {
                  canvas.drawLine(self.calls["getPoints"]()[i], self.calls["getPoints"]()[i + 1], paint);
                }
              }
            }
        },
  },
  "polygon": {
    "vars": (var tokens) => {
          "sidelen": tryParse(tokens, ["sidelen"]),
          "sides": tryParse(tokens, ["sides"], type: "int"),
        },
    "functions": (CustomModel self) => {

    },
  },
   "circle": {
    "vars": (var tokens) => {
          "radius": tryParse(tokens, ["radius", "r"]),
        },
    "functions": (CustomModel self) => {},
  },


   "animatedLine": {
    "vars": (var tokens)  {
      return{
          "point1": tokens["pt1"],// tryParse(tokens, ["p1", "pt2"]),
          "point2":  tokens["pt2"],
          "currentStep":0,
      };
        },
    "functions": (CustomModel self) => {
      "update": ({var stepSizeRight=1.0, var stepSizeDown=1.0}){
        self.vars["point1"].calls["update"](self.vars["currentStep"],stepSizeRight,stepSizeDown );
        self.vars["point2"].calls["update"](self.vars["currentStep"],stepSizeRight,stepSizeDown);
        self.vars["currentStep"]=self.vars["currentStep"]+1;
      },
      "paint":(Canvas canvas, Size size){
         Paint p = Paint()
         ..color = Colors.green//RandomColor.next()
        //Colors.green//lineNode.vars["color"]
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
        canvas.drawLine(self.vars["point1"].vars["current"], self.vars["point2"].vars["current"], p);
      }
    },
  },
  "movingPoint":{
    "vars": (var tokens)  {
      return{
          "origin": tokens["origin"] ,//tryParse(tokens, ["origin"]), 
          "current":  tokens["origin"], //tryParse(tokens, ["origin"]),
          "steps": tokens["steps"]
      };
    },
    "functions": (CustomModel self) => {
      "update": (var currentStep, var stepSizeRight, var stepSizeDown){
        if(self.vars["steps"] ==[]) {print("OLOL");
          return;}
        var step = self.vars["steps"][currentStep.remainder(self.vars["steps"].length)];
        self.vars["current"]=self.vars["current"]+ Offset(stepSizeRight*step.vars["right"],stepSizeDown*step.vars["down"]);
      }
    },
  },
  "step":{
    "vars": (var tokens) => {
          "right":  tryParse(tokens, ["right", "r"])??-tryParse(tokens, ["left", "l"])??0.0, //
          "down": tryParse(tokens, ["down", "d"])??-tryParse(tokens, ["up", "u"])??0.0,//??-tryParse(tokens, ["up", "u"])
    },
     "functions": (CustomModel self) => {},
  },

};
 