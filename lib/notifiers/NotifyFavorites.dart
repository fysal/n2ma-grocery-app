import 'package:cloud_firestore/cloud_firestore.dart';

class MyStreams{

  List<String> favorites = [];

  Firestore _firestore = Firestore.instance;

  Stream<List<String>> get favListsItems {
    var snapData = _firestore.collection("Favorites").document()
        .collection(FieldPath.documentId.toString()).getDocuments();
     snapData.asStream().forEach((element) {
      favorites.add(element.toString());
    });
  }

  testList(){
    favorites.forEach((element) {
      print(element.toString());
    });
  }

  List<String> get favoritesList{
    return favorites;
  }


}
