

import 'package:cshannon3/screens/paint/paint_controller.dart';
import 'package:cshannon3/screens/paint/paint_utils.dart';
import 'package:flutter/material.dart';
class ColorList extends StatefulWidget {
  final PaintController paintController;

  const ColorList({Key key, @required this.paintController}) : super(key: key);

  @override
  ColorListState createState() {
    return new ColorListState();
  }
}

class ColorListState extends State<ColorList> {
  Color currentColorValue;

  @override
  void initState() {
   
    currentColorValue = widget.paintController.currentColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> colorButtons = List.generate(colorOptions.length, (i) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            color: colorOptions[i],
            height: 40.0,
            width: 40.0,
          ),
        ),
      );
    });
    return InfiniteList(
        onPressed: (selectedindex) {
          if (currentColorValue != colorOptions[selectedindex]) {
            setState(() {
              currentColorValue = colorOptions[selectedindex];
              widget.paintController.currentColor = colorOptions[selectedindex];
            });
          }
        },
        items: colorButtons);
  }
}


class InfiniteList extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onPressed;
  final List<Widget> items;
  InfiniteList({
    @required this.items,
    this.selectedIndex = 0,
    this.onPressed,
  });

  @override
  _InfiniteListState createState() => new _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  List<Widget> items;
  int originalLength;

  @override
  void initState() {
    items = widget.items;
    originalLength = items.length;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      setState(() {
        items.addAll(items.sublist(0, originalLength));
        isPerformingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        Expanded(
          child: Container(
            height: 50.0,

            decoration: BoxDecoration(
              color: Colors.grey[600],
              border: Border(
                left: BorderSide(color: Colors.grey, width: 1.0),
                right: BorderSide(color: Colors.grey, width: 1.0),
                bottom: BorderSide(color: Colors.white24, width: 1.0),
                top: BorderSide(color: Colors.white24, width: 1.0),
              ), // Border
            ), // BoxDecoration
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => widget.onPressed(index % originalLength),
                    child: widget.items[index]);
              },
              controller: _scrollController,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {},
        ),
      ],
    );
  }
}