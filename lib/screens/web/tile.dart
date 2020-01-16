
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/material.dart';

class MyTile extends StatefulWidget {
  final CustomModel modelData;
  bool isActive;
  Function(CustomModel) setActive;

  MyTile({this.modelData, this.setActive, this.isActive=false}) ;

  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: widget.isActive?EdgeInsets.all(0.0):EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: ()=>widget.setActive(widget.modelData),
                      child: new Card(
                        borderOnForeground:widget.isActive,
                        color: Colors.grey.withOpacity(0.3),
                        child: Container(
                          child: (widget.modelData==null)?null:
                          widget.modelData.vars["imgUrl"].contains("http")?
                           Image.network(widget.modelData.vars["imgUrl"], fit: BoxFit.fill,)
                          : Image.asset(widget.modelData.vars["imgUrl"], fit: BoxFit.fill,)
                        )
                      ),
                    ),                
    );
  }
}


