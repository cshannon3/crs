import 'package:cshannon3/components/text_builder.dart';
import 'package:cshannon3/state_manager.dart';
import 'package:cshannon3/theming.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/material.dart';

class Quotes extends StatefulWidget {
  final StateManager stateManager;
  Quotes(this.stateManager);

  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  @override
  Widget build(BuildContext context) {
   // List quotes=widget.stateManager.quotesList;
   
    return widget.stateManager.sc.mobile?mobileLayout():desktopLayout();
  }
  Widget mobileLayout(){
    List<CustomModel> quotes=widget.stateManager.getModels("quotes");
    quotes.shuffle();
    return Container(

      padding: EdgeInsets.all(5.0),
      child:ListView(
                        children: List.generate(
                            (quotes.length).floor(), (i) {
                      //  print(widget.quotesList[i].author);
                      return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.all(30.0),
                                decoration: BoxDecoration(
                                    color: RandomColor.next().withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.6), width: 2.0)),
                                width: double.infinity,
                                child: Center(
                                    child: toRichText({
                                         "color":"grey100",
                                         "fontSize":18,
                                      "text":"\""+quotes[i].vars["text"]+ "\"@@bold@@@@italic@@@@colorblue@@\n\n -${quotes[i].vars["author"]}"
                                    })
                                  //  quotes[i]
                                   //    .calls["formattedText"]()
                                   )
                                   ));
                      });
                    })));
  }

  Widget desktopLayout(){
    List<CustomModel> quotes=widget.stateManager.getModels("quotes");
    quotes.shuffle();
    return Container(
    
      //  color: Colors.blue,
      padding: EdgeInsets.all(30.0),
        child: Column(children: [
          Expanded(
              child: Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListView(
                    
                        children: List.generate(
                            (quotes.length / 2).floor(), (i) {
                      //  print(widget.quotesList[i].author);
                      return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.all(30.0),
                                decoration: BoxDecoration(
                                    color: RandomColor.next().withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.6), width: 2.0)),
                                width: double.infinity,
                                child: Center(
                                    child: toRichText({
                                         "color":"grey100",
                                         "fontSize":18,
                                      "text":"\""+quotes[i].vars["text"]+ "\"@@bold@@@@italic@@@@colorblue@@\n\n -${quotes[i].vars["author"]}"
                                    })
                                   )
                                   ));
                      });
                    })))),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListView(
                      controller: ScrollController(),
                        children: List.generate(
                            (quotes.length / 2).floor(), (i) {
                      return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.all(30.0),
                                decoration: quotesDec,
                                width: double.infinity,
                                child: Center(
                                    child:toRichText({
                                      "color":"white",
                                         "fontSize":18,
                                      "text":quotes[i + (quotes.length / 2) .floor()].vars["text"]+ "@@bold@@@@italic@@@@colorblue@@\n\n -${quotes[i + (quotes.length / 2) .floor()].vars["author"]}"
                                    })
                                    )));
                      });
                    }))))
          ]))
        ]));
  }
}
