// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:firebase/firebase.dart';
import "dart:isolate";

String firebaseURL = "https://swurdle.firebaseio.com";
Firebase firebase;

void main() {

  firebase = new Firebase(firebaseURL);

  loadGames();

}

loadGames()async {

  await firebase
      .child('games')
      .onChildAdded
      .listen((e) async {

    Map array = e.snapshot.val();

    if (array['players'] == null || array['players'] == 0) {
      print('deleting ${array['game_id']}');
      await firebase.child('games/${array['game_id']}').remove();
    }
  });
}


log(String string){
  querySelector('#output').text = string;

}

void isolateTest(){
  print("Starting");
  var sPort = new ReceivePort();
  SendPort rPort;

  sPort.listen((msg) {
    if (msg is SendPort) {
      rPort = msg;
      rPort.send("Go");
    }
    else {

      rPort.send(null);
      sPort.close();
    }
  });

  Isolate.spawn(test,sPort.sendPort);
}

void test(sender) {
  var rPort = new ReceivePort();
  sender.send(rPort.sendPort);

  rPort.listen((msg){
    print("Worker got $msg");
    if (msg =="Go"){
      while(true){
        print ("still here");

      }
    } else {
      print("worker closing on null");
      rPort.close();
    }
  });
}