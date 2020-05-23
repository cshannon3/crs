


import 'package:cshannon3/comments/comment_model.dart';
import 'package:flutter/material.dart';

class ActiveCommentWidget extends StatefulWidget {
  final Comment comment;
  final Function(Comment) update;
  final bool edit;

  const ActiveCommentWidget({Key key, this.comment, this.update,this.edit=false}) : super(key: key);
  
  @override
  _ActiveCommentWidgetState createState() => _ActiveCommentWidgetState();
}

class _ActiveCommentWidgetState extends State<ActiveCommentWidget> {
  TextEditingController commentTextInputController;
  TextEditingController nameInputController;
  Comment comment;
  //  TextInputClient p;
  //  bool showFeedback=false;
  bool edit=false;
     @override
  void initState() {
    super.initState();
    edit= widget.edit;
  comment= widget.comment??Comment();
    commentTextInputController = new TextEditingController();
  nameInputController = new TextEditingController();
   if(widget.comment.commenter!=null)nameInputController.text=widget.comment.commenter;
   if(widget.comment.comment!=null)commentTextInputController.text=widget.comment.comment;
  }
  @override
  Widget build(BuildContext context) {
  //  Size s = MediaQuery.of(context).size;
    // return Positioned(
    //    left: widget.comment.location.left*s.width,
    //    width: widget.comment.location.toW(s.width),
    //    top: widget.comment.location.top*s.height,
    //    height: widget.comment.location.toH(s.height),
    //           child: 
           return   Padding(
             padding: const EdgeInsets.all(5.0),
             child: edit?Column(
        children: <Widget>[
          Text("Add Comment Below",
          style: TextStyle(color: Colors.black),),
          Expanded(
                child: TextField(
                   style: TextStyle(color: Colors.black),
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Comment*', hoverColor: Colors.black),
                  controller: commentTextInputController,
                ),
          ),
                Expanded(
                child: TextField(
                   style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(labelText: 'Name*', hoverColor: Colors.black),
                  controller:nameInputController,
                ),
          ),
   
                     FlatButton(
          child: Text('Add',style: TextStyle(color: Colors.black),),
          onPressed: () {

        }
        ),
  
        ],
      ):Column(
        children: <Widget>[
          Expanded(
                child: Center(child: Text(widget.comment.comment)),
          ),
          Expanded(
                child:  Center(child: Text(widget.comment.commenter)),
          ),
        ],
      )
      ,
           );
  }
}
         
          //     if (
          //         commentTextInputController.text.isNotEmpty ) {
                      
          //       widget.db
          //         .collection('feedback')
          //         .add({
          //           "comment": commentTextInputController.text,
          //           "screen":stateManager.currentRoute,
          //           "commenter":stateManager.commenter
          //       })
          //       .then((result) => {
          //        // Navigator.pop(context),
                    
          //         commentTextInputController.clear(),
          //       })
          //       .catchError((err) => print(err));
          // }
          // setState((){});