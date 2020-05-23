


import 'package:cshannon3/comments/comment_model.dart';
import 'package:cshannon3/comments/comment_widget.dart';
import 'package:cshannon3/screens/gui2/boxInfo.dart';
import 'package:cshannon3/screens/gui2/guibox.dart';
import 'package:cshannon3/screens/gui2/guiboxes.dart';
import 'package:cshannon3/screens/gui2/lrtb.dart';
import 'package:flutter/material.dart';

class CommentsOverlay extends StatefulWidget {
  final List<Comment> comments;
  final Function(Comment) update;
  final bool initShowing;

  const CommentsOverlay({Key key, this.comments, this.update, this.initShowing=false}) : super(key: key);
  @override
  _CommentsOverlayState createState() => _CommentsOverlayState();
}

class _CommentsOverlayState extends State<CommentsOverlay> {

  MainDelagator d;
bool showFeedback=true;
Widget onNewChild()=>ActiveCommentWidget(comment: Comment(),);
  @override
  void initState() {
    super.initState();
    showFeedback = widget.initShowing;
  d =new  MainDelagator((BoxInfo focusBoxData)=>setFocus(focusBoxData));
   d.rootBox = GuiBox(LRTB(0.0, 1.0, 0.0, 1.0),onNewChild: onNewChild,);
    d.rootBox.isRoot = true;
   
    widget.comments.forEach((c){
      print(c.comment);
        d.rootBox.childrenBoxes.add(GuiBox(c.location,
          //LRTB(0.0, 0.25, .25, 0.5), 
        color: Colors.yellow[200],
        onNewChild: onNewChild,
         child: ActiveCommentWidget(
        comment:  c,
      )));
    });

    
    d.addListener(() {
      setState(() {});
    });
  }

  setFocus(dynamic bd){//CommentWidgetInfo
    print(bd.prnt());
      setState(() { 
      });
    }

  @override
  Widget build(BuildContext context) {
    d.size = MediaQuery.of(context).size;
    d.context = context;
    return !showFeedback?Container():
    GestureDetector(
                onPanStart: d.onPanStart,
                onPanUpdate: d.onPanUpdate,
                onPanEnd: d
                    .onPanEnd, // onDoubleTap: d.onDoubleTap, //   onLongPress: d.onLongPress,
                onTapUp: d.onTapUp, //onTap: // onTapDown: d.onTapDown,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                    color: Colors.transparent,
                    child: d.rootBox
                        .toStack(d.size, boxinfo: BoxInfo(), refresh: () => setState(() {}))),); //getBox: ({Widget child})=>getBox(child: child)

  }
}