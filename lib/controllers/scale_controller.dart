

import 'dart:math';

import 'package:cshannon3/utils/mathish.dart';
import 'package:flutter/material.dart';
enum LAYOUTTYPE{
  MOBILE,
  DESKTOP

}

enum BUB{
  CIRCLE,
  OVAL,
  ZIGZAG
}
class ScaleController extends ChangeNotifier {
  final Size initScreenSize;
   Size _screenSize;
  LAYOUTTYPE layouttype;
  bool mobile=false;

  Rect _menu, _mainArea;
  double paddingLR, paddingTB;
  double scaleX=1.0;
  double scaleY=1.0;
  Size _menuButton;

  Size currentSize()=>_screenSize;

  ScaleController(this.initScreenSize){
      rescale(initScreenSize);

  }


  rescale(Size newSize){
   // if(_screenSize==null ||newSize!=_screenSize){
    _screenSize=newSize;
    if (_screenSize.width<900.0){
      mobile=true;
      paddingLR=15.0;
      paddingTB=10.0;
      layouttype=LAYOUTTYPE.MOBILE;
    }
      else {
      layouttype=LAYOUTTYPE.DESKTOP;
      mobile = false;
       paddingLR=30.0;
      paddingTB=30.0;
    }
    _getMenuRect();
    _getMenuButtonSize();
    _getMainAreaRect();
    scaleX=(initScreenSize.width-_screenSize.width)/initScreenSize.width;
    scaleY=(initScreenSize.height-_screenSize.height)/initScreenSize.height;
    //}
  }

  double h()=>_screenSize.height-(paddingTB*2);
  double w()=>_screenSize.width-(paddingLR*2);
  Rect menu()=>_menu??_getMenuRect();
  Rect mainArea()=>_mainArea??_getMainAreaRect();
  Size menuButton()=>_menuButton??_getMenuButtonSize();



// Fourier Box 
   fourierBox(){
    return Rect.fromLTWH(_mainArea.left, _mainArea.top, _mainArea.width,_mainArea.height);
  }
  Rect _getMenuRect(){
    if (mobile)_menu= Rect.fromLTWH(paddingLR, paddingTB, w(), fromHRange(0.1, low: 30.0, high: 50.0));
    else {
      double ww = fromWRange(0.2, low: 80.0, high: 150.0);
      _menu= Rect.fromLTWH(w()-ww+paddingLR, paddingTB, ww, h());
    }
    return _menu;
  }
  Rect _getMainAreaRect(){
    if (mobile){
      double tb = fromHRange(0.1, low: 30.0, high: 60.0);
      _mainArea= Rect.fromLTWH(paddingLR, tb, w(), h()-tb);
    }
    else _mainArea= Rect.fromLTWH(paddingLR, paddingTB, w()-fromWRange(0.2, low: 80.0, high: 150.0), h());
    return _mainArea;
  }
  Size _getMenuButtonSize(){
    if(mobile){
      _menuButton= Size(fromWRange(0.25, low:70.0, high:150.0), _menu.size.height);
    }else{
      _menuButton=  Size(_menu.size.width, fromWRange(0.1, low:50.0, high:60.0));
    }
    return _menuButton;
  }
  double getMenuFontSize(){
    return 16.0;
  }
  // Gui box
  // LRTB fromPct(double l, double r, double t, double b){
  //   return LRTB(l*_mainArea.width, r*_mainArea.width, t*_mainArea.height, b*_mainArea.height,);
  // }
  Rect projList(){
    if(mobile)
      return Rect.fromLTWH(0.0, _mainArea.height/2, w(),  _mainArea.height/2);
    else
      return Rect.fromLTWH(0.0, _mainArea.height/2, _mainArea.width, fromHRange(0.4, low:150.0, high:250.0));
  }

  Size projectTile(){
    Rect p = projList();
    if(mobile)
      return Size(fromRange(p.width, high:p.height), fromRange(p.width, high:p.height));
    else
      return Size(fromRange(p.height, high:p.width), p.height);
  }


  Rect bubbleBox(){
     if(mobile){
      return Rect.fromCenter(
        center:Offset(_mainArea.center.dx, _mainArea.center.dy-_mainArea.height*0.1),
        width:fromWRange(0.7, low:250, high:400),
        height:fromHRange(0.6, low:300, high:500)
        );
     }else{
      return  Rect.fromCenter(
        center:_mainArea.center,
        width:fromWRange(0.5, low:250, high:400),
        height:fromHRange(0.6, low:400, high:700)
        );
     }
  }
  Rect centerRect(){
   
    Rect bb= bubbleBox();
    double padding=10.0;
    double radius= fromHRange(0.3, low:25.0, high:100);
    return Rect.fromCircle(
      center:Offset(bb.topCenter.dx, bb.topCenter.dy-padding), 
      radius: radius
      );
  }
  Map<int, Rect> getLocations({int nodesShown=8,Rect area,BUB layoutType=BUB.CIRCLE, double radiusFrac=.33, double minR=30.0}){
    area??=_mainArea;
    Map<int, Rect> itemLocs={};
    double centerX = area.center.dx;
    double centerY=(mobile)? area.center.dy: area.center.dy;
    double radiusX=
    (mobile)?
    area.width*radiusFrac: area.width*radiusFrac;
    double radiusY=
    (layoutType==BUB.OVAL)?area.height*radiusFrac*0.8:radiusX;

    double angleBetweenNodes = 400/nodesShown;
    double nodeRadius=fromRange(2*pi*radiusY/(nodesShown), high:radiusX/3, low:minR);
    for(int nodeIndex=0; nodeIndex<nodesShown;nodeIndex++){
      itemLocs[nodeIndex]=Rect.fromCircle(
          center: Offset(
            centerX+radiusX*Z(nodeIndex*angleBetweenNodes), 
            centerY+radiusY*K(nodeIndex*angleBetweenNodes)
            ),
            radius: nodeRadius
            );
    }
    return itemLocs;
  }
  // Essay
  Size header(){
    return Size(_mainArea.width, fromHRange(0.1, low: 50.0, high: 60.0));
  }
  
  double fromHRange(double frac, {double low=0.0, double high, bool only=false}){
    high??=_screenSize.height;
    double out = frac*_screenSize.height;
    return fromRange(out, low:low, high:high, only:only);
  }
  double fromWRange(double frac, {double low=0.0, double high, bool only=false}){
    high??=_screenSize.width;
    double out = frac*_screenSize.width;
    return fromRange(out, low:low, high:high, only:only);
  }

  //double wRangeOnly()
  double fromRange(double out, {double low=0.0, double high, bool only=false} ){
    if(only &&(out>high ||out<low))return 0.0;
    if(out>high)return high;
    if(out<low)return low;
    return out;
  }
}


//   Offset pixelsToCenter(Point pt){

//   }
//  Offset pixelsFromCenter(Point pt){

//   }


 // double fracHIfMore(double frac, double or)=>(screenSize.height*frac>or)?screenSize.height*frac:or;
  // double fracHOnlyIfMore(double frac, double or)=>(screenSize.height*frac>or)?screenSize.height*frac:0.0;
  // double fracWIfMore(double frac, double or)=>(screenSize.width*frac>or)?screenSize.width*frac:or;
  // double wOnlyIfMore(double frac, double or)=>(screenSize.width*frac>or)?screenSize.width*frac:0.0;


   //  _screenSize=initScreenSize;
  //   if (_screenSize.width<900.0){
  //     mobile=true;
  //     paddingLR=15.0;
  //     paddingTB=10.0;
  //     layouttype=LAYOUTTYPE.MOBILE;
  //   }
  //     else {
  //     layouttype=LAYOUTTYPE.DESKTOP;
  //     mobile = false;
  //      paddingLR=30.0;
  //     paddingTB=30.0;
  //   }
  //   _getMenuRect();
  //   _getMainAreaRect();
  //   _getMenuButtonSize();

// Map<int, Rect> getNodeLocations(Rect bubbleLoc, int nodesShown){
//     Map<int, Rect> nodeLocs={};
//     double centerX = bubbleLoc.center.dx;
//     double centerY=bubbleLoc.center.dy;
//     double ringRadius=bubbleLoc.width/3;
//     double angleBetweenNodes = 400/nodesShown;
//     double nodeRadius=fromRange(2*pi*ringRadius/(nodesShown*2), high:ringRadius/2, low:25.0);
//     for(int nodeIndex=0; nodeIndex<nodesShown;nodeIndex++){
//       nodeLocs[nodeIndex]=Rect.fromCircle(
//           center: Offset(
//             centerX+ringRadius*Z(nodeIndex*angleBetweenNodes), 
//             centerY+ringRadius*K(nodeIndex*angleBetweenNodes)
//             ),
//             radius: nodeRadius
//             );
//     }
//     return nodeLocs;
//   }
//   Map<int, Rect> getCategoryLocations(List<CustomModel> categories, {int maxShown= 8}){
    
//     Map<int, Rect> catLocs={};
//     double centerX = _mainArea.center.dx;
//     double centerY=_mainArea.center.dy-_mainArea.height*0.1;
//     double radiusX=_mainArea.width/3;
//     double radiusY=_mainArea.height/3;
//     int len = (categories.length>maxShown)?maxShown:categories.length;
//     double angleBetweenNodes = 400/len;

//     double nodeRadius=(mobile)
//           ? fromRange(2*pi*radiusY/(len*2), high:radiusY/4, low:25.0)
//          : fromRange(2*pi*radiusX/(len*3), high:radiusX/3, low:25.0);
//     for(int nodeIndex=0; nodeIndex<len;nodeIndex++){
//       catLocs[nodeIndex]=Rect.fromCircle(
//           center: Offset(
//             centerX+radiusX*Z(nodeIndex*angleBetweenNodes), 
//             centerY+radiusY*K(nodeIndex*angleBetweenNodes)
//             ),
//             radius: nodeRadius
//             );
//     }
//     return catLocs;
//   }

   //Rect getBubbleLoc(Point pt, double diameter){
//    double x = _mainArea.left+ pt.x*_mainArea.width;
//    double y = _mainArea.top+ pt.y*_mainArea.height;
//     return Rect.fromCircle(center:Offset(x,y), 
//     radius: (mobile)?fromHRange(diameter, low:50.0, high:150.0):fromHRange(diameter, low:80.0, high:200.0)
//     );
//   }
  // List<Rect> getNodeLocations(Rect bubbleLoc, int nodesShown){
  //   List<Rect> nodeLocs=[];
  //   double centerX = bubbleLoc.center.dx;
  //   double centerY=bubbleLoc.center.dy;
  //   double ringRadius=bubbleLoc.width/3;
  //   double angleBetweenNodes = 400/nodesShown;
  //   double nodeRadius=fromRange(2*pi*ringRadius/(nodesShown*2), high:ringRadius/2, low:25.0);
  //   for(int nodeIndex=0; nodeIndex<nodesShown;nodeIndex++){
  //     nodeLocs.add(
  //       Rect.fromCircle(
  //         center: Offset(
  //           centerX+ringRadius*Z(nodeIndex*angleBetweenNodes), 
  //           centerY+ringRadius*K(nodeIndex*angleBetweenNodes)
  //           ),
  //           radius: nodeRadius
  //           ));
  //   }
  //   return nodeLocs;
  // }
  