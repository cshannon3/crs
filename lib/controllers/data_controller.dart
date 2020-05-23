import 'dart:convert';
import 'package:cshannon3/secrets.dart';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:cshannon3/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:firebase/firestore.dart';
import "package:googleapis/sheets/v4.dart" as sheets;
import 'package:googleapis/docs/v1.dart' as docs;
import 'package:googleapis_auth/auth_browser.dart' as gauth;
import 'package:cshannon3/googleclient/client.dart' as commons;
import 'package:cshannon3/googleclient/requests.dart' as req;
//import 'package:googleapis_auth/auth_browser.dart' as auth;

import 'package:http/http.dart' as http;
 var sampleDocs= {
                    "Gettysburg Address":"1XQtkyCOCiroeUYvha-QJY8vWO-MNMH6fsIu5nDeYs7M",
                    //"I Have A Dream":"1-0TRJYy0dsDTbzXZHVEBRVOC8BiWv9_34IgyrX7Zn8w",
                  //  "Declaration of Independence":"1mtPVlFVytbsYJ8VONrRGfEXnzFfEavF9dbQQmakYOWg",
                //"Finest Hour":"1WOx1ro53mE8YiOH_iOfMY0UqiOD3KAIV3mGovb_ZE2o"
                  };
class DataController {
  Firestore db;
  bool initialized = false;
  gauth.AutoRefreshingAuthClient googleAuthClient;

  DataController();

  Future<dynamic> getJsonResult({String url = "", Uri uri}) async {
    if (url != "") {
      http.Response res = await http.get(url);
      return json.decode(res.body);
    }
    return null;
  }

  Future<void> getFirebaseData(String modelName, String collectionName) {
    print("y");
    List<CustomModel> l = [];

    db.collection(collectionName).onSnapshotMetadata.listen((onData) {
      print(onData);
      print("H");

      onData.docs.forEach((dataItem) {
        print(dataItem.data());
        // try {
        //   l.add(CustomModel.fromLib({"name": modelName, "vars": dataItem.data()}));
        // } catch (e) {
        //   print(dataItem.data());print("err");}
      });
    })
      ..onDone(() {
        print("done");
      });
  }
  authorizeGoogleUser() async {
    final identifier = new gauth.ClientId(
     secrets["googleClientID"],
     secrets["googleAPIKey"]);
    final scopes = [ sheets.SheetsApi.SpreadsheetsScope,docs.DocsApi.DocumentsScope ];
    gauth.createImplicitBrowserFlow(identifier, scopes).then((onValue){
      onValue.clientViaUserConsent().then((client) {
       // googleAuthClient=client;
        getData({"client":client});
  }).catchError((error) {
    if (error is gauth.UserConsentException) {
      print("You did not grant access :(");
    } else {
      print("An unknown error occured: $error");
    }
  });
    });

  }


  Future<List<CustomModel>> getJsonDataList(
      String modelName, String collectionName) async {
    //, String source
    List<CustomModel> em = [];
    String data = await rootBundle
        .loadString("assets/jsons/$collectionName.json"); //source
    final jsonData = json.decode(data);
    jsonData.forEach((item) {
      CustomModel cm = CustomModel.fromLib({"name": modelName, "vars": item});
      cm.vars["type"] = modelName;
      em.add(cm);
    });
    return em;
  }

  Future<List<CustomModel>> getDataList(String modelName, String source) async {
    List<CustomModel> em = [];
    String data = await rootBundle.loadString(source);
    final jsonData = json.decode(data);
    jsonData.forEach((item) {
      CustomModel cm = CustomModel.fromLib(modelName);
      cm.calls["fromMap"](item);
      em.add(cm);
    });
    return em;
  }

  Future<void> _addToDB(CustomModel cm, CollectionReference collection) async {
    await collection.add(cm.calls["toMap"]());
  }
}

//                   "models":[],
//                   "api":null,
//                   "dartClient":'dart-api-client docs/v1',
//                   "baseUrl":"https://docs.googleapis.com/",
//                   "scopes":[]

 getData(var tokens) async {
                    var _url;
                   var _body;
                if(tokens.containsKey("client")){
                  http.Client cl = tokens["client"];
                  commons.ApiRequester _requester= 
                  commons.ApiRequester(cl,"https://docs.googleapis.com/","",'dart-api-client docs/v1');
                  //self.vars["api"]=
                  //docs.DocsApi(tokens["client"]);
                  
                //}//else if (self.vars["api"]==null)return;
          // var l=[];
                sampleDocs.forEach((docTitle,documentId){
                      if (documentId == null) {
                              throw new ArgumentError("Parameter documentId is required.");
                            }
                          var _queryParams = new Map<String, List<String>>();
                          var _uploadMedia;
                          var _uploadOptions;
                          var _downloadOptions = req.DownloadOptions.Metadata;
                            _url = 'v1/documents/' + commons.Escaper.ecapeVariable('$documentId');

                        var _response = _requester.request(_url, "GET",
                            body: _body,
                            queryParams: _queryParams,
                            uploadOptions: _uploadOptions,
                            uploadMedia: _uploadMedia,
                            downloadOptions: _downloadOptions);
                        return _response.then((docData) {
                  // self.vars["api"].documents.get(docId).then((docData){

                          print(docTitle);
                          var txt = parseDoc({"data":docData});
                           print(txt);
                      });
              });
             // self.vars["models"]=l;
              
                }
                return ;
        }
parseDoc(var tokens){
  if(!tokens.containsKey("data"))return null;
    var data = tokens["data"];
    var content = checkPath(data, ["body", "content"]);
    if(!content[0])return null;
        String out="";
        bool italic= false;
        bool bold= false;
        String fontType = "normal";
        String fontFamily;
        int fontWeight=400;
        int fontsize = 10;
    content[1].forEach((cont){
      var elements = checkPath(cont, ["paragraph", "elements"]);
      if(elements[0] && elements[1] is List)
          elements[1].forEach((t){
              var cont = t["textRun"]["content"];
              var ts = t["textRun"]["textStyle"];
              String nFront="";
              if(ts.containsKey("italic") && ts["italic"] && !italic){
                  fontType="italic";
                  nFront+="#italic#"; italic=true;}
                else if (!ts.containsKey("italic") && italic){
                  nFront+="#normal#";
                  fontType="normal";
                  italic=false;
                }
                if(ts.containsKey("bold") && ts["bold"] && !bold){
                  fontWeight=700;
                  nFront+="#fw$fontWeight#"; bold=true;}
                else if (!ts.containsKey("bold") && bold){
                  fontWeight=400;
                  nFront+="#fw$fontWeight#";
                  bold=false;
                }
                var font= checkPath(ts, ["fontSize", "magnitude"]);
                if(font[0] &&font[1]!=fontsize){
                // ts.containsKey("fontSize") && ts["fontSize"].containsKey("magnitude") &&ts["fontSize"]["magnitude"]!=fontsize){
                  fontsize=ts["fontSize"]["magnitude"];
                  nFront+="#size$fontsize#"; }       
               // var ffam= checkPath(ts, ["weightedFontFamily", "fontFamily"]);
              //   if(ffam[0] && fonts.containsKey(ffam[1])){
              //     if(ffam[1]!=fontFamily && fonts[ffam[1]][fontType].contains(fontWeight)){
              //       fontFamily=ffam[1];
              //     nFront+="#fontfam$fontFamily#"; }
              // } 
                out+= nFront+cont;//+nBack;
          });

    });
    return out;
    }
          
  

// Future<void> getAllFirebaseData(){
//       if(!initialized)return null;
//       print("y");
//       firebaseModels.forEach((key, firebaseModel) async{
//        await firebaseModel.calls["getData"]({"firestore":db});
//       });
//       print("j");
//       return null;
//   }

//   authorizeGoogleUser() async {
//   final identifier = new auth.ClientId(
//    secrets["googleClientID"],
//    secrets["googleAPIKey"]);
//   //final scopes = [drive.DriveApi.DriveScope, calendar.CalendarApi.CalendarScope, sheets.SheetsApi.SpreadsheetsScope,docs.DocsApi.DocumentsScope ];
//   auth.createImplicitBrowserFlow(identifier,[]).then((onValue){
//     onValue.clientViaUserConsent().then((client) {
//       googleAuthClient=client;
//       print("OK");
//      // googleAPIModels["googleDocs"].calls["getData"]({"client":googleAuthClient});
// }).catchError((error) {
//   if (error is auth.UserConsentException) {
//     print("You did not grant access :(");
//   } else {
//     print("An unknown error occured: $error");
//   }
// });
//   });
//     }
