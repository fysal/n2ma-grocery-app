import 'package:flutter/material.dart';
class User with ChangeNotifier {
  String fullName;
  String userName;
  String userAvatar;
  String id;
  String telephone;
  String emailAddress;
  String password;


  User({this.fullName ,this.userName ,this.userAvatar ,this.emailAddress,
      this.telephone ,this.password});

  User.map(dynamic obj){
    this.userName = obj['User Name'];
    this.fullName = obj['Full Name'];
    this.userAvatar = obj['Avatar'];
    this.emailAddress = obj['Email Address'];
    this.telephone = obj['Telephone'];
    this.id       = obj['Id'];
    this.password  = obj['Password'];
  }

  User.fromDb(dynamic obj){
    this.id = obj.uid;
    this.emailAddress = obj.email;
    notifyListeners();
  }
  toMap(dynamic uid){
    Map map = Map<String, dynamic>();
    map['User Name'] = this.userName;
    map['Full Name'] = this.fullName;
    map['Avatar'] = this.userAvatar;
    map['Email Address'] = this.emailAddress;
    map['Telephone'] = this.telephone;
    map['Id'] = uid;
    map['Password'] = this.password;
    return map;
  }


  upadateMap(){
    Map<String, dynamic> map = Map();
    map['User Name'] = this.userName;
    map['Full Name'] = this.fullName;
    map['Avatar'] = this.userAvatar;
    map['Email Address'] = this.emailAddress;
    map['Telephone'] = this.telephone;
    map['Password'] = this.password;
  }


}