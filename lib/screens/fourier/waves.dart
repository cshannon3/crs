import 'package:cshannon3/utils/mathish.dart';
import 'package:flutter/material.dart';

class ComboWave {
  List<Wave> waves;
  Wave comboWave;
  double totalProgressPerCall;
  double tickprogress;
  List<double> trace = [];
  Color waveColor;
 double maxLength=150.0;
 double maxTraceHeight=200.0;
  double width=600;
  
  //double stepPerUpdate=2.5; //tryParse(tokens; [stepsPerUpdate; stepPerUpdate;spu])??2.0;
  double thickness= 4.0;
  Offset centerNode=Offset(0.0, 0.0);
  Offset selfNode=Offset(0.0, 0.0);
  double x=0;
  double y=0;
  double rot=0;
  bool paused=false;

  ComboWave({
    @required this.waves,
    this.waveColor = Colors.green,
    this.totalProgressPerCall = 1.0,
    this.tickprogress = 0.0,
    this.centerNode,
    this.width,
    this.maxLength,
    this.maxTraceHeight
  });
  reset(){
    tickprogress=0.0;
    trace=[];
    waves=[];
  }

  update() {
    if(paused)return;
    
   x=0.0;y=0.0;rot=0.0;
    Offset startNode=centerNode;
    waves.forEach((w) {
      startNode=updateWave(w, startNode);
    });
    rot = rot / waves.length;
    tickprogress += totalProgressPerCall;
    trace.add(y*maxTraceHeight);
    if(trace.length>width)trace.removeAt(0);
    selfNode= Offset(centerNode.dx +maxLength*x, centerNode.dy+maxLength*y);
  }
  Offset updateWave(Wave w, Offset startNode){
     w.trace.add(K(w.progress)*w.fractionOfFull*maxTraceHeight);
      if(w.trace.length>width)w.trace.removeAt(0);
      w.updateWave(tickprogress, startNode);//.centerNode, info.maxTraceHeight, info.maxLength
      x+=w.x;y+=w.y;rot+=w.rot;
      w.selfNode=Offset(centerNode.dx+maxLength*w.x, centerNode.dy+maxLength*w.y);
      w.endNodeLocation = Offset(w.nodeLocation.dx + maxLength*w.x, w.nodeLocation.dy + maxLength*w.y);
      return w.endNodeLocation;

  }
}

class Wave {
  // Using my trig so a circle is 4 quadrants of 100% each, full rotation is 400 %
bool isShown=true;
  double progressPerFrame; // Frequency,
  double progress;
  List<double> trace = [];
  final Color waveColor;
  final double fractionOfFull;
 // double width=600.0;
  Offset nodeLocation=Offset(0.0, 0.0);
  Offset endNodeLocation=Offset(0.0, 0.0);
  Offset selfNode=Offset(0.0, 0.0);
  // For the fourier example, length represents both amplitude of the wave and radius of the circle
  double x=0.0; 
  double y=0.0;
  double rot=0.0;
  //WaveVals waveVals;

  Wave({
    this.progressPerFrame = 1.0,
    this.progress = 0.0,
    @required this.waveColor,
    @required this.fractionOfFull,
    this.nodeLocation = const Offset(0.0, 0.0),
  });


  updateWave(double newProgress, Offset startlocation) {//Offset startlocation, Offset center, double traceHeight, double maxLength
   
    progress = progressPerFrame * newProgress ;
    nodeLocation=startlocation;
    y=fractionOfFull*K(progress);
    x= fractionOfFull*Z(progress);
    rot=rad(progress);
    
  }
}


 

  class FourierPainter extends CustomPainter {
  ComboWave self;
  
  FourierPainter({this.self});

  @override
  bool shouldRepaint(FourierPainter oldDelegate) {
    return true;
  }

  void paint(Canvas canvas, Size size) {
    self.waves.forEach((lineNode) {
      Paint p = Paint()
        ..color = lineNode.waveColor
        ..strokeWidth = self.thickness
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(lineNode.nodeLocation,lineNode.endNodeLocation, p);
    });
  }
}





//  @immutable
//  class CollectiveInfo{
//     final double maxLength;
//     final double maxTraceHeight;
//     final double width;
//     final Offset centerNode;
//   CollectiveInfo({this.maxLength, this.maxTraceHeight, this.width, this.centerNode});
//  }


  //   List<Offset> setPosition({Offset startlocation, double stepPerUpdate}) {
  //   if (stepPerUpdate != null) progress += stepPerUpdate * freqMultiplier;
  //   if (startlocation != null) nodeLocation = startlocation;
  //  // double x = nodeLocation.dx + Z(progress) * length;
  //  // double y = nodeLocation.dy + K(progress) * length;
  //   endNodeLocation = Offset(nodeLocation.dx + Z(progress) * length,
  //       nodeLocation.dy + K(progress) * length);
  //   return [nodeLocation, endNodeLocation];


  //  class WaveVal{
  //         double k;
  //         double z;
  //         double rot;
  //         WaveVal(this.k, this.z, this.rot);
  //         zero(){
  //           k=0;z=0;rot=0;
  //         }
  //         add(WaveVal v){
  //           k+=v.k;
  //           z+=v.z;
  //           rot+=v.rot;
  //         }
  //       }
  // class Lines{
//   Lines(this.stepPerUpdate, this.thickness);
//   List<LineSegment2d> lines=[];//tokens.containsKey(lines)?tokens[lines]=[];
//   double stepPerUpdate=2.5; //tryParse(tokens; [stepsPerUpdate; stepPerUpdate;spu])??2.0;
//   double thickness= 4.0;//tryParse(tokens; [thickness; t])??4.0;
//   double xScale=1.0;
//   Color traceColor=Colors.blue;//parseMap[color](tokens)??Colors.blue;
//   var trace=[];
//   bool showYAxis= true; //tokens.containsKey(showYAxis)?tokens[showYAxis]=true;

// }
