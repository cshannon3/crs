import 'dart:convert';
import 'package:cshannon3/utils/model_builder.dart';
import 'package:flutter/services.dart';
import 'package:firebase/firestore.dart';

//import 'package:googleapis_auth/auth_browser.dart' as auth;

import 'package:http/http.dart' as http;

class DataController {
  Firestore db;
  bool initialized = false;

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
