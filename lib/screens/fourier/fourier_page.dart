


import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/screens/fourier/fourier_lines.dart';
import 'package:cshannon3/screens/fourier/text_data.dart';
import 'package:cshannon3/screens/fourier/wave_data.dart';
import 'package:cshannon3/screens/fourier/waves.dart';
import 'package:cshannon3/state_manager.dart';
import 'package:flutter/material.dart';
//130 

class Fourier2 extends StatefulWidget {
  final StateManager stateManager;

  const Fourier2(this.stateManager);
  @override
  _Fourier2State createState() => _Fourier2State();
}

class _Fourier2State extends State<Fourier2> {

  List<WaveVa> notes = noteData;
  ComboWave comboWave;
  Rect mainBox;

  @override
  void initState() {
    super.initState();
    mainBox=widget.stateManager.sc.mainArea();
   
    comboWave = ComboWave(
       totalProgressPerCall: -4, // percent of circle progressed per call
        waveColor: Colors.green,
        waves: [],
        width: mainBox.width/2,
        centerNode: Offset(mainBox.center.dx, mainBox.center.dy-mainBox.height/2-mainBox.top),
        maxLength: mainBox.height/6,
        maxTraceHeight: mainBox.height/8
        
        );
        notes.forEach((n)=>n.init());
    refresh();
    
  }
  play(){
    notes.where((n)=>n.isActive).forEach((n)=>n.audio?.play());
  }

refresh(){
    
    comboWave.reset();
    notes.forEach((n){

      if(n.isActive){
        n.audio?.setVolume(100*n.amp);
        comboWave.waves.add(n.toWave());
      }
    });
    setState(() { });
}
  @override
  void dispose() {
   
      notes.forEach((note)=>note.audio?.dispose());
    super.dispose();
  }
  
  List<Widget> _buildKeys2(double height) {
    List<Widget> keysWidgets = [];
    notes.forEach((note){
       keysWidgets.add(_buildKey2(note, height));
    });

    return keysWidgets;
    // 49 C#/ 51 D#/ 54 F#/ 56 G#/ 58 A#/ //61 / 63/ 66/ 68/ 70
  }
 
  Widget _buildKey2(WaveVa note, double height) {
    return 
       Container(
         height: height,
          width: 50.0,
            decoration: BoxDecoration(

              color:note.isSharp ? Colors.black : Colors.white,
              border: Border(
                left: BorderSide(color: Colors.white24, width: 1.0),
                right: BorderSide(color: Colors.white24, width: 1.0),
                bottom: BorderSide(color: Colors.white24, width: 1.0),
              )
          ),
         child: new Container(
           color: note.isActive?note.color.withOpacity(0.5):null,
          
          //color: (keyname.contains("sharp")) ? Colors.black : Colors.white10,
        
          padding: EdgeInsets.all(1.0),
          child: Column(
            children: <Widget>[
                 Text(
                   note.keyName,
                  style: TextStyle(
                    color: note.isSharp ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child:!note.isActive?Container():
                  ListView(children: List.generate(5,((i){
                     return Padding(
                  padding:  EdgeInsets.symmetric(vertical:.0),
                  child: Container(
                    height: 15.0,
                    child: FlatButton(
                      onPressed: (){

                        note.amp=(1-i/5);//?note.amp=(1-2*i/5):note.amp=0.9;
                      setState(() {
                        refresh();
                      });},
                      child:  Container(color: note.amp>=(1-i/5)?Colors.red:Colors.grey,),
                    ),
                  ),
                );
                  })
                  ))),
               IconButton(icon: Icon( Icons.fiber_manual_record,color:note.isActive?Colors.red:Colors.grey ,),
              onPressed: (){
                setState(() {
                  note.isActive=!note.isActive;
                  refresh();
                });
              },),
          //  )
            ],
          ),
    ),
       );
  }
  Widget sideBar(){
     return Container(
       decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
             ),
       child: ListView(
                    children: <Widget>[
                  Container(
                    height: 160,
                    width: double.infinity,
                    child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/7/72/Fourier_transform_time_and_frequency_domains_%28small%29.gif"),
                  ),
                  ExpansionTile(
                    title: Text("Resources"),
                    children: [Container(
                     // height: 200,
                      width: double.infinity,
                      child: Center(
                        child: toRichText({
                          "token": "#",
                          "fontSize": 18,
                          "text":resources }),
                      ),
                    ),]
                  ),
                  ExpansionTile(
                    title: Text("Seeing Music"),
                    children: [Container(
                     // height: 200,
                      width: double.infinity,
                      child: Center(
                        child: toRichText({
                          "token": "#",
                          "fontSize": 18,
                          "text":explanation }),
                      ),
                    ),]
                  ),
                  // ExpansionTile(
                  //   title: Text("Why Do We Like It?"),
                  //   children: [Container(
                  //    // height: 200,
                  //     width: double.infinity,
                  //     child: Center(
                  //       child: toRichText({
                  //         "token": "#",
                  //         "fontSize": 18,
                  //         "text":resources }),
                  //     ),
                  //   ),
                  //   ]),
                ]),
     );
  }

  Widget mobileLayout(Size size){
    comboWave.centerNode=Offset(size.width/2, size.height/4);
    return ListView(children: <Widget>[
                Container(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/7/72/Fourier_transform_time_and_frequency_domains_%28small%29.gif"),
                ),
                ExpansionTile(
                  title: Text("Resources"),
                  children: [Container(
                   // height: 200,
                    width: double.infinity,
                    child: Center(
                      child: toRichText({
                        "token": "#",
                        "color":"white",
                        "fontSize": 18,
                        "text":resources }),
                    ),
                  ),]
                ),
                ExpansionTile(
                    title: Text("Seeing Music"),
                    children: [Container(
                     // height: 200,
                      width: double.infinity,
                      child: Center(
                        child: toRichText({
                          "token": "#",
                          "color":"white",
                          "fontSize": 18,
                          "text":explanation }),
                      ),
                    ),]
                  ),
               
     Container(
       height: 150.0,
              color: Colors.white.withOpacity(0.5),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildKeys2(size.height/5),
                  ), // ListView
            ),
      
       Row(
         children: <Widget>[
            IconButton(icon: Icon(comboWave.paused? Icons.play_arrow:Icons.pause),onPressed: (){comboWave.paused=!comboWave.paused; setState(() {
          
           });
           },
           ),
           Expanded(
             child: Slider(
               min: 0.0,
               max: 20.0,
               divisions: 10,
               onChanged: (newVal){
                 comboWave.totalProgressPerCall=-newVal;
                 refresh();
                 setState(() {
                 });
               },
               value: -comboWave.totalProgressPerCall,

             ),),
             RaisedButton(
        child: Text("Play"),
        onPressed: (){
         play();
      },)
         ],
       ),
      Container(
        height: 400.0,
        child: FourierLines(comboWave)
        ),
        Container(
        height: 200.0,
        ),
    ],);
    

  }
  Widget desktopLayout(Size size){
    comboWave.centerNode=Offset(size.width/4, size.height/4);
    return Stack(children: <Widget>[
      Positioned(top: 0.0,left: 0.0,width: size.width/3,height: size.height,
      child: Container(
        height: size.height,
        width: size.width/3,
        child: sideBar())),
     
      Positioned(top: 0.0,left: size.width/3,width: 2*size.width/3,height: size.height/5,
     
      child: Container(
              color: Colors.white.withOpacity(0.5),
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildKeys2(size.height/5),
                  ), // ListView
            ),
      ),
      
      Positioned(top: size.height/5,left: size.width/3,width: 2*size.width/3,height: 4*size.height/5,
      child: FourierLines(comboWave)
      ),
       Positioned(top: size.height/5,left: size.width/3,width: 3*size.width/5,height: size.height/8,
       child:Row(
         children: <Widget>[
            IconButton(icon: Icon(comboWave.paused? Icons.play_arrow:Icons.pause),onPressed: (){comboWave.paused=!comboWave.paused; setState(() {
             
           });
           },
           ),
           Expanded(
             child: Slider(
               min: 0.0,
               max: 20.0,
               divisions: 10,
               onChanged: (newVal){
                 comboWave.totalProgressPerCall=-newVal;
                 refresh();
                 setState(() {
                   
                 });
               },
               value: -comboWave.totalProgressPerCall,

             ),
             
           ),
          
         ],
       )),
 Align(alignment: Alignment.topRight,child: RaisedButton(
        child: Text("Play"),
        onPressed: (){
         play();
      },)),
    ],);
    

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.stateManager.sc.mobile?mobileLayout(size):desktopLayout(size);
  }
}

 // ExpansionTile(
                //   title: Text("What is Music?"),
                //   children: [Container(
                //    // height: 200,
                //     width: double.infinity,
                //     child: Center(
                //       child: toRichText({
                //         "token": "#",
                //         "fontSize": 18,
                //         "text":resources }),
                //     ),
                //   ),]
                // ),
                // ExpansionTile(
                //   title: Text("Why Do We Like It?"),
                //   children: [Container(
                //    // height: 200,
                //     width: double.infinity,
                //     child: Center(
                //       child: toRichText({
                //         "token": "#",
                //         "fontSize": 18,
                //         "text":resources }),
                //     ),
                //   ),
                //   ]),

  // double line1Len = 120.0;

  // int inputnumber = 0;
  // bool startedPlaying = false;
  // bool ready=false;
      // String a = "assets/audio/piano_$l.mp3";
      // pl[k]=AudioPlayerController.asset(a);
      // pl[k].initialize();
   // });
// Widget sideBar(Size size){
//      return Container(
//               width: size.width / 3,
//               height: size.height,
//               color: Colors.white.withOpacity(0.3),
//               child: ListView(
//                   children: <Widget>[
//                 Container(
//                   height: 160,
//                   width: double.infinity,
//                   child: Image.network(
//                       "https://upload.wikimedia.org/wikipedia/commons/7/72/Fourier_transform_time_and_frequency_domains_%28small%29.gif"),
//                 ),
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   child: Center(
//                     child: toRichText({
//                       "token": "#",
//                       "fontSize": 18,
//                       "text": '''Resources:
//   -#linkhttps://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/#Interactive Guide to Fourier Transforms#/color##/link#
//   -#linkhttp://www.jezzamon.com/fourier/index.html##colorblue#An Interactive Introduction to Fourier Transforms#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=ds0cmAV-Yek##colorblue#Smarter Every Day Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=r6sGWTCMz2k##colorblue#3blue1brown Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=spUNpyF58BY##colorblue#3blue1brown Video 2#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=Mm2eYfj0SgA##colorblue#Coding Train Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=r18Gi8lSkfM##colorblue#Eugene Physics Video#/color##/link#
//   '''
//                     }),
//                   ),
//                 ),
//               ]..addAll(List.generate(
//                       waveControllers.length,
//                       (i) => waveControllers[i].makeRow(
//                           //setState: () => setState(() {}),
//                           height: 80.0,
//                           width: size.width / 3)))));
//   }
  



// List<int> activeKeys=[52, 55, 58];
// List<double> activeVOl=[0.3, 0.3, 0.4];
//   Map<int, double> keys = {
//     52:1.0,
//     53:1.066,
//     54:1.129,
//     55:1.19,
//     56:1.26,
//     57:1.34,
//     58:1.42,
//     59:1.5,
//     60:1.597,
//     61:1.69,
//     62:1.79,
//     63:1.89,
//     64:2,
//   };

  // [
  //     [1.0, 1.0],
  //     [2.0, 0.5],
  //     [3.0, 0.33],
  //     [4.0, 0.25],
  //     [5.0, 0.2]
  //   ].forEach((initVals) {
  //     print(initVals);
  //     waveControllers.add(WaveController(initVals[0], initVals[1],refresh ));
  //   });
  // List<WaveInfo> _toWaveVals() {
  //   List<WaveInfo> out = [];
  //   waveControllers.forEach((w) {
  //     out.add(w.toWaveInfo());
  //   });
  //   return out;
  // }
  
      //  fourierLines.lines.add(LineSegment2d(length:line1Len*waveControllers[i].amp, node: i, freqMultiplier: waveControllers[i].freq, lineColor:col[i], connectionNode: i-1));
          //CustomModel.fromLib2("line2d_length_${line1Len * waveControllers[i].amp}_node_${i}_freqMult_${waveControllers[i].freq}_color_${col[i]}_conNode_${i - 1}"));

 //fourierLines.lines.add(LineSegment2d(length:line1Len*waveControllers[0].amp, node: 0, freqMultiplier: waveControllers[0].freq, lineColor:col[0]));
        // CustomModel.fromLib2( "line2d_length_${line1Len * waveControllers[0].amp}_node_0_root_freqMult_${waveControllers[0].freq}_color_${col[0]}"));
      
    // CustomModel.fromLib2({
    //   "name": "fourierLines",
    //   "vars": {
    //     "stepPerUpdate": 2.5,
    //     "thickness": 20.0,
    //   }
    // });

  // Container()
              //             Stack(
              // children:<Widget>[
              //   FourierLines(
              //     child: CustomPaint(
              //       painter:
              //       FourierPainter(self:),
              //       child: Container(
              //         height: h,
              //         width: w,
              //       ),
              //     ),
              //   ),
              //  ],
              // ),

    //for(int i=0; i<activeKeys.length;i++) {
      //waveControllers.add(WaveController(keys[activeKeys[i]], activeVOl[i],refresh ));
    //}

      // if(pl.containsKey(keyname)){
        //   if(pl[keyname].value.isPlaying){
        //     print("playing");
        //     pl[keyname].pause();
        //     pl[keyname].seekTo(Duration());
        //   }
        //   pl[keynam].play();
        //   if(activeKeys.length>=5)activeKeys.removeAt(0);
        //   activeKeys.add(keyname);

        

     //   }

      //  [
      //           Padding(
      //             padding:  EdgeInsets.symmetric(vertical:.0),
      //             child: Container(
      //               height: 15.0,
      //               child: FlatButton(
      //                 onPressed: (){note.amp>0.8?note.amp=0.7:note.amp=0.9;
      //                 setState(() {
      //                   refresh();
      //                 });},
      //                 child:  Container(color: note.amp>0.8?Colors.red:Colors.grey,),
      //               ),
      //             ),
      //           ),
                
      //            Padding(
      //              padding:  EdgeInsets.symmetric(vertical:2.0),
      //              child: Container(
      //               height: 15.0,
      //               child: FlatButton(
      //                 onPressed: (){note.amp>0.6?note.amp=0.5:note.amp=0.7;
      //                 setState(() {
      //                   refresh();
      //                 });},
      //                 child:  Container(color: note.amp>0.6?Colors.red:Colors.grey,),
      //               ),
      //           ),
      //            ),
      //            Padding(
      //             padding:  EdgeInsets.symmetric(vertical:2.0),
      //              child: Container(
      //               height: 15.0,
      //               child: FlatButton(
      //                 onPressed: (){note.amp>0.4?note.amp=0.3:note.amp=0.5;
      //                 setState(() {
      //                   refresh();
      //                 });},
      //                 child:  Container(color: note.amp>0.4?Colors.red:Colors.grey,),
      //               ),
      //           ),
      //            ),
      //            Padding(
      //              padding:  EdgeInsets.symmetric(vertical:2.0),
      //              child: Container(
      //               height: 15.0,
      //               child: FlatButton(
      //                 onPressed: (){note.amp>0.2?note.amp=0.1:note.amp=0.3;
      //                 setState(() {
      //                   refresh();
      //                 });},
      //                 child:  Container(color: note.amp>0.2?Colors.red:Colors.grey,),
      //               ),
      //           ),
      //            ),]