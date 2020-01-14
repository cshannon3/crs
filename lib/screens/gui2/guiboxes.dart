

import 'dart:math';

import 'package:cshannon3/screens/gui2/boxInfo.dart';
import 'package:cshannon3/screens/gui2/data.dart';
import 'package:cshannon3/screens/gui2/dragbox.dart';
import 'package:cshannon3/screens/gui2/guibox.dart';
import 'package:cshannon3/screens/gui2/lrtb.dart';
import 'package:cshannon3/screens/gui2/text_edit_model.dart';
import 'package:cshannon3/screens/gui2/widget_manager.dart';
import 'package:cshannon3/state_manager.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';





class GuiScreen2 extends StatefulWidget {
  final StateManager stateManager;

  const GuiScreen2( this.stateManager) ;
  @override
  _GuiScreen2State createState() => _GuiScreen2State();
}

class _GuiScreen2State extends State<GuiScreen2> {
  MainDelagator d;
  WidgetManager wm;
  bool isEditing = false;
    bool editMode = true;
  bool isHidden=false;
  String photoFromAsset;// String photoFromUrl="";// bool hasImage=false;// bool hasPadding=false;
  List<TextEditModel> textEdits=[TextEditModel(text: " Text Before"), TextEditModel(text: "Focused Text"), TextEditModel(text: " Text After")];
  int focusedText=1;
  TextEditingController textEditingController;
  TextEditingController fontSizeController;
  List<TapGestureRecognizer>textTapDetectors=[];
     String incr = "";
  List<Widget> lw = [];
    var map;
  Widget child;
  Size size;

  @override
  void initState() {

    super.initState();
    
   map={
     "color":{ "type":"dropdown",  "value":"",  "items": colorOptions },
      "shade":{ "type":"dropdown","value":incr, "items": incrList },
      "opacity":{ "type": "updownarrows", "incr":0.1, "max":1.0, "min":0.0, "value":1.0 },
      "borderColor":{ "type":"dropdown", "value":"", "items": colorOptions, },
      "borderThickness":{  "type": "updownarrows", "incr":1.0,   "min":0.0, "value":2.0  },
      "borderRadius":{"type": "updownarrows","incr":1.0,   "min":0.0, "value":2.0 },
      "decorate":{ "type":"raisedButton","text":"decorate","value":false },
      "hasChildren":{"value":false},
      "singleChild":{"type":"flatButton", "text":"single Child","setLocation":"hasChildren", "value":false,},//"color":(){ var b = map["hasChildren"]["value"]; if(b)print("true");return b?"red":"blue";}},
      "children":{ "type":"flatButton","text":"children","expanded":true, "setLocation":"hasChildren", "value":true},// "color":(){return (map["hasChildren"]["value"])?"blue":""; }},
      "centered":{ "type":"raisedButton","trueText":"center", "falseText":"uncenter","value":true},
      "childType":{"value":CHILDTYPE.BOX},
      "box":{"type":"flatButton", "text":"Box","setLocation":"childType", "value":CHILDTYPE.BOX,},
      "image":{"type":"flatButton", "text":"Image","setLocation":"childType", "value":CHILDTYPE.IMAGE,},
      "text":{"type":"flatButton", "text":"Text","setLocation":"childType", "value":CHILDTYPE.TEXT,},
      "button":{"type":"flatButton", "text":"Button", "expanded":true,"setLocation":"childType", "value":CHILDTYPE.BUTTON,},
      "textcolor":{ "type":"dropdown",  "value":"",  "items": colorOptions },
      "photoFromUrl":{ "type":"dropdown",  "value":"",  "items": imges },
      "hasImage":{ "type":"raisedButton","trueText":"remove Image", "falseText":"remove Image","value":false},
      "hasPadding":{ "type":"raisedButton","trueText":"Remove Padding", "falseText":"Add Padding","value":false, "centered":true},
      "optionsOpen":{ "type":"raisedButton","text":"close","value":false },
      "bold":{ "type":"iconButton","icon":Icons.format_bold,"value":false },
      "italic":{ "type":"iconButton","icon":Icons.format_italic,"value":false },
      "nextLine":{ "type":"iconButton","icon":Icons.arrow_downward,"value":false },
      };
      


      wm = WidgetManager(map: map, updateVal: updateVal);
      // lw= randomBlockList();
         for(int y=0;y<textEdits.length;y++){
        textTapDetectors.add(TapGestureRecognizer());
    }
    for(int y=0;y<textEdits.length;y++){
        textTapDetectors[y]..onTap = () {
      print("tpped on $y");
      setState(() {
        focusedText=y;
        textEditingController.text= textEdits[focusedText].text;
        fontSizeController.text=textEdits[focusedText].fontSize.toStringAsPrecision(2);
      });
    };
    }

    d = MainDelagator((BoxInfo focusBoxData)=>setFocus(focusBoxData));
    d.rootBox = GuiBox(LRTB(0.0, 1.0, 0.0, 1.0));
    d.rootBox.isRoot = true;
    d.rootBox.childrenBoxes.addAll([
      GuiBox(LRTB(0.1, 0.9, 0.0, 0.25), color: Colors.blue),
      GuiBox(LRTB(0.0, 0.25, .25, 0.95), color: RandomColor.next()),
      GuiBox(LRTB(0.28, 0.9, .27, 0.95), color: RandomColor.next()),
      //GuiBox(LRTB(0.28, 0.9, .27, 0.95), color: RandomColor.next()),
    ]);


    d.addListener(() {
      setState(() {});
    });

  }
  Color boxColor()=>colorFromString(map["color"]["value"] + map["shade"]["value"], opacity: map["opacity"]["value"]);
  setFocus(BoxInfo bd){
    print(bd.prnt());
     map["color"]["value"]=bd.color;
      map["childType"]["value"]=bd.childType;
       map["opacity"]["value"]=bd.opacity;
        map["shade"]["value"]=bd.shade;
      map["decorate"]["value"]=bd.decorate;
      map["borderThickness"]["value"]=bd.borderThickness;
      map["borderColor"]["value"]=bd.borderColor;
      map["borderRadius"]["value"]=bd.borderRadius;
      map["hasPadding"]["value"]=bd.hasPadding;
      map["centered"]["value"]=bd.centered;
      map["photoFromUrl"]["value"]=bd.imgUrl;
     
      setState(() {
        
      });

    }
  void updateVal(String key, var newVal){
    if(map[key] is Map)
          map[key]["value"]=newVal;
   else map[key]=newVal;

   print(key);
   setState(() {});
 }

 @override
  void dispose() {
    textEditingController.dispose();
    d.dispose();
    super.dispose();
  }
  Widget optionsWidget(){
 // CHILDTYPE childType=map["childType"]["value"];
    return Positioned(
     left: 0.0,
     bottom: 50.0,
     width: widget.stateManager.sc.w(),
     height: 50.0,
child:
         Container(
           color: Colors.grey.withOpacity(0.5),
           child: ListView(
                        scrollDirection: Axis.horizontal,
                        
                        children: <Widget>[
                          wm.toWidget("color"),
                          wm.toWidget("shade"),
                          Container(width: 700.0,child: wm.toRow(["opacity","centered","decorate","borderColor", "borderThickness", "borderRadius"],))
                        ],
           ),  ),  );
  }
   Widget textSettings(){
    return Row(
                            children: <Widget>[
                            
                             IconButton(onPressed: () {setState(() { textEdits[focusedText].fw=(textEdits[focusedText].fw==FontWeight.bold )?FontWeight.normal:FontWeight.bold;}); },icon: Icon(Icons.format_bold), ),
                             IconButton(onPressed: () {setState(() {textEdits[focusedText].fs=(textEdits[focusedText].fs==FontStyle.italic )?FontStyle.normal:FontStyle.italic;}); },icon: Icon(Icons.format_italic), ),
                             IconButton(onPressed: () {setState(() { textEdits[focusedText].newLines+=1;}); },icon: Icon(Icons.arrow_downward), ),
                             DropdownButton<String>(
                              value: textEdits[focusedText].color,
                              items: colorOptions
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String newVal) {
                                textEdits[focusedText].color=newVal;
                                setState(() {});
                              },
                            ),
                            Expanded(
                                    child: TextField(
                                      controller:fontSizeController,
                                      onChanged: (text) {
                                          var newFontSize = double.tryParse(text);
                                          if(newFontSize!=null && newFontSize>0.0)
                                          setState(() {
                                            textEdits[focusedText].fontSize=newFontSize;
                                          });
                                        },
                                      ),
                                  ),
                                
                              ],
                            
                          );
  }
  @override
  Widget build(BuildContext context) {
    d.size = widget.stateManager.sc.mainArea().size;
    //MediaQuery.of(context).size - Offset(MediaQuery.of(context).size.width*0.2, 0.0);
    d.context = context;
    return Stack(
      children: <Widget>[
        SizedBox.fromSize(
            size: d.size,
            child: GestureDetector(
                onPanStart: d.onPanStart,
                onPanUpdate: d.onPanUpdate,
                onPanEnd: d
                    .onPanEnd, // onDoubleTap: d.onDoubleTap, //   onLongPress: d.onLongPress,
                onTapUp: d.onTapUp, //onTap: // onTapDown: d.onTapDown,
                child: Container(
                    color: Colors.transparent,
                    child: d.rootBox
                        .toStack(d.size, boxinfo: BoxInfo.fromMap(map), refresh: () => setState(() {}))),) //getBox: ({Widget child})=>getBox(child: child)

            ),
            optionsWidget()
        //   wm.only("optionsOpen", optionsWidget(d.size)),
      ],
    );
  }
}

// Main delagator gets taps and sends them down chain of deals with them on own

class MainDelagator extends ChangeNotifier {
  //Set context for each setstate in order to  have access to widget tree info
  BuildContext context;
  Size size;
 final Function(BoxInfo map) setFocus;

  GuiBox rootBox;
  Point currentTapLocation;
  bool focus=false;

  MainDelagator(this.setFocus);

  double getH() => size.height;
  double getW() => size.width;

  
  updateTapLocation(Offset screenpos) =>
      currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());

  delegateTap(Offset screenpos) {
    currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());
    //currentBox = (i<mainBoxes.length)?i:null;
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

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }
enum PRESS { TAP, DOUBLETAP, LONGPRESS, PAN }

class DragPainter extends CustomPainter {
  final DragBox dragbox;
  final Paint boxPaint1;

  DragPainter({
    this.dragbox,
  }) : boxPaint1 = Paint()
  {
    boxPaint1.color = this.dragbox.color;
    boxPaint1.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    Path pathOne = dragbox.drawPath(size);
    canvas.drawPath(pathOne, boxPaint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}




    // dropPaint.color = Colors.grey;
    // dropPaint.style = PaintingStyle.fill;
   // wm.toWidget("opacity"),
                         // Container(child: Row(children: wm.toWidgets(["color", "shade", "opacity"], additonalWidgets: {"0":Text("Color:")}) )),
                         // wm.or("decorate", wm.toRow(["borderColor", "borderThickness", "borderRadius"], additional:{"0":Text("Border:")}), wm.toRaisedButton("decorate") ),
                          // wm.toFlatButton("singleChild", extra: {"color":map["hasChildren"]["value"]?null:"blue"}),
                         //  wm.toFlatButton("children", extra: {"color":map["hasChildren"]["value"]?"blue":null}),
                         //  wm.onlyNot("hasChildren","centered"),
                          // wm.onlyNot("hasChildren", {"box":{"color": (childType==CHILDTYPE.BOX)?"blue":null,}}),
                            // "image":{"color": (childType==CHILDTYPE.IMAGE)?"blue":null,},
                            // "text":{"color": (childType==CHILDTYPE.TEXT)?"blue":null,},
                            // "button":{"color": (childType==CHILDTYPE.BUTTON)?"blue":null,},
                            // })),
                          //  wm.onlyNot("hasChildren",wm.toRow( {
                          //     "box":{"color": (childType==CHILDTYPE.BOX)?"blue":null,},
                          //   "image":{"color": (childType==CHILDTYPE.IMAGE)?"blue":null,},
                          //   "text":{"color": (childType==CHILDTYPE.TEXT)?"blue":null,},
                          //   "button":{"color": (childType==CHILDTYPE.BUTTON)?"blue":null,},
                          //   })),
            
                        //  wm.onlyNot("hasChildren", 
                        // // (!map["hasChildren"]["value"])? 
                        //   (childType==CHILDTYPE.BOX)? Container():
                        //   (childType==CHILDTYPE.IMAGE)?   Row(
                        //    children: wm.toWidgets(["hasImage","photoFromUrl"])
                        //  ):
                        //    (childType==CHILDTYPE.BUTTON)? Container():
                        //     (childType==CHILDTYPE.TEXT)?textSettings():
                        //      Container()),//: Container(),
                     //  wm.toRaisedButton("hasPadding"),
                      // wm.toRaisedButton("optionsOpen"),

// Widget getBox({Widget child}){
//          CHILDTYPE childType=map["childType"]["value"];
//         return Container(
//             decoration: 
//             BoxDecoration(
//               color:boxColor(),//boxColor,
//               border: map["decorate"]["value"]?Border.all(width:map["borderThickness"]["value"], color: colorFromString(map["borderColor"]["value"]),):null,
//               borderRadius: map["decorate"]["value"]?BorderRadius.circular(map["borderRadius"]["value"]):null
//             ),
//             child: Padding(
//               padding: EdgeInsets.all((map["hasPadding"]["value"])?8.0:0.0),
//               child: (child!=null)? child:
//               map["hasChildren"]["value"]
//                   ? ListView( children: lw, )
//                      : map["centered"]["value"]?Center(child:
//                      (childType==CHILDTYPE.BOX)? child:
//                       (childType==CHILDTYPE.IMAGE)? (map["photoFromUrl"]["value"]!="")?Image.network(map["photoFromUrl"]["value"], fit: BoxFit.fill,):Container():
//                       //(photoFromAsset!="")?Image.asset("assets/images/$photoFromAsset"):Container():
//                        (childType==CHILDTYPE.BUTTON)? Container():
//                         (childType==CHILDTYPE.TEXT)?textEdits[0].toWidget(children: textEdits.sublist(1), recognizers: textTapDetectors)://Text(textEditingController.text):
//                           Container()
//                      ):
//                        (childType==CHILDTYPE.BOX)? child:
//                       (childType==CHILDTYPE.IMAGE)? (map["photoFromUrl"]["value"]!="")?Image.network(map["photoFromUrl"]["value"], fit: BoxFit.fill,):Container():
//                       //(photoFromAsset!="")?Image.asset("assets/images/$photoFromAsset"):Container():
//                        (childType==CHILDTYPE.BUTTON)? Container():
//                         (childType==CHILDTYPE.TEXT)?textEdits[0].toWidget(children: textEdits.sublist(1), recognizers: textTapDetectors)://Text(textEditingController.text):
//                           Container()
//             ),
//           );
//       }

//       BoxInfo saveBoxInfo(){

//       }