part of maintenance;



class Data {

  String firebaseURL = "https://swurdle.firebaseio.com";

  Firebase firebase;



  Data() {
    firebase = new Firebase(firebaseURL);


    scanPlayers();






  }


  scanPlayers()async{
      await firebase.child('players').onChildAdded.listen((e)async{
      Map array = e.snapshot.val();

      print('player added $array');
  });

      await firebase.child('players').onChildRemoved.listen((e)async{
        Map array = e.snapshot.val();

        print('player removed $array');
      });


  }

  scanGames(){

    firebase.child('games').onValue.first.then((e){
      Map gamesList = e.snapshot.val();

      print(gamesList);

    });
  }



}



