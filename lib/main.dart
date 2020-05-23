/*
Main features - ui layout mode for when editing
Once editing is done you can 'freeze' to data which saves app in data that can be instantly parsed by the app itself,
allowing for 'no-code' updates to apps and websites
or 'freeze' into code which you can then copy and past into a dart file


To be able to do this, first in and out of gui mode,


*/
/*
Main features - ui layout mode for when editing
Once editing is done you can 'freeze' to data which saves app in data that can be instantly parsed by the app itself,
allowing for 'no-code' updates to apps and websites
or 'freeze' into code which you can then copy and past into a dart file
To be able to do this, first in and out of gui mode,
*/

import 'package:cshannon3/comments/comment_model.dart';
import 'package:cshannon3/comments/comment_overlay.dart';
import 'package:cshannon3/menu.dart';
import 'package:cshannon3/screens/gui2/lrtb.dart';
import 'package:cshannon3/screens/paint/paint_screen.dart';
import 'package:cshannon3/secrets.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;

import 'package:cshannon3/components/animated_list.dart';
import 'package:cshannon3/state_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_sign_in/google_sign_in.dart';

void main() async{

    try {
    fb.initializeApp(
      apiKey: secrets["apiKey"],
    authDomain: secrets["authDomain"],
    databaseURL: secrets["databaseURL"],
    projectId: secrets["projectId"],
    storageBucket: secrets["storageBucket"],
    messagingSenderId: secrets["messagingSenderId"],
    appId:  secrets["appId"],
    measurementId:  secrets["measurementId"]
    );

     var db = fb.firestore();
    runApp(MyApp(db));
    
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
  //runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final Firestore db;
  const MyApp(this.db,) ;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      color: Colors.grey,
      debugShowCheckedModeBanner: false,
      home: RootApp(db:db), 
    );
  }
}


class RootApp extends StatefulWidget {
  final Firestore db;

  const RootApp({Key key, this.db}) : super(key: key);
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  StateManager stateManager = StateManager();

bool showFeedback=false;
bool showPaint=false;
  @override
  void initState() {
    super.initState();
      stateManager.addListener(() {
      setState(() {});
    });

    stateManager.initialize(widget.db);
    // stateManager.mainScroll.addListener((){
    //   print(stateManager.mainScroll.offset);
    //   //print(stateManager.mainScroll.position.pixels);
    // });
  }

  commentUpdate(Comment comment){
    print("PP");
  }
  
  Widget commentsWidget(){
 
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
                  stream: widget.db.collection('feedback')
                    .onSnapshotMetadata,
                  builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Text('Loading...');
                          default:
                            return CommentsOverlay(
                              initShowing: showFeedback,
                              comments:snapshot.data.docs.where((doc)=>doc.data()['screen']==stateManager.currentRoute)
                                .map((DocumentSnapshot document) {
                                  print( document.data());
                                  return Comment(
                                    comment:  document.data()['comment'],
                                    commenter: document.data()['commenter'],//stateManager.commenter,
                                    location: LRTB.fromMap(document.data()['location'])
                                  );
                              }).toList(),
                            );
                        }
                    },
                  ),
    );
  }
  @override
  Widget build(BuildContext context) {

    stateManager.setScale(MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(0, 11, 200, 1.0),
                  Color.fromRGBO(0, 0, 200, 0.2)
                ]),),
       // mainBackground,
        child: Stack(
          children: <Widget>[
        
            Positioned.fromRect(
        rect: stateManager.sc.mainArea(),
        child:  stateManager.getScreen(),
        //stateManager.mainPage(),
            ),
       
          MenuBar(
          direc: stateManager.sc.mobile?DIREC.LTR: DIREC.BTT,
          menuSize: stateManager.sc.menu(),
          menuOptions: stateManager.menuOptions,
          menuButton: stateManager.sc.menuButton(),
          menuFontSize: stateManager.sc.getMenuFontSize(),
          changeScreen: stateManager.changeScreen,
        ),
        commentsWidget(),
        showPaint?SizedBox.fromSize(
          size:MediaQuery.of(context).size,
          child: PaintDemo(),
        ):Container(),
            Positioned(
             left: MediaQuery.of(context).size.width-150.0,
             top: 0.0,
             height: 40.0,
             width: 150.0,
              child: Container(
                width: 150.0,
                child: Row(children: <Widget>[
                    IconButton(onPressed: (){
                    setState(() {
                      stateManager.dataController.authorizeGoogleUser();
                        
                        //stateManager.signIn();
                    });
                  },
                  icon: Icon(
                    FontAwesomeIcons.google
                  ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                       showPaint=!showPaint;
                    });
                  },
                  icon: Icon(
                    FontAwesomeIcons.paintBrush
                  ),
                  ),
                IconButton(onPressed: (){     setState(() {
                      showFeedback=!showFeedback;
                    });},
                  icon: Icon(FontAwesomeIcons.comment),
                  ),
                ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Widget commentsO()=>
    
  //      showFeedback? commentsWidget():Container(),
  //      Align(alignment: Alignment.bottomRight,
  //      child: Padding(
  //        padding: const EdgeInsets.all(30.0),
  //        child: IconButton(
  //          color: Colors.white,
  //          icon: Icon(Icons.message, color: Colors.white,),
  //          onPressed: (){
  //            setState(() {
  //              showFeedback=!showFeedback;
  //            });
  //          }
  //          ,
  //        ),
  //      ),);
