
import 'package:cshannon3/components/animated_list.dart';
import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  final DIREC direc;
  final Rect menuSize;
  final Size menuButton;
  final double menuFontSize;
  final Function(String) changeScreen;
  final Map<String,String> menuOptions;

  const MenuBar({Key key, this.direc, this.menuSize, this.menuButton, this.menuFontSize, this.changeScreen, this.menuOptions}) : super(key: key);
    Widget menubutton({String name, Function onPress}) { //, double width
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child:SizedBox.fromSize(
        size: menuButton,
          child: MaterialButton(
            color: Colors.white.withOpacity(0.1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            onPressed: onPress ?? () {},
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: menuFontSize,
                  fontStyle: FontStyle.italic),
            ),
          )),
    );
  }
  List<Widget> menuOptionWidgets(){
    List<Widget> out=[];
     menuOptions.forEach((name,route){
       out.add(menubutton(name: name, 
            onPress: () => changeScreen(route)
            ));
            }
         );
     return out;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedList(
          introDirection: direc,
          lrtb: menuSize,
          widgetList: menuOptionWidgets()
         
        );
  }
}