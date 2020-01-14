// class ProjectData{
//   final String name;
//   final String githubUrl;
//   final String imageUrl;
//   final String demoPath;

//   ProjectData({this.name, this.githubUrl, this.imageUrl, this.demoPath});
// }  
import 'package:cshannon3/utils/model_builder.dart';

List<CustomModel> projects = [

CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Gas Reservior",
"imgUrl":"assets/snrdesign.png",
"categories": ["Math", "Music"],
"description": "Created an on-demand gas resorvior system as a Senior Design project "
}
  }
),
CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Hands-Free Unlocking Mechanism for Prosthetic Knee",
"imgUrl":"assets/jrdsn.png",
"categories": ["Math", "Music"],
"description": "Junior Design Project"
}}),


CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Interactive Sound Vis",
    "demoPath":"/fourier",
    //"githubUrl": "https://github.com/cshannon33/fund-a-feature",
    "imgUrl":"https://res.cloudinary.com/practicaldev/image/fetch/s--AH7lgFXb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/v1p6fhprekoheceqafw1.png",
    "categories": ["Math", "Music"],
    "description": "An interactive demo to explain math through music and music through math"
}}),

CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Paint",
    "demoPath":"/paint",
    "githubUrl": "https://github.com/cshannon33/flutter_paint",
    "imgUrl":"https://www.californiapaints.com/wp-content/uploads/californiapaints-favicon.png",
    "categories": ["UI"],
    "description": "An in-browser paint app to "
}}),
  CustomModel.fromLib({
      "name":"project",
      "vars":{
      "name": "Gui Boxes",
      "demoPath":"/guiboxes",
      "imgUrl":"https://h5p.org/sites/default/files/styles/medium-logo/public/logos/drag-and-drop-icon.png?itok=0dFV3ej6",
      "categories": ["UI"],
      "description": ""
}}),
  CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Reddit Clone",
    "githubUrl": "https://github.com/cshannon33/reddit_clone_f",
    "imgUrl": "https://media.wired.com/photos/5954a1b05578bd7594c46869/master/w_1600,c_limit/reddit-alien-red-st.jpg",
    "categories": ["General"],
    "description": ""
}
  }),
CustomModel.fromLib({
      "name":"project",
      "vars":{
      "name": "OLLI Database",
      "githubUrl": "https://github.com/cshannon33/guitar_vis_f",
      "imgUrl": "http://www.olli.udel.edu/wp-content/uploads/2018/03/olli-logo.jpg",
      "categories": ["Music"],
      "description": ""
}}),

CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Smart Contract App",
    "githubUrl": "https://github.com/cshannon33/fund-a-feature",
    "imgUrl": "https://cdn-images-1.medium.com/max/770/1*cCM-v2LMlWmhibkqu705Qg.png",
    "categories": ["General"],
    "description": "A proof-of-concept smart contract application that would enable users to fund the building of specific features"
}}),

CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Blockchain Referral Program",
"githubUrl":"https://github.com/cshannon33/http_apis_and_scrapers_intro",
"imgUrl": "assets/RewardMe.png",
"categories": ["General"],
"description": ""
}
}),
CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "API Interface Program",
"githubUrl":"https://github.com/cshannon33/http_apis_and_scrapers_intro",
"imgUrl": "https://www.lucentasolutions.com/images/apinew.jpg",
"categories": ["General"],
"description": ""
}
}),

 ];
  