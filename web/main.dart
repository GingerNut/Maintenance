library maintenance;

import 'dart:html';
import 'package:firebase/firebase.dart';
import 'dart:async';
import "dart:isolate";

part 'data.dart';
part 'words.dart';


void main() {

 Data data = new Data();

}



log(String string){

  var textElement = new ParagraphElement();
  textElement.text = string;

  querySelector('#output').children.add(textElement);

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

  Isolate.spawn(testWorker,sPort.sendPort);
}

void testWorker(sender) {
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