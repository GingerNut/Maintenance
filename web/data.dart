part of maintenance;



class Data {

  String firebaseURL = "https://swurdle.firebaseio.com";

  Firebase firebase;
  List playersOnline = new List();
  //Map gamesList;

  Data() {
    firebase = new Firebase(firebaseURL);

    initialise();


    //firebase.child('dictionary').remove();
  }

  initialise() async{
    await scanPlayers();


  }


  scanPlayers()async{
      await firebase.child('players').onChildAdded.listen((e)async{
      Map array = e.snapshot.val();

      int playerJoined = array['player_id'];

      playersOnline.add(playerJoined);

      log('player added - list of players ${playersOnline}');

     });

      await firebase.child('players').onChildRemoved.listen((e)async{
        Map array = e.snapshot.val();

        String playerLeft = array['player_id'];

       playersOnline.remove(playerLeft);

        Map games = await scanGames();

        Set<int> mapKeys = games.keys.toSet();

        for(int gameKey in mapKeys){
          Map game = games[gameKey];

          List<String> gamePlayers = game['players'];

          if(gamePlayers == null){

            await firebase.child('games/$gameKey').remove();

          } else {

              await gamePlayers.removeWhere((e) => e == playerLeft);

              if(gamePlayers.length == 0) {

                await firebase.child('games/$gameKey').remove();

              } else {

                await firebase.child('games/$gameKey/players').set(gamePlayers);

              }

          }





        }

        log('player left - list of players ${playersOnline}');
      });


  }

  Future<Map> scanGames()async{
    Map gamesList;

   await firebase.child('games').onValue.first.then((e){
      gamesList = e.snapshot.val();

    });

    return gamesList;

  }

  setWords()async{

    List<String> wordList = words.split('\n');

    Map wordListMap = new Map();

    wordListMap['version'] = 0;

    wordListMap['words'] = wordList;


  }


}



