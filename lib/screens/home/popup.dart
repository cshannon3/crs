import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';



const LOREM_IPSUM =
    '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Cursus metus aliquam eleifend mi in nulla posuere sollicitudin. Ultrices sagittis orci a scelerisque purus semper. Egestas pretium aenean pharetra magna ac placerat vestibulum lectus mauris. Diam vel quam elementum pulvinar etiam non quam lacus. 
    
Consectetur a erat nam at. Nunc id cursus metus aliquam eleifend mi in nulla posuere. Ipsum dolor sit amet consectetur adipiscing elit ut aliquam. Laoreet id donec ultrices tincidunt. Eleifend donec pretium vulputate sapien nec. Amet risus nullam eget felis eget nunc lobortis. In arcu cursus euismod quis viverra nibh cras pulvinar mattis. Nibh sit amet commodo nulla facilisi nullam vehicula. Eget lorem dolor sed viverra ipsum nunc. Erat imperdiet sed euismod nisi porta.\n

Nullam eget felis eget nunc lobortis. Integer feugiat scelerisque varius morbi enim nunc. A diam sollicitudin tempor id. Malesuada pellentesque elit eget gravida cum sociis natoque penatibus. Sapien pellentesque habitant morbi tristique senectus et. Ullamcorper velit sed ullamcorper morbi tincidunt. Sed blandit libero volutpat sed cras. Integer vitae justo eget magna fermentum iaculis eu non. Eleifend donec pretium vulputate sapien nec sagittis aliquam. Quis ipsum suspendisse ultrices gravida dictum. Placerat in egestas erat imperdiet sed euismod nisi porta lorem. Nisl rhoncus mattis rhoncus urna neque viverra justo nec. Praesent tristique magna sit amet purus gravida quis blandit turpis. Quam adipiscing vitae proin sagittis nisl rhoncus. Sed libero enim sed faucibus turpis in eu mi bibendum. Fermentum leo vel orci porta non pulvinar neque laoreet suspendisse. Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Tristique risus nec feugiat in fermentum posuere urna. Mauris a diam maecenas sed enim ut.

Egestas maecenas pharetra convallis posuere. Vulputate enim nulla aliquet porttitor lacus. Aliquet porttitor lacus luctus accumsan tortor posuere ac ut. Quam viverra orci sagittis eu volutpat odio facilisis mauris. Ut porttitor leo a diam sollicitudin tempor id eu. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Arcu vitae elementum curabitur vitae nunc sed velit. Laoreet non curabitur gravida arcu ac tortor dignissim convallis aenean. Diam maecenas sed enim ut sem viverra aliquet eget sit. Nulla pharetra diam sit amet nisl suscipit. Dignissim convallis aenean et tortor at risus.

Tincidunt dui ut ornare lectus sit. Sollicitudin aliquam ultrices sagittis orci a scelerisque. Convallis posuere morbi leo urna molestie at elementum. Consectetur libero id faucibus nisl tincidunt eget. Risus nec feugiat in fermentum posuere urna. Ante metus dictum at tempor commodo ullamcorper a lacus vestibulum. Interdum posuere lorem ipsum dolor sit amet consectetur adipiscing. Euismod nisi porta lorem mollis aliquam ut porttitor. Scelerisque varius morbi enim nunc faucibus a. Amet nulla facilisi morbi tempus iaculis. Turpis massa tincidunt dui ut ornare. Fermentum iaculis eu non diam. Pharetra et ultrices neque ornare aenean euismod elementum nisi. Enim diam vulputate ut pharetra sit amet aliquam. Dignissim convallis aenean et tortor at risus.

Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque elit. A lacus vestibulum sed arcu non odio euismod lacinia. Neque aliquam vestibulum morbi blandit cursus risus at. Eu turpis egestas pretium aenean pharetra magna ac. At consectetur lorem donec massa sapien. Suspendisse faucibus interdum posuere lorem ipsum dolor sit. Tincidunt vitae semper quis lectus nulla at volutpat diam. Dui ut ornare lectus sit amet est placerat. Nulla at volutpat diam ut venenatis. Euismod quis viverra nibh cras. Vitae proin sagittis nisl rhoncus mattis.''';


class PopUp extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp>
    with SingleTickerProviderStateMixin {
  var cardsList = [
    {'id': 'a', 'index': 0, 'bgColor': Colors.purple},
    {'id': 'b', 'index': 1, 'bgColor': Colors.lightBlue},
    {'id': 'c', 'index': 2, 'bgColor': Colors.lightGreen},
    {'id': 'd', 'index': 3, 'bgColor': Colors.yellow}
  ];

  void bringCardOnTop(cardId) {
    final tempList = cardsList.where((card) => card['id'] != cardId).toList();
    final int desiredCardIndex =
        cardsList.indexWhere((card) => card['id'] == cardId);
    final desiredCard = cardsList[desiredCardIndex];
    tempList.add(desiredCard);
    setState(() {
      cardsList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidthCalc = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      body: Stack(
        alignment: Alignment.center,
        children: cardsList
            .map((cardData) => FullScreenExpander(
                index: cardData['index'],
                bgColor: cardData['bgColor'],
                id: cardData['id'],
                bringCardOnTop: bringCardOnTop,
                key: Key(cardData['id']),
                cardWidth: cardWidthCalc))
            .toList(),
      ),
    );
  }
}

class FullScreenExpander extends StatefulWidget {
  final Color bgColor;
  final int index;
  final bringCardOnTop;
  final String id;
  final Key key;
  final double cardWidth;

  FullScreenExpander(
      {this.bgColor,
      this.index,
      this.bringCardOnTop,
      this.id,
      this.key,
      this.cardWidth});

  @override
  _FullScreenExpanderState createState() => _FullScreenExpanderState();
}

class _FullScreenExpanderState extends State<FullScreenExpander>
    with TickerProviderStateMixin {
  Animation<double> widthAnimation;
  Animation<double> heightAnimation;
  Animation<double> cornerAnimation;
  Animation<double> positionAnimation;
  Animation<double> scaleAnimation;
  AnimationController controller;
  AnimationController pressController;
  double startWidth;
  final startHeight = 320.0;
  final startCornerRoundness = 16.0;
  double startPosition;
  String cardState = "closed";

  void initState() {
    super.initState();
    startWidth = widget.cardWidth;
    startPosition = widget.index * (startHeight + 18) + 60.0;
    controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);

    pressController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    new Future.delayed(Duration.zero, () {
      setupAnimation();
    });
  }

  void setupAnimation() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    //     const Cubic customHeightCurve = Cubic(0.5, 0.49, 0.15, 1.23);
    const Cubic customHeightCurve = Cubic(0.44, 0.39, 0.03, 1.23);

    widthAnimation = new Tween(begin: startWidth, end: width)
        .chain(new CurveTween(
          curve: Curves.easeInOutQuint,
        ))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    heightAnimation = new Tween(begin: startHeight, end: height)
        .chain(new CurveTween(
          curve: customHeightCurve, // Curves.easeOutQuad,
        ))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                cardState = "open";
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                cardState = "closed";
              });
            } else if (status == AnimationStatus.forward ||
                status == AnimationStatus.reverse) {
              setState(() {
                cardState = "animating";
              });
            }
          });

    positionAnimation = new Tween(begin: startPosition, end: 0.0)
        .chain(new CurveTween(
          curve: customHeightCurve, //Curves.easeOutQuad,
        ))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    cornerAnimation = new Tween(begin: startCornerRoundness, end: 0.0)
        .chain(new CurveTween(
          curve: Curves.linear,
        ))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    scaleAnimation = new Tween(begin: 1.0, end: 0.95)
        .chain(new CurveTween(
          curve: Curves.linear,
        ))
        .animate(pressController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: positionAnimation?.value ?? startPosition,
      child: GestureDetector(
        onTapDown: (_tapDownDetails) {
          if (cardState == "closed") {
            // scale button down
            pressController.forward();
          }
        },
        onTapUp: (_tapUpDetails) {
          if (cardState == "closed") {
            // scale button up
            widget.bringCardOnTop(widget.id);
            pressController.reverse();
            controller.forward();
          } else if (cardState == "open") {
            controller.reverse();
          }
        },
        onTapCancel: () {
          pressController.reverse();
        },
        child: Transform.scale(
          scale: scaleAnimation?.value ?? 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                cornerAnimation?.value ?? startCornerRoundness),
            child: Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: Wrap(
                children: [
                  Container(
                    color: Colors.red,
                    height: 220,
                    child: SizedBox.expand(
                      child: Image.network(
                          'https://image.freepik.com/free-vector/vector-game-room-illustration-modern-esports-concept_33099-1201.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "APP OF THE DAY",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rosetta Stone",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                  ),
                                ),
                                Text(
                                  "The easy way to learn a language.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(width: 10, height: 24),
                        Center(
                          child: Container(
                            width: screenWidth - 50,
                            height: 500,
                            child: Text(
                              LOREM_IPSUM,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ),
              width: widthAnimation?.value ?? startWidth,
              height: heightAnimation?.value ?? startHeight,
            ),
          ),
        ),
      ),
    );
  }
}
