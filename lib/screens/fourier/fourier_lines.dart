

import 'dart:async';
import 'package:cshannon3/screens/fourier/trace_painter.dart';
import 'package:cshannon3/screens/fourier/waves.dart';
import 'package:flutter/material.dart';

class FourierLines extends StatefulWidget {
 // Lines fourierLines;
  ComboWave comboWave;

  FourierLines( this.comboWave,);
  @override
  _FourierLinesState createState() => _FourierLinesState();
}

class _FourierLinesState extends State<FourierLines> {
  Timer _timer;
  Stopwatch stopwatch = Stopwatch();
  ComboWave comboWave;
   double padding=20.0;
   


  @override
  void initState() {
    super.initState();
    _timer?.cancel(); // cancel old timer if it exists
    comboWave = widget.comboWave;
    //print(comboWave.waves)
       _timer = Timer.periodic(
        Duration(milliseconds: 20), _update);
  }
   _update(Timer t) {
    comboWave.update();
    setState(() {});
  }


  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              CustomPaint(
                  painter: FourierPainter(self: widget.comboWave),
                  child: Container(
                    height:s.height,
                    width:s.width,
                    //color: Colors.blue,
                  )),

                  
            ]..addAll(comboWidget()),
          ),
        ),
        Expanded(child: Stack(children: traces()), ),
      ],
    );
  }

Widget traceWidget(List trace, Color waveColor){
  return Container(
        padding: EdgeInsets.only(right:padding),
        width: double.infinity,
        height: double.infinity,
        // color: widget.backgroundColor,
        child: ClipRect(
          child: CustomPaint(
            painter: TracePainter(
                dataSet: trace,
                traceColor: waveColor??Colors.green,
                ),
          ),
        ),
      );
}
  List<Widget> traces(){
    List<Widget> out=[];
    if(comboWave!=null){
    out.add(traceWidget(comboWave.trace, comboWave.waveColor));
    comboWave.waves.forEach((w){
      if(w.isShown)
        out.add(traceWidget(w.trace, w.waveColor));
    });
    }
    return out;    
  }
  List<Widget> comboWidget(){
    return [
 
                    //   Center(
                    //    child:
                         Transform(
                          transform: Matrix4.translationValues(
                            // radius *
                              comboWave.selfNode.dx,
                             // -radius * 
                              comboWave.selfNode.dy,
                              0.0)
                            ..rotateZ(
                              comboWave.rot,
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                //shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          
                      ),
                       
                      ]..addAll(List.generate((comboWave.waves.length) ,(wavenum){
                        return 
                        Transform(
                          transform: Matrix4.translationValues(
                           //   radius * 
                              comboWave.waves[wavenum].selfNode.dx,
                            //  -radius * 
                              comboWave.waves[wavenum].selfNode.dy,
                              0.0)
                            ..rotateZ(
                              comboWave.waves[wavenum].rot,
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: //Colors.black
                               comboWave.waves[wavenum].waveColor,
                                //shape: BoxShape.circle,
                              ),
                            ),
                          ),
                       // ),
                      );
                      }
                      )..add( Positioned(
                          right:70.0,
                          width:50.0,
                          height: 900.0,
                          top:50.0,
                          child:
                         Padding(
                            padding: const EdgeInsets.only(right:20.0, top:50.0),
                            child: Container(
                              width: 50.0,
                              height: double.infinity,
                              color: Colors.blue,
                              child: ListView(
                                children:List.generate((comboWave.waves.length) ,(wavenum){
                        return
                        Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    comboWave.waves[wavenum].isShown=!comboWave.waves[wavenum].isShown;
                                  });
                                  
                                },
                                child: Container(
                                      height: 10.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color:comboWave.waves[wavenum].isShown?
                                       comboWave.waves[wavenum].waveColor:comboWave.waves[wavenum].waveColor.withOpacity(0.5),
                                      
                                      ),
                      ),
                              ),
                        );
                                })
                              
                              ),
                            ),
                          )))
                      );          
  }
}



    //  Center(child: 
    //                     FractionalTranslation(
    //                       translation: Offset(-0.25, -0.75),
    //                       child: Container(
    //                         height: 20.0,
    //                         width: 20.0,
    //                         decoration: BoxDecoration(
    //                             color: Colors.grey,
    //                             shape: BoxShape.circle,
    //                             border: Border.all(color: Colors.white)
    //                             //shape: BoxShape.circle,
    //                             ),
    //                       ),
    //                     ),
    //                   ),
    //                   Positioned(
    //                     left: 10.0,
    //                     top: (MediaQuery.of(context).size.height / 4) - 25.0,
    //                     child: Container(
    //                       width: MediaQuery.of(context).size.width,
    //                       height: 1.0,
    //                       color: Colors.orange,
    //                     ),
    //                   ),