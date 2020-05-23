import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/theming.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjTile extends StatefulWidget {
  final Size projSize;
  final CustomModel data;
  final bool isMobile;
  final Function() onChange;

  const ProjTile({Key key,
   this.projSize,
    this.data, 
    this.onChange,
     this.isMobile=false
     }) : super(key: key);
  @override
  _ProjTileState createState() => _ProjTileState();
}

class _ProjTileState extends State<ProjTile> {
  
  Widget gitHubButton(String githubUrl) => (githubUrl==null)?null:
       matbutton("Github", () => launch(githubUrl));

  Widget demoButton(Function onpress) => matbutton("Demo", onpress);

  Widget matbutton(String name, Function onPress) {
    return MaterialButton(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      onPressed: onPress,
      child: Text(
        name,
        style:projBut
      //   TextStyle( color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }
  Widget mobileLayout(Size s){
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       color: Colors.white.withOpacity(0.7),
       child: ExpansionTile(  
                  // subtitle:,
                   children:[
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: toRichText({
                                        "text":ifIs(widget.data.vars, "description")??"",
                                        "token":"#",
                                        "fontSize":20.0
                                      }),
                     ),   
                   ],
         title: Container(
           height: 220.0,
           child: Column(
             children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  child: ClipRRect(
                              borderRadius: new BorderRadius.circular(15.0),
                              child: widget.data.vars["imgUrl"].contains("http")
                              ? Image.network(
                                widget.data.vars["imgUrl"],
                               height: 150.0,
                                width: 150.0,
                                fit: BoxFit.fitHeight,
                              ):Image.asset(
                                widget.data.vars["imgUrl"],
                                height:150.0,
                                width: 150.0,
                                fit: BoxFit.fitHeight,
                              ),
                            
                          ),
                ),
               
               Expanded(
               
                 child: Row(
                   children: <Widget>[
                     Expanded(
                       child: Center(
                            child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                 
                                          child:  Text(widget.data.vars["name"],
                                                textAlign: TextAlign.center,
                                                style: projTitle
                                                ),

                                      )),
                     ),
                      (ifIs(widget.data.vars, "githubUrl")!=null)? IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.github), 
       tooltip: "github code",
      onPressed: () { 
        launch(widget.data.vars["githubUrl"]);
       }
     ):Container(),
     widget.data.vars["demoPath"]==null ?Container():IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(Icons.exit_to_app), 
       tooltip: "demo",
      onPressed: () { 
        widget.onChange();
       }
     ),
                   ],
                 ),
               ),
             
             ],
           ),
         ),
                      
                  
                 
       ),
     ),
   );
  }
  Widget mobileLayout2(){
   return Center(
        child: Container(
          height: widget.projSize.height,
          width: widget.projSize.width,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Colors.black, width: 3.0)),
          child: Column(
            children: <Widget>[
              Container(
                width:widget.projSize.width,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(15.0),
                  child: widget.data.vars["imgUrl"].contains("http")
                  ? Image.network(
                    widget.data.vars["imgUrl"],
                    height: widget.projSize.height/2,
                    width: widget.projSize.width,
                    fit: BoxFit.cover,
                  ):Image.asset(
                    widget.data.vars["imgUrl"],
                    height: widget.projSize.height/2,
                    width: widget.projSize.width,
                    fit: BoxFit.cover,
                  )
                  ,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(widget.data.vars["name"],
                        textAlign: TextAlign.center,
                        style: projTitle
                        ),
                    Container(
                      height: 30.0,
                      width:widget.projSize.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child:gitHubButton(ifIs(widget.data.vars, "githubUrl"))

                          ),
                          Container(
                              child: widget.data.vars["demoPath"]==null ?null: demoButton(widget.onChange),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: <Widget>[
                            toRichText({
                                "text":ifIs(widget.data.vars, "description")??"",
                                "token":"#",
                                "fontSize":20.0
                              }),


                        //  Text(ifIs(widget.data.vars, "description")??"", style: projDes,)
                        ],
                      ),
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  Widget desktopLayout(Size s){
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       color: Colors.white.withOpacity(0.7),
       child: ExpansionTile(
     
                       
                  // subtitle:,
                   children:[
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: toRichText({
                                        "text":ifIs(widget.data.vars, "description")??"",
                                        "token":"#",
                                        "fontSize":20.0
                                      }),
                     ),   
                   ],
         title: Container(
           height: 150.0,
           child: Row(
             children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  child: ClipRRect(
                              borderRadius: new BorderRadius.circular(15.0),
                              child: widget.data.vars["imgUrl"].contains("http")
                              ? Image.network(
                                widget.data.vars["imgUrl"],
                               height: 150.0,
                                width: 150.0,
                                fit: BoxFit.fitHeight,
                              ):Image.asset(
                                widget.data.vars["imgUrl"],
                                height:150.0,
                                width: 150.0,
                                fit: BoxFit.fitHeight,
                              ),
                            
                          ),
                ),
               
               Expanded(
               
                 child: Center(
                      child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                           
                                    child:  Text(widget.data.vars["name"],
                                          textAlign: TextAlign.center,
                                          style: projTitle
                                          ),

                                )),
               ),
              (ifIs(widget.data.vars, "githubUrl")!=null)? IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.github), 
       tooltip: "github code",
      onPressed: () { 
        launch(widget.data.vars["githubUrl"]);
       }
     ):Container(),
     widget.data.vars["demoPath"]==null ?Container():IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(Icons.exit_to_app), 
       tooltip: "demo",
      onPressed: () { 
        widget.onChange();
       }
     ),
             ],
           ),
         ),
                      
                  
                 
       ),
     ),
   );
  }
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return widget.isMobile?
    mobileLayout(s)
    : desktopLayout(s);
  }
}


                                      // Padding(
                                      //   padding: const EdgeInsets.only(top:8.0),
                                      //   child: Container(
                                      //     height: 30.0,
                                      //     width:widget.projSize.width,
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.end,
                                      //       children: <Widget>[
                                      //         Container(
                                      //           child:gitHubButton(ifIs(widget.data.vars, "githubUrl"))

                                      //         ),
                                      //         Container(
                                      //             child:  widget.data.vars["demoPath"]==null ?null:demoButton(widget.onChange),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // Expanded(child: Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: ListView(
                                      //     children: <Widget>[
                                      //       Center(child: 
                                      //       toRichText({
                                      //         "text":ifIs(widget.data.vars, "description")??"",
                                      //         "token":"#",
                                      //         "fontSize":20.0
                                      //       })
                                            
                                      //      // Text(ifIs(widget.data.vars, "description")??"", style: projDes,)
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),)
                               //     ],
                                //  ),


// Widget desktopLayout(){
//    return ExpansionTile(
//      backgroundColor: Colors.white.withOpacity(0.9),
//      leading: ,
//      title: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top:5.0,bottom:5.0),
//             child: Container(
//               height: widget.projSize.height,
//               width: widget.projSize.width,
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                   border: Border.all(color: Colors.black, width: 3.0)),
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     width:widget.projSize.height,
//                     child: ClipRRect(
//                       borderRadius: new BorderRadius.circular(15.0),
//                       child: widget.data.vars["imgUrl"].contains("http")
//                       ? Image.network(
//                         widget.data.vars["imgUrl"],
//                         height: widget.projSize.height,
//                         width: widget.projSize.height,
//                         fit: BoxFit.cover,
//                       ):Image.asset(
//                         widget.data.vars["imgUrl"],
//                         height: widget.projSize.height,
//                         width: widget.projSize.height,
//                         fit: BoxFit.cover,
//                       )
//                       ,
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Column(
//                         children: <Widget>[
//                           Text(widget.data.vars["name"],
//                               textAlign: TextAlign.center,
//                               style: projTitle
//                               ),
//                           Padding(
//                             padding: const EdgeInsets.only(top:8.0),
//                             child: Container(
//                               height: 30.0,
//                               width:widget.projSize.width,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: <Widget>[
//                                   Container(
//                                     child:gitHubButton(ifIs(widget.data.vars, "githubUrl"))

//                                   ),
//                                   Container(
//                                       child:  widget.data.vars["demoPath"]==null ?null:demoButton(widget.onChange),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ListView(
//                               children: <Widget>[
//                                 Center(child: 
//                                 toRichText({
//                                   "text":ifIs(widget.data.vars, "description")??"",
//                                   "token":"#",
//                                   "fontSize":20.0
//                                 })
                                
//                                // Text(ifIs(widget.data.vars, "description")??"", style: projDes,)
//                                 )
//                               ],
//                             ),
//                           ),)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//    );
//   }

  // Widget mobileLayout(){
  //  return Center(
  //       child: Container(
  //         height: widget.projSize.height,
  //         width: widget.projSize.width,
  //         decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.9),
  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //             border: Border.all(color: Colors.black, width: 3.0)),
  //         child: Column(
  //           children: <Widget>[
  //             Container(
  //               width:widget.projSize.width,
  //               child: ClipRRect(
  //                 borderRadius: new BorderRadius.circular(15.0),
  //                 child: widget.data.vars["imgUrl"].contains("http")
  //                 ? Image.network(
  //                   widget.data.vars["imgUrl"],
  //                   height: widget.projSize.height/2,
  //                   width: widget.projSize.width,
  //                   fit: BoxFit.cover,
  //                 ):Image.asset(
  //                   widget.data.vars["imgUrl"],
  //                   height: widget.projSize.height/2,
  //                   width: widget.projSize.width,
  //                   fit: BoxFit.cover,
  //                 )
  //                 ,
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 children: <Widget>[
  //                   Text(widget.data.vars["name"],
  //                       textAlign: TextAlign.center,
  //                       style: projTitle
  //                       ),
  //                   Container(
  //                     height: 30.0,
  //                     width:widget.projSize.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: <Widget>[
  //                         Container(
  //                           child:gitHubButton(ifIs(widget.data.vars, "githubUrl"))

  //                         ),
  //                         Container(
  //                             child: widget.data.vars["demoPath"]==null ?null: demoButton(widget.onChange),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Expanded(child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ListView(
  //                       children: <Widget>[
  //                           toRichText({
  //                               "text":ifIs(widget.data.vars, "description")??"",
  //                               "token":"#",
  //                               "fontSize":20.0
  //                             }),


  //                       //  Text(ifIs(widget.data.vars, "description")??"", style: projDes,)
  //                       ],
  //                     ),
  //                   ),)
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }