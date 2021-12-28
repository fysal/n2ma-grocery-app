import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n2ma/modals/userModal.dart';

class AuthHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  Firestore _firestore = Firestore.instance;
  User user;

  Future createUserWithEmailAndPassword(User user, dynamic context) async {
    var alertDialog = CupertinoAlertDialog(
      title: Text("Creating account!"),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Text("Please wait ...")
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });

    _firebaseUser = await _auth
        .createUserWithEmailAndPassword(
            email: user.emailAddress, password: user.password)
        .catchError((onError) {
      print(onError.toString());
    }).then((userData) {
      _firestore.collection("Users").document(userData.user.uid).setData(
            user.toMap(userData.user.uid),
          );
      Navigator.of(context).pop();
      return _firebaseUser;
    });
  }

signInWithEmailAndPassword(User user, dynamic context) async {
  try{
    var alert = new CupertinoAlertDialog(
      content: Row(children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.amberAccent,
        ),
        SizedBox(
          width: 10,
        ),
        Text("Logging in please wait....")
      ]),
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });

    _firebaseUser = await _auth
        .signInWithEmailAndPassword(
        email: user.emailAddress, password: user.password)
        .catchError((onError) {
      print("this error ${onError[1].toString()}");

    }).then((onValue) async {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return _firebaseUser;
    }).catchError((onError) {
      Navigator.of(context).pop();
      var alert = new CupertinoAlertDialog(
        content: Row(children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Text("Can't logIn with credentials")
        ]),
      );
      showDialog(
          context: context,
          builder: (context) {
            return alert;
          });
    });
  }catch(e){

  }
  }

  Stream<User> get currentUserStream {
    return _auth.onAuthStateChanged.map((data) {
      return User.fromDb(data);
    }).handleError((error) {
      print("thi is the erro ${error.toString()}");
    });
  }


  googleSignIn() {}

  signOut(BuildContext context) async {
    try {
      return await _auth.signOut().then((onValue) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.block,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "You have logged out",
                  style: TextStyle(color: Colors.white),
                )
              ]),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
          elevation: 1.0,
        ));
      });
    } catch (e) {
      notifyUser(context, e.toString());
    }
  }

  notifyUser(BuildContext context, String string) {
    var alertUser = CupertinoAlertDialog(
      content: Text(string),
    );
    showDialog(context: context, child: alertUser);
  }
}
