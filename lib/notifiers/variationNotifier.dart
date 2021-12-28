
import 'package:flutter/cupertino.dart';
import 'package:n2ma/modals/productModal.dart';

class VariationNotifier with ChangeNotifier{
  List<ProductVariation> tempVariation = [];

  void productVariationList(dynamic variation){
    tempVariation.add(variation);
    notifyListeners();
  }

  returnVariation(){
    return tempVariation;
  }

}

class FavoriteNotifier with ChangeNotifier{
  List favList = [];
  favNotificationList(dynamic value){
//    if (favList.length > 0){
//      favList.clear();
//    }
    favList.add(value);
    notifyListeners();
    if(favList.length > 0){
      print(favList[0]);
    }else{
      print("List is empty");
    }
    return favList;
  }
}

