part of maintenance;



class Data {

  String firebaseURL = "https://swurdle.firebaseio.com";

  Firebase firebase;

  Data() {
    firebase = new Firebase(firebaseURL);

    firebase.child('games').onValue.first.then((e){
      Map gamesList = e.snapshot.val();

    });
  }


}