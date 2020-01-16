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
"categories": ["Engineering"],
"description": '''
#bold##size13##colorgrey#University of Delaware Senior Design, Sponsored By Air Liquide Healthcare#/bold##/color#
#size14##bold#Problem:#/bold##size14#  Nitrous Oxide therapy has the potential to provide non-invasive, at-home pain management to millions, but at-home delivery of nitrous oxide raises multiple environmental and patient comfort concerns that are not resolved by the current home care ventilators.
#bold#Purpose:#/bold# To provide a consistent supply of gas regardless of the patient’s respiratory activity while minimizing waste gas and patient discomfort.
#bold##size18#Benchmarking:#/bold# #size14#
 - Non-rebreathing Oxygen Mask required nurse present
 - Continuous Flow systems lead to too much waste
 - On-Demand Systems(like CPAP Machine) were uncomfortable leak-prone
#bold#Approach:#/bold# 
 - Build a device with a resorvior bag inside, then sense deflation of the reservior(patient inhalation) and open valve to provide patient with air and refill reservior.
Decision Point 1: Sensor Selection
Decision Point 2: Resorvior Bag Selection
#bold#Skills Gained/Lessons Learned:#/bold# Arduino, Rapid Prototyping, Client Relationship, presentation and defense of decisions
#bold#Status/Path Forward:#/bold#  Ended class in Winter 2018 but was hired by Air Liquide to continue development.
''',
}
  }
),
CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Hands-Free Unlocking Mechanism for Prosthetic Knee",
"imgUrl":"assets/jrdsn.png",
"categories": ["Engineering"],
"description": '''
#bold##size13##colorgrey#University of Delaware Junior Design, Sponsored By Air Liquide Healthcare#/bold##/color##size14#
#bold#Problem:#/bold# In certian Knee Prosthetics, the users have to manually lock and unlock the Knee Joint when going between sitting and standing. Doing so puts the user at risk of falling or hurting themself.
#bold#Purpose:#/bold# To create a wireless locking mechanism which minimizes the risk of falling and is robust and comfortable enough to be used continuously.
#bold#Approach:#/bold# Remote controlled linear actuator mechanism.
#bold#Skills Gained/Lessons Learned:#/bold# While the best prosthetics are incredibly advanced, the majority of patients only have access to extremely rudimentary devices.
'''
}}),


CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Interactive Music Theory Visualizer",
    "demoPath":"/fourier",
    "imgUrl":"https://res.cloudinary.com/practicaldev/image/fetch/s--AH7lgFXb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/v1p6fhprekoheceqafw1.png",
    "categories": ["Music"],
    "description": '''
    #bold##size13##colorgrey#University of Delaware Junior Design, Sponsored By Air Liquide Healthcare#/bold##/color#
    #bold#Problem:#/bold# Music and math are both awesome and powerful, but music theory and math education are often boring and confusing.
    #bold#Purpose:#/bold# Build interactive tools that give the user a more intuitive understanding of the patterns found in music and explained through math.
    #bold#Approach:#/bold# This ideas stemmed from a Fourier Transform Visualization app I made after seeing 3b1bs video. In seeing an opportunity to apply those ideas towards my interest in music theory, I merged them into this project. 
    #bold#Lessons:#/bold# Consonance vs Dissonance.
    '''
}}),

CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Paint",
    "demoPath":"/paint",
    "githubUrl": "https://github.com/cshannon3/flutter_paint",
    "imgUrl":"https://www.californiapaints.com/wp-content/uploads/californiapaints-favicon.png",
    "categories": ["UI"],
    "description": "An in-browser paint tool. "
}}),
  CustomModel.fromLib({
      "name":"project",
      "vars":{
      "name": "Gui Boxes",
      "demoPath":"/guiboxes",
      "imgUrl":"https://h5p.org/sites/default/files/styles/medium-logo/public/logos/drag-and-drop-icon.png?itok=0dFV3ej6",
      "categories": ["UI"],
      "description": '''
      A no-coding UI tool. It enables you to create, shape, move, nest, and format UI components. Ideally this tool would be used for creating fully functional apps through the browser but there is still a lot to do to get there. Currently,
      you can only change the color, opacity and shade of the box, which can stull be useful in layout mockups. 
      '''
}}),
  CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Reddit Clone",
    "githubUrl": "https://github.com/cshannon3/reddit_clone_f",
    "imgUrl": "https://media.wired.com/photos/5954a1b05578bd7594c46869/master/w_1600,c_limit/reddit-alien-red-st.jpg",
    "categories": ["Other"],
    "description": ""
}
  }),
CustomModel.fromLib({
    "name":"project",
    "vars":{
    "name": "Smart Contract App",
    "githubUrl": "https://github.com/cshannon3/fund-a-feature",
    "imgUrl": "https://cdn-images-1.medium.com/max/770/1*cCM-v2LMlWmhibkqu705Qg.png",
    "categories": ["Other"],
    "description": "A proof-of-concept smart contract application that would enable users to fund the building of specific features"
}}),

CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Blockchain Referral Program",
"githubUrl":"https://github.com/cshannon3/http_apis_and_scrapers_intro",
"imgUrl": "assets/RewardMe.png",
"categories": ["Other"],
"description": ""
}
}),
CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "API Interface Program",
"githubUrl":"https://github.com/cshannon3/http_apis_and_scrapers_intro",
"imgUrl": "https://www.lucentasolutions.com/images/apinew.jpg",
"categories": ["Other"],
"description": ""
}
}),
// CustomModel.fromLib({
//       "name":"project",
//       "vars":{
//       "name": "OLLI Database",
//       "githubUrl": "https://github.com/cshannon3/guitar_vis_f",
//       "imgUrl": "http://www.olli.udel.edu/wp-content/uploads/2018/03/olli-logo.jpg",
//       "categories": ["Other"],
//       "description": ""
// }}),
  CustomModel.fromLib({
  "name":"project",
  "vars":{
"name": "Music Apps",
//"demoPath":"/music",
"githubUrl": "https://github.com/cshannon3/guitar_vis_f",
"imgUrl": "https://continuingstudies.uvic.ca/upload/Arts/Courses/MUS-MusicTheory-Course-Header-min_mobile.jpg",
"categories": ["Music"],
"description": ""
}}),
// CustomModel.fromLib({
//   "name":"project",
//   "vars":{
// "name": "Rap Pad",
// "demoPath":"/raps",
// //"githubUrl":"https://github.com/cshannon3/http_apis_and_scrapers_intro",
// "imgUrl": "https://ewedit.files.wordpress.com/2017/12/black-thought.jpg",
// "categories": ["General"],
// "description": ""
// }
// }),
 ];
  