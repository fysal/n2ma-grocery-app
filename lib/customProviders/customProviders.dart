import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:provider/provider.dart';

List<DocumentSnapshot> userFavs = [];
FirebaseUser user = FirebaseAuth.instance.currentUser() as FirebaseUser;
Firestore db = Firestore.instance;
Stream <List<DocumentSnapshot>> get userFav{
  db.collection('favorites').document(user.uid).collection(user.uid);
  //I;m currious to knowhow this works
}
