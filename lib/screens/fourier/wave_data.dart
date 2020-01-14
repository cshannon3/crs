

import 'package:cshannon3/audio/audio_controller.dart';
import 'package:cshannon3/screens/fourier/waves.dart';
import 'package:flutter/material.dart';

class WaveVa{
  double key;
  bool isSharp;
  String keyName;
  double freq;
  double amp=0.3; // vol
  AudioPlayerController audio;
  bool isActive;
  Color color;
  
  WaveVa({this.freq, this.isSharp=false, this.keyName, this.key, this.isActive=false , this.color} );
  init(){
     String a = "assets/audio/piano_$key.mp3";
      audio=AudioPlayerController.asset(a);
      audio.initialize();
  }
  Wave toWave()=>Wave(fractionOfFull: amp,progressPerFrame: freq, waveColor: color);
}
List<WaveVa> noteData=[
  WaveVa(
    keyName: "C",
    key: 52,
    isSharp: false,
    freq: 1,
    color: Colors.blue,
    isActive: true
    
  ),
  WaveVa(
    keyName: "C#",
    key: 53,
    isSharp: true,
    freq: 1.066,
     color: Colors.cyan
  ),
  WaveVa(
    keyName: "D",
    key: 54,
    isSharp: false,
    freq: 1.129,
     color: Colors.lightBlue
  ),
  WaveVa(
    keyName: "D#",
    key: 55,
    isSharp: true,
    freq: 1.19,
     color: Colors.teal
  ),
  WaveVa(
    keyName: "E",
    key: 56,
    isSharp:false,
    freq: 1.26,
    color: Colors.yellow,
    isActive: true
  ),
  WaveVa(
    keyName: "F",
    key: 57,
    isSharp: false,
    freq: 1.34,
     color: Colors.deepOrange
  ),
    WaveVa(
    keyName: "F#",
    key: 58,
    isSharp: true,
    freq: 1.42,
    color: Colors.green
  ),
  WaveVa(
    keyName: "G",
    key: 59,
    isSharp: false,
    freq: 1.5,
    color: Colors.lime
  ),
  WaveVa(
    keyName: "G#",
    key: 60,
    isSharp: true,
    freq: 1.597,
    color: Colors.amber
  ),
   WaveVa(
    keyName: "A",
    key: 61,
    isSharp: false,
    freq: 1.69,
    color: Colors.pink
  ),
  WaveVa(
    keyName: "A#",
    key: 62,
    isSharp: true,
    freq: 1.79,
    color: Colors.purple
  ),
  WaveVa(
    keyName: "B",
    key: 63,
    isSharp: false,
    freq: 1.89,
    color: Colors.indigo
  ),
  WaveVa(
    keyName: "C",
    key: 64,
    isSharp: false,
    freq: 2,
    color: Colors.blue
  ),
];