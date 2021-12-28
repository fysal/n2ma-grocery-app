import 'package:flutter/cupertino.dart';

class CartItems with ChangeNotifier{

  List cartItems = [];

  void addCartItems(dynamic snapshot){
    cartItems.add(snapshot);
    for(int i = 0; i < cartItems.length; i++){
      print(cartItems[i]["itemName"]);
    }
    notifyListeners();
  }

  get getItemsList {
    return cartItems;
  }


}