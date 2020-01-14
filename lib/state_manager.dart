import 'package:cshannon3/components/animated_list.dart';
import 'package:cshannon3/controllers/data_controller.dart';
import 'package:cshannon3/controllers/scale_controller.dart';
import 'package:cshannon3/screens/home/popup.dart';
import 'package:cshannon3/screens/home/project_tile.dart';
import 'package:cshannon3/screens/home/projects_data.dart';
import 'package:cshannon3/screens/proj.dart';
import 'package:cshannon3/screens/screens.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class StateManager extends ChangeNotifier {
  DataController dataController = DataController();
  String currentRoute = "/";
  String commenter;
  ScrollController mainScroll = ScrollController();
  ScaleController sc;
  bool selected = true;

  Widget currentScreen = Container();

  StateManager();
  Map<String, String> menuOptions = {
    "Home": "/",
    "About Me": "/",
    "Projects": "/",
    "Interests": "/interests",
    "Quotes": "/quotes"
  };
  Map<String, dynamic> dataMap = {
    "projects": {
      "name": "project",
      "collection_name": "projects",
      "models": projects,
    },
    "books": {
      "name": "book",
      "collection_name": "books",
      "models": [],
    },
    "quotes": {
      "name": "quote",
      "collection_name": "quotes",
      "models": [],
    },
    "categories": {
      "name": "category",
      "collection_name": "categories",
      "models": [],
    },
    "sites": {
      "name": "site",
      "collection_name": "sites",
      "models": [],
    },
    "youtube": {
      "name": "youtube",
      "collection_name": "youtube",
      "models": [],
    },
  };

  List<CustomModel> getModels(String key) =>
      (dataMap.containsKey(key) && dataMap[key]["models"].isNotEmpty)
          ? dataMap[key]["models"]
          : [];
  List<CustomModel> getAllModels() {
    List<CustomModel> cm = [];
    cm.addAll(dataMap["projects"]["models"]);
    cm.addAll(dataMap["books"]["models"]);
    cm.addAll(dataMap["sites"]["models"]);
    cm.addAll(dataMap["youtube"]["models"]);

    return cm;
  }

  Future<void> initialize(
    Firestore _db,
  ) async {
    dataController.db = _db;
    await dataController.getFirebaseData("users", "users");
    dataMap.forEach((key, dataInfo) async {
      if (dataMap[key]["models"].isEmpty)
        dataMap[key]["models"] = await dataController.getJsonDataList(
            dataMap[key]["name"], dataMap[key]["collection_name"]);
    });
  }

  Map<String, dynamic> routes = {
    "/": (StateManager m) => new HomePage(m),
    "/fourier": (StateManager m) => new Fourier2(m),
    "/guiboxes": (StateManager m) => new GuiScreen2(m), // MyMainApp(),
    "/paint": (StateManager m) => new PaintDemo(),
    "/quotes": (StateManager m) => new Quotes(m),
    "/interests": (StateManager m) => new Bubbles(m),
  };
  setScale(Size screenSize) {
    if (sc == null)
      sc = ScaleController(screenSize);
    else
      sc.rescale(screenSize);
    notifyListeners();
  }

  Widget getScreen() {
    print(currentRoute);
    if(currentRoute=="/")currentScreen = mainPage();
    else currentScreen = routes[currentRoute](this);
    return currentScreen;
  }
  //List<Widget> getChildren()=>_projects();

  changeScreen(String route) {
    print(route);
    if (routes.containsKey(route)) {
      currentRoute = route;
      notifyListeners();
    }
  }

  Widget mainPage() {
    Size projTile = Size(sc.w(), sc.fromHRange(0.3, low: 150.0));
    //sc.projectTile();
    return Container(
        child: ListView(
            controller: mainScroll,
            children: [
              sc.mobile ? mIntro() : dIntro(),
              Container(
                  height: 80.0,
                  width: double.infinity,
                  child: Center(child: Text("About Me"))),
              Container(
                  height: 80.0,
                  width: double.infinity,
                  child: Center(child: Text("Projects"))),
                       Container(
                           height: 50.0,
                  width: double.infinity,
                         child: Stack(
                           children: <Widget>[
                             CustomAnimatedList(
        onStart: true,
        hasToggleButton: false,
        introDirection: DIREC.LTR,
        //size: s,
        widgetList: languages(),
        lrtb: Rect.fromLTWH(0.0, 0.0, sc.w(),50.0)
    
      ),
                           ],
                         ),
                       ),
            ]..addAll(projects.map((p) {
                return ProjTile(
                    projSize: projTile,
                    data: p,
                    isMobile: sc.mobile,
                    onChange: p.vars.containsKey("demoPath")
                        ? () => changeScreen(p.vars["demoPath"])
                        : null);
              }).toList())));
  }

  Widget mIntro() {
    return Center(
      child: Container(
          height: sc.h() / 3,
          width: sc.h() / 3,
          child: Stack(
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: sc.w() / 2,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/coverphoto2.jpg"),
                ),
              ),
              Center(
                  child: Text(
                "Welcome, I'm Connor Shannon",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ))
            ],
          )),
    );
  }

  Widget dIntro() {
    return Container(
        height: sc.h() / 3,
        width: double.maxFinite,
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                  CircleAvatar(
                radius: 120.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage("assets/coverphoto2.jpg"),
              )),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 30, right: 8.0),
                child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                    Center(
                  child: Text(
                    "Welcome, I'm Connor Shannon",
                    style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                )),
          )
        ]));
  }
  

  List<Widget> languages({List<String> langs}) {
    if (langs == null) langs = ["Dart/Flutter", "C++", "Python", "Ruby", "Engineering", "3D Printing"];
    List<Widget> out = [];
    langs.forEach((lang) {
      out.add(MaterialButton(
        color: Colors.blueGrey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        onPressed: () {},
        child: Text(
          lang,
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
    return out;
  }
}

// Center(
//   child: AnimatedContainer(
//     width: selected ? 200.0 : 100.0,
//     height: selected ? 100.0 : 200.0,
//     color: selected ? Colors.red : Colors.blue,
//     alignment: selected
//         ? Alignment.center
//         : AlignmentDirectional.topCenter,
//     duration: Duration(seconds: 2),
//     curve: Curves.fastOutSlowIn,
//     child:
// List<Widget> _projects(){

//   List<Widget> out=[];
//   projects.forEach((p){
//      out.add(Transform.translate(
//        offset: Offset(),
//        child:
//      ));
//    });
//   return out;
// }

//{
//   List<Widget> out=[];
//  // routes.forEach((r, a){
//    //  print(r);

//     out.add(

//       SizedBox.fromSize(
//         size: sc.mainArea().size,
//         child:a(this)
//       )
//       );
//   });
//   return out;
//}

// class HomePage extends StatelessWidget {
//   final StateManager stateManager;
//   List<CustomModel> projects=[];

//   HomePage(this.stateManager);

//   List<Widget> languages({List<String> langs}) {
//     if (langs == null) langs = ["Dart/Flutter", "C++", "Python", "Ruby"];
//     List<Widget> out = [];
//     langs.forEach((lang) {
//       out.add(MaterialButton(
//         color: Colors.blueGrey.withOpacity(0.4),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20.0))),
//         onPressed: () {},
//         child: Text(
//           lang,
//           style: TextStyle(color: Colors.white),
//         ),
//       ));
//     });
//     return out;
//   }

//   Widget mobileLayout(){
//     return ListView(
//       children: <Widget>[
//          Center(
//            child: Container(
//              height: stateManager.sc.w()/2,
//              width: stateManager.sc.w()/2,
//              child: Stack(
//                children: <Widget>[
//                  CircleAvatar(
//                           radius: stateManager.sc.w()/2,
//                           backgroundColor: Colors.transparent,
//                           backgroundImage: AssetImage("assets/coverphoto2.jpg"),
//                         ),
//                         Center(child: Text("Welcome, I'm Connor Shannon",textAlign: TextAlign.center, style: TextStyle(
//                       fontSize: 25.0,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontStyle: FontStyle.italic),)),
//                ],
//              ),
//            ),
//          ),
//      Padding(
//        padding: const EdgeInsets.symmetric(vertical: 25.0),
//        child: Center(
//                   child: Text(
//                     "Projects",
//                     style: TextStyle(color: Colors.white, fontSize: 25),
//                   ),

//               ),
//      )
//       ]..addAll(
//      _projects()
//       )
//     );

//   }
//   Widget desktopLayout(){
//     return Stack(
//       children: <Widget>[
//         Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
//                     CircleAvatar(
//                   radius: 120.0,
//                   backgroundColor: Colors.transparent,
//                   backgroundImage: AssetImage("assets/coverphoto2.jpg"),
//                 ))
//                 ),
//         Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//                 padding: const EdgeInsets.only(left:8.0, top:30, right:8.0),
//                 child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
//                     Text(
//                   "Welcome, I'm Connor Shannon",
//                   style: TextStyle(
//                       fontSize: 45.0,
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic),
//                 )
//                 )
//                 ),
//         Positioned(
//          left: 30.0,
//          top: stateManager.sc.h()/2-80,
//          height: 50.0,
//          width: 150.0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Projects",
//                 style: TextStyle(color: Colors.white, fontSize: 25),
//               ),
//             )),

//         (projects==null||projects.isEmpty)?Container():CustomAnimatedList(
//           onStart: true,
//           hasToggleButton: false,
//           introDirection:stateManager.sc.mobile? DIREC.BTT: DIREC.LTR,

//           lrtb:stateManager.sc.projList(),
//           widgetList: _projects()
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     projects= stateManager.getModels("projects");
//     return stateManager.sc.mobile? mobileLayout():desktopLayout();
//   }
// }
