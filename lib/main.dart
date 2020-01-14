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
import 'package:cshannon3/screens/paint/paint_screen.dart';
import 'package:cshannon3/secrets.dart';
import 'package:cshannon3/theming.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;

import 'package:cshannon3/components/animated_list.dart';
import 'package:cshannon3/state_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    print(stateManager.currentRoute);
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

                              comments:snapshot.data.docs.where((doc)=>doc.data()['screen']==stateManager.currentRoute)
                                .map((DocumentSnapshot document) {
                                  print( document.data());
                                  return Comment(
                                    comment:  document.data()['comment'],
                                    commenter: document.data()['commenter'],//stateManager.commenter,
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
        decoration: mainBackground,
        child: Stack(
          children: <Widget>[
            Positioned.fromRect(
        rect: stateManager.sc.mainArea(),
        //  
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
      //  commentsWidget(),
        // showPaint?SizedBox.fromSize(
        //   size:MediaQuery.of(context).size,
        //   child: PaintDemo(),
        // ):Container()
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
