
import 'package:cshannon3/components/animated_list.dart';
import 'package:cshannon3/screens/home/project_tile.dart';
import 'package:cshannon3/state_manager.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class HomePage extends StatelessWidget {
  final StateManager stateManager;
  List<CustomModel> projects=[];

  HomePage(this.stateManager);

  List<Widget> languages({List<String> langs}) {
    if (langs == null) langs = ["Dart/Flutter", "C++", "Python", "Ruby"];
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
  List<Widget> _projects(){
    Size projTile = stateManager.sc.projectTile();
    List<Widget> out=[];
    projects.forEach((p){
       out.add(ProjectTile(
         projSize:projTile, 
         data:p,
         onChange:p.vars.containsKey("demoPath")?()=>stateManager.changeScreen(p.vars["demoPath"]):null));
     });
    return out;
  }



  Widget mobileLayout(){
    return ListView(
      children: <Widget>[
         Center(
           child: Container(
             height: stateManager.sc.w()/2,
             width: stateManager.sc.w()/2,
             child: Stack(
               children: <Widget>[
                 CircleAvatar(
                          radius: stateManager.sc.w()/2,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage("assets/coverphoto2.jpg"),
                        ),
                        Center(child: Text("Welcome, I'm Connor Shannon",textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),)),
               ],
             ),
           ),
         ),
     Padding(
       padding: const EdgeInsets.symmetric(vertical: 25.0),
       child: Center(
                  child: Text(
                    "Projects",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),

              ),
     )
      ]..addAll(
     _projects()
      )
    );

  }
  Widget desktopLayout(){
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                    CircleAvatar(
                  radius: 120.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/coverphoto2.jpg"),
                ))
                ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(left:8.0, top:30, right:8.0),
                child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                    Text(
                  "Welcome, I'm Connor Shannon",
                  style: TextStyle(
                      fontSize: 45.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                )
                )
                ),
               
        Positioned(
         left: 30.0,
         top: stateManager.sc.h()/2-80,
         height: 50.0,
         width: 150.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Projects",
                 style: GoogleFonts.aguafinaScript(),
                 //GoogleFonts.aguafinaScript(textStyle: TextStyle(color: Colors.white)),
            //    style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )),

        (projects==null||projects.isEmpty)?Container():CustomAnimatedList(
          onStart: true,
          hasToggleButton: false,
          introDirection:stateManager.sc.mobile? DIREC.BTT: DIREC.LTR,
    
          lrtb:stateManager.sc.projList(),
          widgetList: _projects()
        ),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    projects= stateManager.getModels("projects");
    return stateManager.sc.mobile? mobileLayout():desktopLayout();
  }
}



