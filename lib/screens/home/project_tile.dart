import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

class ProjectTile extends StatefulWidget {
  final Size projSize;
  final CustomModel data;
  final Function() onChange;

  const ProjectTile({Key key, this.projSize, this.data, this.onChange}) : super(key: key);
  @override
  _ProjectTileState createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  
  Widget gitHubButton(String githubUrl) => (githubUrl==null)?null:
       matbutton("Github", () => launch(githubUrl));

  Widget demoButton(Function onpress) => (onpress!=null)?matbutton("Demo", onpress):Container();

  Widget matbutton(String name, Function onPress) {
    
    return MaterialButton(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      onPressed: onPress,
      child: Text(
        name,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }


  
  @override
  Widget build(BuildContext context) {
  
  // Widget projectWidget( { //ProjectData data

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
                width:widget.projSize.width ,
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        )),
                    Container(
                      height: 30.0,
                      width:widget.projSize.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(

                            child: Container(
                              child:gitHubButton(ifIs(widget.data.vars, "githubUrl"))

                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: demoButton(widget.onChange),
                          )),
                        ],
                      ),
                    ),
                    Expanded(child: ListView(
                      children: <Widget>[
                        toRichText({
                          "token":"#",
                          "text":ifIs(widget.data.vars, "description")??""
                        }),
                       // Text(ifIs(widget.data.vars, "description")??"")
                      ],
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}


