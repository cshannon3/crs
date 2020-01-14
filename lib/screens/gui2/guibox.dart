
import 'dart:math';
import 'package:cshannon3/screens/gui2/boxInfo.dart';
import 'package:cshannon3/screens/gui2/dragbox.dart';
import 'package:cshannon3/screens/gui2/guiboxes.dart';
import 'package:cshannon3/screens/gui2/lrtb.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';


class GuiBox{
  LRTB loc;
  LRTB bounds=LRTB(0.0, 1.0, 0.0, 1.0);
  List<GuiBox> childrenBoxes=[];
  int currentIndex;
  DragBox currentDragBox;
  int tapCount=0;
  Function() onNewChild;
  int myTapCount=0;
  Color color;
  var _boxInfo=BoxInfo();

  bool dismissMe=false;
  bool isDragging=false;
  bool childDragging=false;
  bool guiActive=true;
  bool isRoot=false;
  bool isfoc=false;

  String type="";
  dynamic childCall;

  Widget child;
  GuiBox(this.loc, {this.color, this.child, this.onNewChild});
  // List<LRTB> arrangeChildrenLocs(int len,{int columns=1, double min=0.05, double max=0.4}){
  //    List<LRTB> out =[];
  //    int i=0;
  //    int itemsPerColumn = (len/columns).ceil();
  //   for (int c=0;c<columns;c++){
  //     out.add(LRTB())
      
  //   }

  // }


  resetFocuses(){
     isfoc=false;
        if(childrenBoxes.isNotEmpty)
          childrenBoxes.forEach((b){
            b.resetFocuses();
          });
  }
   bool checkFocus(){
     bool f = isfoc;
     int i=0;
     while(!f && childrenBoxes.length>i){
        f=childrenBoxes[i].checkFocus();
        i++;
     }
      return f;
  }

   bool handleClick(Point clickLocation, Function(BoxInfo newData) setFocus){
    print("MY LOCATION");loc.prnt();print(clickLocation);
   
    
    if(loc.isWithin(clickLocation))return _handleClick(clickLocation, setFocus);
     
    else {
      isfoc=false;
      myTapCount=0;
      currentIndex=null;tapCount=0;
      return false;
    }
  }

  bool _handleClick(Point clickLocation, Function(BoxInfo newData) setFocus){
    // CLICK WAS MADE INSIDE BOX
      myTapCount+=1;
      isfoc=false;
      Point rs = loc.rescale(clickLocation);

      print("HANDLE CLICK"); print(rs); print(clickLocation);print(myTapCount);
      // HAS CHILDREN
      if(childrenBoxes.isNotEmpty && myTapCount>1){//&& !passedInChild//print("CHILD NOT EMPTY");
          int i =0;
          while(childrenBoxes.length>i && !childrenBoxes[i].handleClick(rs, setFocus))i++;
          
          if(i==childrenBoxes.length){
           
                  if(currentIndex!=null){
                    // Last tap was on an inner box -> set focus back to self
                    currentIndex=null;
                    tapCount=0;setFocus(_boxInfo);
                    isfoc=true;
                  }
                  else{ 
                    tapCount+=1;
                    if(tapCount>2)
                    addGui(rs);    
                  } 
            }
          else{
              isfoc=false;print("CHILD $i CLICKED");
              if(currentIndex!=i){currentIndex = i;tapCount=0;}
              else tapCount+=1;
              if(tapCount>2){
              print("CHILD MULTITAP");
              } 
         }
        }
        else if(myTapCount>2 )
           addGui(rs);
        
      else{
          if(currentIndex!=null){currentIndex=null;tapCount=0;isfoc=false;}else{ tapCount+=1; isfoc=true;setFocus(_boxInfo);}
        }
         return true;
    
  }

   addGui(Point rs){
     // This will add a box centered around the clicked point and expanded to 75% of available space
     GuiBox b;
            if(onNewChild!=null){
              final Widget w=onNewChild();
                b = GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y), color: Colors.yellow[200], child: w, onNewChild: onNewChild);
            }
            else{
                b = GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y), color: RandomColor.next());
            }
            b.isfoc=true;
            isfoc=false;
            childrenBoxes.add(b);
            currentIndex=childrenBoxes.length-1;
            setBounds();
              childrenBoxes.last.fitSpace(shrink:0.75);
               print("CHILD LOCATION");
               childrenBoxes.last.loc.prnt();
  }

  bool handleDrag(Point clickLocation){
    print(clickLocation);
    loc.prnt();
    if(loc.isWithin(clickLocation)){
      Point rs = loc.rescale(clickLocation);
      print(rs);
      setBounds();
      if(currentIndex!=null &&
       // tapCount>1 &&
      //!passedInChild &&
         childrenBoxes[currentIndex].handleDrag(rs)){
          print("DRAGGING child $currentIndex");
          
          childDragging=true;
          isDragging=false;
        }
        else if(!isRoot){ // && guiActive
          print("DRAGGING self");
          loc.prnt();
      currentDragBox=DragBox(loc,bounds );
      currentDragBox.isOnBox(clickLocation);
      isDragging=true;
        }
      return true;
    }
    else return false;

  }
  updateDrag(Point point) {
    if(isDragging && !isRoot) currentDragBox.updateDrag(point);
//&& !passedInChild
    else if(childDragging)childrenBoxes[currentIndex].updateDrag(loc.rescale(point));
  }
  endDrag(){
    dismissMe=false;
    setBounds();
    if(isDragging && !isRoot){
      isDragging=false;
      dismissMe=currentDragBox.endDrag();// if(dismissMe)
      currentDragBox=null;
    }else if (childDragging){
      childDragging=false;
      childrenBoxes[currentIndex].endDrag(); //currentDragBox.endDrag();  //if(currentDragBox.isDismissed()){
      if(childrenBoxes[currentIndex].dismissMe){
        print("Dismiss");
        childrenBoxes.removeAt(currentIndex);
        currentIndex=null;
      }
    }
  }

  updateBounds(LRTB neighborBox)=>
    bounds = loc.updateBounds(neighborBox, bounds);
  
  resetBounds()=>bounds=LRTB(0, 1.0, 0, 1.0);
  
  void fitSpace({double shrink}){
    loc=bounds;
    if(shrink!=null)loc.shrink(shrink);
  }
  setBounds({boxIndex}){
    if(boxIndex==null && currentIndex!=null)boxIndex=currentIndex;//if(currentBox==null)return;
    if(boxIndex==null)return;
    childrenBoxes[boxIndex].resetBounds();
    for (int boxNum=0; boxNum<childrenBoxes.length;boxNum++){
      print("BOX $boxNum BOUNDS");
      if(boxIndex!=boxNum)childrenBoxes[boxIndex].updateBounds(childrenBoxes[boxNum].loc);
    }
  }

  Widget al({Function() refresh}){
    return Align(alignment: Alignment.topRight,child: IconButton(icon: Icon(Icons.blur_circular,color: guiActive?Colors.green:Colors.grey,),
    onPressed: (){
      guiActive=!guiActive;
      if(refresh!=null)refresh();
      },
    ),
    );
  }


  Widget toWidget(Size screenSize, {BoxInfo boxinfo, Function() refresh,}){//Widget newChild,@required Function({Widget child}) getBox
    Size s = Size((loc.right-loc.left)*screenSize.width,(loc.bottom-loc.top)*screenSize.height);
    if(isfoc)_boxInfo=boxinfo;
     return Positioned(
       left: loc.left*screenSize.width,
       width: s.width,
       top: loc.top*screenSize.height,
       height: s.height,
       child:Stack(
         children: <Widget>[
           SizedBox.fromSize(
          size: s,
         child: Container(
           decoration: BoxDecoration(
           color:color,
           borderRadius: BorderRadius.circular(20.0),
           border:isfoc?Border.all(color: Colors.grey, width: 5.0):null
           ),
         child:_boxInfo.toWidget(
           child: (childrenBoxes.isNotEmpty)
                  ?toStack(s, refresh: refresh, boxinfo: boxinfo)
                 :
           null
           )
         )
         ),
         (child!=null)?SizedBox.fromSize(
          size: s,
          child:child):Container(),
            
           guiActive?SizedBox.fromSize(
          size: s,
          child:Container(
            color: Colors.grey.withOpacity(0.1),
            child:al(refresh: refresh))):al(refresh: refresh),
           
            
         ],
       ));

  }
    Widget toStack(Size screenSize, {BoxInfo boxinfo,Function() refresh,}){
      List<Widget> out=[];
      childrenBoxes.forEach((f){
        out.add(f.toWidget(screenSize, refresh: refresh,boxinfo: boxinfo, ));
      });
      
     // if(currentDragBox!=null)
      if(childDragging &&
      currentIndex!=null &&
      childrenBoxes[currentIndex].currentDragBox!=null
      )// && mainBoxes[currentBox].currentDragBox!=null)
      out.add( CustomPaint(
                    painter: DragPainter(
                      dragbox: childrenBoxes[currentIndex].currentDragBox
                    ), // Box Painter
                    child: Container()),);
      return Stack(children: out);
    }
}

 //&& !passedInChild && guiActive&& !passedInChild print("SELF MULTITAP");


  //bool isFocused()=>(myTapCount>0 && currentIndex==null);
         //isFocused()?getBox(child:(childrenBoxes.isNotEmpty)?toStack(s, refresh: refresh, getBox: getBox):null):
        // (childrenBoxes.isNotEmpty)?toStack(s, refresh: refresh, getBox: getBox):
        // Center(child: Text("Box X"))

//Function({Widget child}) getBox
      //print(screenSize);
  // void handleChildClick(){

  // }
  // void handleSelfClick(){

  // }

                //   if(tapCount<1){
                //   setFocus(_boxInfo);
                //   isfoc=true;
                // }
  // GuiBox b= GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y), color: RandomColor.next());
  //           childrenBoxes.add(b);
  //           currentIndex=childrenBoxes.length-1;
  //           setBounds();
  //             childrenBoxes.last.fitSpace(shrink:0.75);
  //              print("CHILD LOCATION");
  //              childrenBoxes.last.loc.prnt();


//  GuiBox b= GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y),color: RandomColor.next());
//                   childrenBoxes.add(b); 
//                   currentIndex=childrenBoxes.length-1;
//                   setBounds();
//                   childrenBoxes.last.fitSpace(shrink:0.75);