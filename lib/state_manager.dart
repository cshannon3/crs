
import 'package:cshannon3/controllers/data_controller.dart';
import 'package:cshannon3/controllers/scale_controller.dart';
import 'package:cshannon3/screens/books.dart';
import 'package:cshannon3/screens/home/projects_data.dart';
import 'package:cshannon3/screens/proj.dart';
import 'package:cshannon3/screens/screens.dart';
import 'package:cshannon3/screens/wordpress/login.dart';
import 'package:cshannon3/theming.dart';
import 'package:cshannon3/user_repository.dart';
import 'package:cshannon3/utils/login_state.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StateManager extends ChangeNotifier {
  DataController dataController = DataController();
  String currentRoute = "/";
  String commenter;
  ScrollController mainScroll = ScrollController();
  ScaleController sc;
  bool selected = true;
  LoginState state;
  final UserRepository _userRepository=UserRepository();

  List<String> activeCat=["Engineering"];//, "UI", "Music", "Other"

  Widget currentScreen = Container();

  StateManager();
  Map<String, String> menuOptions = {
    "Home": "/",
    "Projects": "/wordpress",
    "Interests": "/interests",
    "Quotes": "/quotes",
     "My Books": "/books",
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
  //  cm.addAll(dataMap["projects"]["models"]);
    cm.addAll(dataMap["books"]["models"]);
    print(cm.length);
    cm.addAll(dataMap["sites"]["models"]);
    print(cm.length);
    cm.addAll(dataMap["youtube"]["models"]);
    print(cm.length);
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

  Future<void> signIn() async{
    await _userRepository.signInWithGoogle().then((onValue) {
      print("success");
      print(_userRepository.getU().displayName);
      state = LoginState.success();
    }).catchError((onError) {
      state = LoginState.failure(onError);
    });
  }
  Map<String, dynamic> routes = {
    "/": (StateManager m) => new HomePage(m),
    "/fourier": (StateManager m) => new Fourier2(m),
    "/guiboxes": (StateManager m) => new GuiScreen2(m), // MyMainApp(),
    "/paint": (StateManager m) => new PaintDemo(),
    "/quotes": (StateManager m) => new Quotes(m),
    "/interests": (StateManager m) => new Bubbles(m),
    "/books":(StateManager m) => new Books(m),
    "/wordpress":(StateManager m) => new LoginPage(),
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

  changeScreen(String route) {
    print(route);
    if (routes.containsKey(route)) {
      currentRoute = route;
      notifyListeners();
    }
  }
  bool inCategories(List<String> i){
    if(i==null ||i.isEmpty)return false;
    int y=0;
    while (y<i.length){
      if(activeCat.contains(i[y]))return true;
      y++;
    }
    return false;
  }

  Widget mainPage() {
    Size projTile = Size(sc.w(), sc.fromHRange(0.5, low: 150.0));
    //sc.projectTile();
    return Container(
        child: ListView(
            controller: mainScroll,
            children: [
              sc.mobile ? mIntro() : dIntro(),
                   Container(
                  height: 30.0,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left:5.0),
                    child: Text("Skills",style: fsSm),
                  )),

               Container(
                           height: 50.0,
                  width: double.infinity,
                  child:ListView(
                    scrollDirection: Axis.horizontal,
                    children: languages(),)
                       ),
                        Container(
                  height: 80.0,
                  width: double.infinity,
                  child: Center(child:Text("Projects",style:fsMed))),
                 // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),))),
              projectFilterBar()
            ]..addAll(projects.where((p)=>inCategories(p.vars["categories"])).map((p) {
                return ProjTile(
                    projSize: projTile,
                    data: p,
                    isMobile: sc.mobile,
                    onChange: p.vars.containsKey("demoPath")
                        ? () => changeScreen(p.vars["demoPath"])
                        : null);
              }).toList())..add(Container(height: 100.0,width: double.maxFinite,))
              )
              );
  }

  Widget mIntro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
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
                  style:fsMed
               
                ))
              ],
            )),
      ),
    );
  }

  Widget dIntro() {
    return Container(
        height: sc.h() / 2,
        width: double.maxFinite,
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       Padding(
                         padding: EdgeInsets.all(25.0),
                          child: Text(
                      "Welcome, I'm Connor Shannon",
                      style: fsVLg),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("- Biomedical Engineer",style: fsSm),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("- Creative Coder",style: fsSm),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("- Avid Traveler",style: fsSm),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.github), 
       tooltip: "cshannon3",
      onPressed: () { 
        launch("https://github.com/cshannon3");
       }
     ),
      IconButton(
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.linkedin), 
      onPressed: () { launch("https://www.linkedin.com/in/connor-shannon-24933a125/"); }
     ),
      IconButton(
         tooltip: "@cshannon33",
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.twitter), 
      onPressed: () { launch("https://twitter.com/cshannon33"); }
     ),
      IconButton(
        tooltip: "@cshannon33",
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(FontAwesomeIcons.instagram), 
      onPressed: () { launch("https://www.instagram.com/cshannon33/"); }
     ),
IconButton(
  tooltip: "conreshan@gmail.com",
      // Use the FontAwesomeIcons class for the IconData
      icon: new Icon(Icons.email), 
      onPressed: () { print("Pressed"); }
     ),

                          ],)
                        ),
                     
                      ],
                    )),
                  //   TextStyle(
                  //       fontSize: 45.0,
                  //       color: Colors.white,
                  //       fontStyle: FontStyle.italic),
                  // ),
              
          )
        ]));
  }
  Widget projectFilterBar(){
    return Container(
      height: 100.0,
      width: double.maxFinite,
      child: Row(
        
        children: <Widget>[
        Expanded(child: MaterialButton(
          color:activeCat.contains("Engineering")?Colors.white.withOpacity(0.3): Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          onLongPress: () {
             if( activeCat.contains("Engineering"))activeCat.remove("Engineering");
               else activeCat.add("Engineering");
            notifyListeners();
          },
           onPressed: (){
            activeCat=["Engineering"];
            notifyListeners();
          },
          child: Text("Engineering", style: fsSm,),
          ),),
          Expanded(
            child: MaterialButton(
          color: activeCat.contains("UI")?Colors.white.withOpacity(0.3): Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          onLongPress: () {
                        if( activeCat.contains("UI"))activeCat.remove("UI");
               else activeCat.add("UI");
            notifyListeners();
          },
          onPressed: (){
activeCat=["UI"];
            notifyListeners();
          },
          child: Text("UI-Related", style: fsSm,),
          ),),
          Expanded(child: MaterialButton(
          color:activeCat.contains("Music")?Colors.white.withOpacity(0.3): Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
         onLongPress: (){
             if( activeCat.contains("Music"))activeCat.remove("Music");
               else activeCat.add("Music");
            notifyListeners();
         },
          onPressed: () {
            activeCat=["Music"];
            notifyListeners();
          },
          child: Text("Music-Related", style: fsSm,),
          ),),
            Expanded(child:MaterialButton(
          color:activeCat.contains("Other")?Colors.white.withOpacity(0.3): Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          onLongPress: () {
                        if( activeCat.contains("Other"))activeCat.remove("Other");
               else activeCat.add("Other");
            notifyListeners();
          },
           onPressed: (){
            activeCat=["Other"];
            notifyListeners();
          },
          child: Text("Other", style: fsSm,),
          ),),
          
      ],),
    );
  }
  

  List<Widget> languages({List<String> langs}) {
    if (langs == null) langs = ["Dart/Flutter", "C++", "Python", "Ruby", "Engineering", "3D Printing"];
    List<Widget> out = [];
    langs.forEach((lang) {
      out.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          color: Colors.blueGrey.withOpacity(0.4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          onPressed: () {},
          child: Text(
            lang,
            style: fsSm
           // TextStyle(color: Colors.white),
          ),
        ),
      ));
    });
    return out;
  }
}

      //                    child: Stack(
      //                      children: <Widget>[
      //                        CustomAnimatedList(
      //   onStart: true,
      //   hasToggleButton: false,
      //   introDirection: DIREC.LTR,
      //   //size: s,
      //   widgetList: languages(),
      //   lrtb: Rect.fromLTWH(0.0, 0.0, sc.w(),50.0)
      // ),
             
      //                      ],
      //                    ),



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
