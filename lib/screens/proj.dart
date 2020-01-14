import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

class ProjTile extends StatefulWidget {
  final Size projSize;
  final CustomModel data;
  final bool isMobile;
  final Function() onChange;

  const ProjTile({Key key, this.projSize, this.data, this.onChange, this.isMobile=false}) : super(key: key);
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
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }
  Widget mobileLayout(){
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
                                child: widget.data.vars["demoPath"]==null ?null: demoButton(widget.onChange),
                          )),
                        ],
                      ),
                    ),
                    Expanded(child: ListView(
                      children: <Widget>[
                        Text(ifIs(widget.data.vars, "description")??"")
                      ],
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  Widget desktopLayout(){
   return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            height: widget.projSize.height,
            width: widget.projSize.width,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(color: Colors.black, width: 3.0)),
            child: Row(
              children: <Widget>[
                Container(
                  width:widget.projSize.height,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(15.0),
                    child: widget.data.vars["imgUrl"].contains("http")
                    ? Image.network(
                      widget.data.vars["imgUrl"],
                      height: widget.projSize.height,
                      width: widget.projSize.height,
                      fit: BoxFit.cover,
                    ):Image.asset(
                      widget.data.vars["imgUrl"],
                      height: widget.projSize.height,
                      width: widget.projSize.height,
                      fit: BoxFit.cover,
                    )
                    ,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        Text(widget.data.vars["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                                      child:  widget.data.vars["demoPath"]==null ?null:demoButton(widget.onChange),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: ListView(
                          children: <Widget>[
                            Center(child: Text(ifIs(widget.data.vars, "description")??""))
                          ],
                        ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return widget.isMobile?
    mobileLayout()
    : desktopLayout();
  }
}


