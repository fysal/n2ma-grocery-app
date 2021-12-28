import 'package:cloud_firestore/cloud_firestore.dart';

class UserPickUpLocation{
  String name;
  Map<String, dynamic> latlng;
  String address;

  UserPickUpLocation({this.name, this.latlng, this.address});
 
  toFirebase(location){
   return{
     'Location name' : this.name,
     'LatLng' : this.latlng,
     'Address' : this.address
   };
   
  }

  UserPickUpLocation.fromDatabase(DocumentSnapshot dataSnapshot):
    this.address = dataSnapshot['address'],
    this.latlng = dataSnapshot['latlng'],
    this.name = 'dataSnapshot.documentID.toString()';
}

