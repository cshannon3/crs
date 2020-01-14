


import 'dart:math';

class LRTB{
   double left;
   double right;
   double top;
   double bottom;
   LRTB(this.left, this.right, this.top, this.bottom);
   void prnt(){
     print("left: $left, right:$right, top: $top, bottom: $bottom");
   }
   double toW(double screenWidth)=>(right-left)*screenWidth;
   double toH(double screenHeight)=>(bottom-top)*screenHeight;


   bool isWithin(Point clickLocation)=>
     (clickLocation.x > left &&
        clickLocation.x < right &&
        clickLocation.y > top &&
        clickLocation.y< bottom); 

    Point rescale(Point clickLocation){
      Point p=Point(
        (clickLocation.x-left)/(right-left),
        (clickLocation.y-top)/(bottom-top), );
       // print("click");
      //  prit(clickLocation);

       // prin(p);
        return p;
    }
    shrink(double pct){
      var w = (1-pct)*(right-left)/2;
      var h = (1-pct)*(bottom-top)/2;
      
      right=right-w;
      left=left+w;
      bottom=bottom-h;
      top=top+h;

    }
    
    LRTB updateBounds(LRTB neighborBox, LRTB currentBounds){
      // neighbor on left side
     // currentBounds.prnt();
     // neighborBox.prnt();
      if(onEdge(neighborBox))return currentBounds;
      LRTB newBounds = currentBounds;

      // neighbor box could either be on the edge ,no bound, on left right top or bottom
      if(neighborBox.right<left && neighborBox.right>currentBounds.left)
        newBounds.left=neighborBox.right;
      
      // neighbor On Righ side
      else if (neighborBox.left>right && neighborBox.left<currentBounds.right)
        newBounds.right=neighborBox.left;
      
      else if(neighborBox.bottom<top && neighborBox.bottom >currentBounds.top)
        newBounds.top=neighborBox.bottom;
      
      else if(neighborBox.top>bottom && neighborBox.top<currentBounds.bottom)
        newBounds.bottom = neighborBox.top;
    //  newBounds.prnt();
      return newBounds;
    }

   
    bool onEdge(LRTB neighborBox){
      if((neighborBox.bottom<top ||neighborBox.top>bottom) &&(neighborBox.left>right || neighborBox.right<left))return true;
      //if((neighborBox.top>bottom) &&(neighborBox.left>right || neighborBox.right<left))return true;
      return false;
    }
 }







  //Widget _child;
  // passedInChild=false;
  // if (childCall!=null)passedInChild=true;
  //   passedInChild=true;
  // child= Container(color:Colors.amber,child: newChild);
  // }
  // else if(childCall){
  // //else {//if(childrenBoxes.isNotEmpty){
  //   child = (childrenBoxes.isNotEmpty)?toStack(s, refresh: refresh):Text("Hello");
  // }

  // else {
  //   print(child.toString());// =="WebView")
  //   child=WebView(
  //     initialUrl: 'https://flutter.dev',
  //   );
  // }
     // if(!guiActive)return true;
     // activeClickLocation=clickLocation;
  // String toStr(){
  //    return '''
  //    fitted(l:${left}_r:${right}_t${top}_b$bottom)~@child
  //    ''';
  //  }
  //  Widget toPositioned(Size screenSize, Widget child){
  //    return Positioned(
  //      left: left*screenSize.width,
  //      width: (right-left)*screenSize.width,
  //      top: top*screenSize.height,
  //      height: (bottom-top)*screenSize.height,
  //      child: Container(
  //        height: (bottom-top)*screenSize.width,
  //        width: (right-left)*screenSize.width,
  //        color: Colors.blue,child: Text("Hello"),
  //        ),
  //    );
  //  }

        //   (childrenBoxes.isNotEmpty)?SizedBox.fromSize(
      //     size: s,
      //    child: Container(color:Colors.orange,child: toStack(s))):
      //  newChild??Container(
      //    color: Colors.blue,child: Text("Hello"),
      //    ),
    // );
  // }
    //loc.toPositioned(screenSize,Container(color: Colors.blue,child: Text("Add Child"),));


    
    //if(childrenBoxes!=null)return Container();
    //if(newChild!=null)child=newChild;
    //if(child!=null)return loc.toPositioned(screenSize, child);

   // return 
  //}
  
         //  Align(alignment: Alignment.topRight,child: IconButton(icon: Icon(Icons.blur_circular,color: Colors.green,),onPressed: (){},),),
           