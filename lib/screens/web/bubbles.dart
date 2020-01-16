
// import 'dart:math';

// import 'package:cshannon3/components/circ_indent_clipper.dart';

// import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/components/circ_indent_clipper.dart';
import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/controllers/scale_controller.dart';
import 'package:cshannon3/screens/web/tile.dart';
import 'package:cshannon3/state_manager.dart';
import 'package:cshannon3/theming.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Bubbles extends StatefulWidget {
  final StateManager stateManager;
  Bubbles(this.stateManager,);
  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles>  with TickerProviderStateMixin {
  List<CustomModel> categoryBubbles = [];
  List<CustomModel> itemNodes = [];
  AnimationController animationController;
 
  List<Widget> categoryWidgets=[];
  List<Widget> nodeWidgets=[];   
  List<Widget> activeWidgets=[];
  CurvedAnimation decelerate, fastIn, easeIn;
 CustomModel centerItem, activeItem;

 List<String> types= [ "site", "youtube", "books"];
 String viewType="bubbles";
 var lis;
 Rect centerRect, bubbleBox;//ScaleController sc;
 Status status=Status.EMPTY;
 int catShown=8;
   @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
     animationController= AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      );
    _getModels();
    _sizeWidgets();
    animationController.addStatusListener((listener){
      if(listener==AnimationStatus.completed){
        print("completed");
        onComplete();
        activeWidgets=getActiveWidgets();
        setState(() {});
      }
    });
      _setCurves();
    }

  _getModels(){
    categoryBubbles=widget.stateManager.getModels("categories");
    itemNodes=widget.stateManager.getAllModels();//widget.items
    categoryBubbles.forEach((category){
     category.vars["nodes"]=  itemNodes.where((b)=>(types.contains(b.vars["type"])&& b.vars["categories"]!=null && b.vars["categories"][0]==category.vars["name"])).toList();
    });
    categoryBubbles.sort((a,b)=>b.vars["nodes"].length.compareTo(a.vars["nodes"].length));
    catShown=categoryBubbles.length;
    while(catShown> 3 && categoryBubbles[catShown-1].vars["nodes"].length==0){
      catShown-=1;
    }
  }

  _sizeWidgets(){
    categoryWidgets=[];
    nodeWidgets=[];
    centerRect = widget.stateManager.sc.centerRect();
    bubbleBox= widget.stateManager.sc.bubbleBox();
    Map<int, Rect> categoryLocs = widget.stateManager.sc.getLocations(nodesShown: catShown, layoutType: BUB.OVAL, );
    categoryLocs.forEach((k, v){
     CustomModel category = categoryBubbles[k];
      if(category.vars["size"]==2)
       category.vars["loc"]=v.inflate(50.0);
      else
       category.vars["loc"]=v;
      int len = (category.vars["nodes"].length<12)?category.vars["nodes"].length:12;
      categoryWidgets.add(toCategoryWidget(category));
      
           if(category.vars["size"]==2){
       Map<int, Rect> nodeLocs = widget.stateManager.sc.getLocations(area:category.vars["loc"], nodesShown:len);
      nodeLocs.forEach((index, loc){
        category.vars["nodes"][index].vars["loc"]=nodeLocs[index];
        nodeWidgets.add(toNodeWidget(category.vars["nodes"][index]));
      });
       }
  
    });

  }

  onRemove(){
     activeWidgets=getActiveWidgets();
        animationController.forward(from:0.0);
        setState(() {
        });
  }

_setCurves(){
  decelerate= CurvedAnimation(
       parent: animationController,
       curve: Curves.decelerate
     );
    fastIn = CurvedAnimation(
       parent: animationController,
       curve: Curves.fastLinearToSlowEaseIn
     );
      easeIn= CurvedAnimation(
       parent: animationController,
       curve: Curves.easeIn
     );
}

   Widget toNodeWidget( CustomModel node){//Size screenSize,
     return (node.vars["loc"]==null)?null:
     Positioned.fromRect(
       rect: node.vars["loc"],
      child:GestureDetector(
        onDoubleTap: ()=>launch(node.vars["url"]),
        onTap: (){
          setActive(node);
          activeWidgets=getActiveWidgets();
          animationController.forward(from:0.0);
          setState(() {
          });
        },
        child: Container(
              decoration: getBubbleDecoration(node),
              padding: EdgeInsets.all(5.0),
              child: 
              CircleAvatar(
                backgroundImage:(!node.vars["imgUrl"].contains("http"))
                ? AssetImage(node.vars["imgUrl"])
                : NetworkImage(node.vars["imgUrl"]),
                radius: node.vars["loc"].width/2??double.maxFinite,
              ),
            ),
      )
     );
  }



   Widget toCategoryWidget(CustomModel cb){
    return Positioned.fromRect(
      rect: cb.vars["loc"],
      child: 
      GestureDetector(
        onTap: (){
          if(cb.vars["size"]==1)cb.vars["size"]=2;
          else if(cb.vars["size"]==2)cb.vars["size"]=1;
          _sizeWidgets();
          setState(() {
            
          });
        },
        child: Container(decoration: BoxDecoration(
          color: cb.vars["color"].withOpacity(0.5),
          border: Border.all(color: cb.vars["color"]),
          shape: BoxShape.circle
        ),
        child: Center(
        //  alignment: Alignment.center,
          //child: cb.vars["size"]==1?
          child: Text(cb.vars["name"], style: fsSm
          //TextStyle(color: Colors.white, fontSize: 12.0),
          )
          // Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Expanded(child: Container(),),
          //     IconButton(icon: Icon(Icons.add),color: Colors.white, onPressed: (){},),
          //     Text(cb.vars["name"], style: TextStyle(color: Colors.white, fontSize: 12.0),),
          //     IconButton(icon: Icon(Icons.minimize),color: Colors.white,onPressed: (){},),
          //     Expanded(child: Container(),),
          //   ],
          // )
          ),),
      )
      );
  }

  String getCurrentText(){
    String out="#bold##size25#";
    if(activeItem!=null){
      out+=activeItem.vars["name"]??"";
      out+="#/bold##size16#\n";
      out+=ifIs(activeItem.vars, "description")??"";
    }
    else if (centerItem!=null){
      out+=centerItem.vars["name"]??"";
      out+="#/bold##size16#\n";
      out+=ifIs(centerItem.vars, "description")??"";
    }
    return out;
  }
    Widget tiles(){
   return Container(
              padding: EdgeInsets.all(30.0),
                child:new GridView.count(
                crossAxisCount:(widget.stateManager.sc.w()/180.0).floor(),
                children: itemNodes.where((b)=>(types.contains(b.vars["type"]))).map((n){
        return MyTile(modelData: n,);
      }).toList()
                )
                );
  }
  
 


   
List<Widget> getActiveWidgets(){
  List<Widget> out=[];
  switch(status){
    case Status.ENTERING:
      out.add(toAnimatedBox(from: activeItem.vars["loc"], to: centerRect, imgUrl:activeItem.vars["imgUrl"],));
     out.add(AnimatedBuilder(
        animation: animationController,
        child:   ClipPath(
            clipper: CircleIndentClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.only(top:bubbleBox.height*0.25, left: 5.0, right: 5.0),
            child: ListView(
              children: <Widget>[
                 Container(
                    alignment:Alignment.topCenter,
                    child: toRichText({
                      "text":getCurrentText(),
                      //defaultDescription,
                      "token":"#"
                    })
                 )
              ],
            ),
          
          ),),
        builder: (context, child) {
        return   (activeItem==null && centerItem==null)?Container():
        Positioned.fromRect(
          rect:bubbleBox,
          child:Opacity(
          opacity: (animationController.value>0.8)?(animationController.value-0.8)*5.0:0.0,
          child: child,

        ));
        }
      ));
      break;
    case Status.EXITING:
    out.add(toAnimatedBox(from: centerRect, to: centerItem.vars["loc"], imgUrl:centerItem.vars["imgUrl"],  entering: false));
      break;
    case Status.CENTER:
         out.add(
         Positioned.fromRect(
          rect:bubbleBox,
          child:
         ClipPath(
            clipper: CircleIndentClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: EdgeInsets.only(top:bubbleBox.height*0.25, left: 5.0, right: 5.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment:Alignment.topCenter,
                    child: toRichText({
                      "text":getCurrentText(),
                      "token":"#"
                    })
                  ),
                ],
              ),
            ),
          
          ),),)
      );
    
      out.add(
        Positioned.fromRect(
          rect: centerRect,
          child: GestureDetector(
            onDoubleTap: (){
              if(centerItem.vars.containsKey("demoPath"))widget.stateManager.changeScreen(centerItem.vars["demoPath"]);
              else if(centerItem.vars.containsKey("url"))launch(centerItem.vars["url"]);
              else if(centerItem.vars.containsKey("githubUrl"))launch(centerItem.vars["githubUrl"]);
            },
            onTap: (){
              print("remove");
            status=Status.EXITING;
            onRemove();
            //  notifyListeners();
            },
            child: Container(
                decoration: BoxDecoration( shape: BoxShape.circle,),
                padding: EdgeInsets.all(5.0),
                child: 
                CircleAvatar(
                  backgroundImage:(!centerItem.vars["imgUrl"].contains("http"))
                ? AssetImage(centerItem.vars["imgUrl"])
                : NetworkImage(centerItem.vars["imgUrl"]),
                  radius: centerRect.width/2,
                ),
     ),
          ),
        )
      );
 
      break;
    case Status.INOUT:
   // print("inout");
      out.add(toAnimatedBox(from: activeItem.vars["loc"], to: centerRect, imgUrl:activeItem.vars["imgUrl"], ));
      out.add(toAnimatedBox(from: centerRect, to: centerItem.vars["loc"], imgUrl:centerItem.vars["imgUrl"], entering: false));
      out.add(AnimatedBuilder(
        animation: animationController,
        child:   ClipPath(
            clipper: CircleIndentClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding:  EdgeInsets.only(top:bubbleBox.height*0.25, left: 5.0, right: 5.0),
              child: ListView(
                children: <Widget>[
                  Container(
                     alignment:Alignment.topCenter,
                    child: toRichText({
                      "text":getCurrentText(),//defaultDescription,
                      "token":"#"
                    })
                  ),
                ],
              ),
            ),
          
          ),),
        builder: (context, child) {
        return   (activeItem==null && centerItem==null)?Container():
        Positioned.fromRect(
          rect:bubbleBox,
          child:Opacity(
          opacity: (animationController.value>0.8)?(animationController.value-0.8)*5.0:0.0,
          child: child,

        ));
        }
      ));
      break;
    case Status.EMPTY:
      break;
  }
  return out;
}



Widget toAnimatedBox({Rect from, Rect to, String imgUrl, bool entering=true}){
    final Offset offsetToMove= to.center-from.center;

    final double max= (from.width>to.width)?from.width/2:to.width/2;
    final double min= (from.width<to.width)?from.width/2:to.width/2;
    final ImageProvider _i=(imgUrl.contains("http"))
    ? NetworkImage(imgUrl)
                : AssetImage(imgUrl)
                ;
    final double growth= (to.width-from.width)/2;
   
    return  AnimatedBuilder(
        animation: animationController,
        child:  Container(
              decoration: BoxDecoration( shape: BoxShape.circle,),
              padding: EdgeInsets.all(5.0),
              child: 
              CircleAvatar(
                backgroundImage:_i,
                maxRadius: max,
                minRadius: min,
              ),
     ),
        builder: (context, child) {
        return Positioned.fromRect(
          rect: Rect.fromCircle(
            center: from.center+offsetToMove*decelerate.value,
           // center: from.center*(1.0-decelerate.value)+to.center*decelerate.value,
            radius:(entering)?(from.width/2)+growth*easeIn.value:(from.width/2)+growth*fastIn.value
          ),
            child:  child
      );
        }
      );
  }
  onComplete(){
    if(status==Status.ENTERING || status== Status.INOUT){
    
         centerItem=activeItem;
         activeItem=null;
         status=Status.CENTER;
       }
       else {
         centerItem=null;
         status=Status.EMPTY;
       } 
}

setActive(CustomModel newNode){//ItemNode newNode){
  
    activeItem=newNode;
    if(status== Status.EMPTY){
      status=Status.ENTERING;
     
    }
    else if(status== Status.CENTER){
      if(centerItem==newNode)status=Status.EXITING;
      else 
        status=Status.INOUT;
    }
}


Widget tileLayout(){

 return Padding(
   padding: const EdgeInsets.only(top:80.0),
   child: GridView.count(
                  crossAxisCount:(widget.stateManager.sc.w()/180.0).floor(),
                  children: itemNodes.where((b)=>(types.contains(b.vars["type"]))).map((n){
          return MyTile(modelData: n,);
        }).toList()),
 );
}
Widget bubbleLayout(){

  return Stack(children: [

       
      ]..addAll(categoryWidgets)..addAll(nodeWidgets)..addAll(activeWidgets)
      );
       
}
   
  @override
  Widget build(BuildContext context) {
    return 
     Stack(
       children: <Widget>[
           viewType=="bubbles"?bubbleLayout():tileLayout(),
         Positioned(
           left: 0.0,
           width: 300.0,
           height: 60.0,
           top: 0.0,
           child: Column(
             children: <Widget>[
               Container(
                 height: 30.0,
                 child: Row(children: <Widget>[
                   FlatButton(
                   color: viewType=="bubbles"?Colors.grey.withOpacity(0.5):null,
                  onPressed: (){
                   viewType="bubbles";
                    _getModels();
                    _sizeWidgets();
                    setState(() {
                    });
                  }, child: Text("Bubbles",style: fsMed,),

                ),
                FlatButton(
                   color: viewType=="tiles"?Colors.grey.withOpacity(0.5):null,
                  onPressed: (){
                   viewType="tiles";
                    _getModels();
                    _sizeWidgets();
                    setState(() {
                    });
                  }, child: Text("Tiles",style: fsSm,),

                )
                 ],),
               ),
               Container(
                 height: 30.0,
                 child: Row(children: <Widget>[
                     IconButton(
              icon: Icon(FontAwesomeIcons.internetExplorer),
               color: types.contains("sites")?Colors.grey.withOpacity(0.5):null,
              onPressed: (){
               if( types.contains("sites"))types.remove("sites");
               else types.add("sites");
                _getModels();
                _sizeWidgets();
                setState(() {
                });
              }, //child: Text("Sites",style: fsSm,),

            ),
         IconButton(
              icon: Icon(FontAwesomeIcons.book),
               color: types.contains("books")?Colors.grey.withOpacity(0.5):null,
              onPressed: (){
               if( types.contains("books"))types.remove("books");
               else types.add("books");
                _getModels();
                _sizeWidgets();
                setState(() {
                  
                });
              }, //child: Text("Books",style: fsSm,),

            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.youtube),
               color: types.contains("youtube")?Colors.grey.withOpacity(0.5):null,
              onPressed: (){
               if( types.contains("youtube"))types.remove("youtube");
               else types.add("youtube");
                _getModels();
                _sizeWidgets();
                setState(() {
                  
                });
              }, //child: Text("Youtube",style: fsSm,  ),

            )
              
                 ],),
               ),
             ],
           ),
         ),
        //typeMenu(),
       // Expanded(child: 
      //),
      ],
    );
  }
}

enum Status{
  ENTERING,
  EXITING,
  CENTER,
  INOUT,
  EMPTY
}




// Widget typeMenu(){
//   List<Widget> out=[];
//   [["Projects","project"],["Sites","site"],["Books,""book"], ["Youtube","youtube"]].forEach((f){
//          out.add(FlatButton(
//                color: types.contains(f[1])?Colors.grey.withOpacity(0.5):null,
//               onPressed: (){
//                if( types.contains(f[1]))types.remove(f[1]);
//                else types.add(f[1]);
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//               }, child: Text(f[0]),

//             ));
//           });
//       //    out.add( Expanded(child: Container(),));
//     [["Bubbles","bubbles"],["Lists","lists"],["Tiles,""tiles"]].forEach((g){
//        out.add(FlatButton(
//                color: viewType==g[1]?Colors.grey.withOpacity(0.5):null,
//               onPressed: (){
//                viewType=g[1];
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
//                 });
//               }, child: Text(g[0]),

//             ));

//     });
     
//   return Row(
//           children: out
//   );

// }

// Widget typeMenu(){
//   return Row(
//           children: <Widget>[
//             FlatButton(
//                color: types.contains("project")?Colors.grey.withOpacity(0.5):null,
//               onPressed: (){
//                if( types.contains("project"))types.remove("project");
//                else types.add("project");
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//               }, child: Text("Projects"),

//             ),
//             FlatButton(
//                color: types.contains("site")?Colors.grey.withOpacity(0.5):null,
//                onPressed: (){
//                   if( types.contains("site"))types.remove("site");
//                else types.add("site");
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//                },
//               child: Text("Sites"),

//             ),
//             FlatButton(
//                color: types.contains("book")?Colors.grey.withOpacity(0.5):null,
//                onPressed: (){
//                   if( types.contains("book"))types.remove("book");
//                else types.add("book");
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//                },
//  child: Text("Books"),
//             ),
//             FlatButton(
//                color: types.contains("youtube")?Colors.grey.withOpacity(0.5):null,
//                onPressed: (){
//                   if( types.contains("youtube"))types.remove("youtube");
//                else types.add("youtube");
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//                },
//  child: Container(
//      decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.0)
//         ),
//    child: Text("Youtube")),
//             ),
        
//             Expanded(child: Container(),),
//             FlatButton(
//                color: viewType=="bubbles"?Colors.grey.withOpacity(0.5):null,
//               onPressed: (){
//                viewType="bubbles";
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//               }, child: Text("Bubbles"),

//             ),
//             FlatButton(
//                color: viewType=="tiles"?Colors.grey.withOpacity(0.5):null,
//                onPressed: (){
//                    viewType="bubbles";
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
                  
//                 });
//                },
//               child: Text("Sites"),

//             ),
//             FlatButton(
//                color:viewType=="lists"?Colors.grey.withOpacity(0.5):null,
//                onPressed: (){
//                  viewType="lists";
//                 _getModels();
//                 _sizeWidgets();
//                 setState(() {
//                 });
//                },
//  child: Text("Lists"),
//             ), 
//           ],
//           );
// }