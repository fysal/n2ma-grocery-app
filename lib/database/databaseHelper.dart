import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/modals/itemModal.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DatabaseHelper {
  String currentUser;

  DatabaseHelper({this.currentUser});

  Firestore _firestore = Firestore.instance;
  GroceryItem groceryItem;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;
  StorageUploadTask _storageUploadTask;

  uploadProduct(Product product, File imageFile, context) async {
    try {
      var tempList = Provider.of<VariationNotifier>(context, listen: false);
      String txt = "Uploading....";
      showDialog(
          context: context,
          barrierDismissible: false,
          child: CupertinoAlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text(txt)
              ],
            ),
          ));

      _storageReference =
          _firebaseStorage.ref().child("Products").child(product.name);
      _storageUploadTask = _storageReference.putFile(imageFile);
      await _storageUploadTask.onComplete.then((uploadData) async {
        txt = "Adding product....";
        String downUrl = await uploadData.ref.getDownloadURL();
        _firestore
            .collection('Products')
            .document(product.name)
            .setData(Product().toFirebase(product, downUrl))
            .whenComplete(() {
          tempList.tempVariation.clear();
          Navigator.pop(context);
          Navigator.pop(context);
        }).catchError((onError) {
          print("This is the error $onError");
          Navigator.pop(context);
        });
      });
    } catch (error) {
      Navigator.pop(context);
      showNotify(
          context: context,
          string:
              'Some thing went wrong.\n check your internet connection and try again',
          color: Colors.red);
      sleep(Duration(seconds: 3));
      Navigator.pop(context);
      print(error.toString());
    }
  }

  addItemToCart(
      {Product product,
      String variationString,
      int qty,
      totalAmount,
      BuildContext context}) async {
    try {
      showNotify(context: context, string: "Please wait...", color: green);

      var _cartItemReference = await _firestore
          .collection('Cart')
          .document(currentUser)
          .collection(currentUser)
          .document(product.name + " - " + variationString)
          .get();

      if (_cartItemReference.data == null ||
          _cartItemReference.data.length <= 0) {
        await _firestore
            .collection('Cart')
            .document(currentUser)
            .collection(currentUser)
            .document(product.name + " - " + variationString)
            .setData({
          'id': product.name,
          'variation': variationString ?? product.variations[0].name,
          'quantity': qty ?? 1,
          'total Amount': totalAmount
        }).whenComplete(() {
          Navigator.pop(context);
          continueShoppingAlert(
              context: context, message: "Item successfully added");
        });
      } else if (_cartItemReference.data != null) {
        await _firestore
            .collection('Cart')
            .document(currentUser)
            .collection(currentUser)
            .document(product.name + " - " + variationString)
            .updateData({
          'quantity': FieldValue.increment(qty),
        }).whenComplete(() {
          Navigator.pop(context);
          continueShoppingAlert(context: context, message: "Cart item updated");
        });
      }
    } catch (onError) {
      showNotify(
          context: context,
          string: "Something went wrong. Failed to add item",
          color: Colors.red);
    }
  }

  deleteItemFromCart(DocumentSnapshot snapshot, BuildContext context) {
    try {
      snapshot.reference.delete();
    } catch (e) {
      showNotify(context: context, string: e.toString(), color: Colors.red);
    }
  }

  emptyCart({context}) async {
    await _firestore
        .collection('Cart')
        .document(currentUser)
        .collection(currentUser)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.delete().whenComplete(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        parsedIndex: 3,
                      )));
        });
      });
    });
  }

  storeOrder(Map order, FirebaseUser user, BuildContext context) {
    var dateTimeStamp = DateFormat('yMDhms').format(DateTime.now());

    order['owner'] = user.uid;

    showNotify(context: context, string: 'Please wait....');
    _firestore
        .collection("Orders")
        .document()
        .setData(order)
        .then((value) async {
      await emptyCart(context: context);
      Navigator.pop(context);
    });

    //.toOrderTable(order));
  }

  incrementQty(DocumentSnapshot snapshot, price, qty) {
    try {
      snapshot.reference.updateData({
        'quantity': qty,
        'total Amount': price * qty,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  decrementQty(DocumentSnapshot snapshot, price, qty) {
    try {
      snapshot.reference.updateData({
        'quantity': qty,
        'total Amount': price * qty,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  continueShoppingAlert({BuildContext context, message}) {
    var continueAlert = AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.width / 2.4,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(message,
                style: nameStyle.copyWith(
//              fontWeight: FontWeight.w500,
                    )),
            SizedBox(height: 15),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Continue Shopping".toUpperCase(),
                      style: nameStyle.copyWith(
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.w500,
                          color: Colors.amber),
                    ))),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              parsedIndex: 4,
                            )));
              },
              child: Material(
                color: green,
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Proceed To Checkout",
                      style: nameStyle.copyWith(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, child: continueAlert, barrierDismissible: false);
  }

  showNotify({context, String string, Color color}) {
    var notifyDialog = CupertinoAlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black45),
            backgroundColor: green,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            string,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
    showDialog(
        context: context, child: notifyDialog, barrierDismissible: false);
  }

  static uploadImage(userId, context) async {
    try {
      File returnedImage = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 75);
      if (returnedImage != null) {
        showDialog(
            context: context,
            child: CupertinoAlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Uploading...."),
                ],
              ),
            ));
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('User Pictures')
            .child(userId.toString());
        StorageUploadTask storageUploadTask =
            storageReference.putFile(returnedImage);
        await storageUploadTask.onComplete.then((onValue) async {
          var imageUrl = await onValue.ref.getDownloadURL();
          Firestore.instance.collection('Users').document(userId).updateData({
            'Avatar': imageUrl.toString(),
          }).then((done) {
            Navigator.pop(context);
          });
        });
      } else {
        print("Nothing was returned");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  addPickupLocation(
      FirebaseUser user, String saveName, PlacePickerResult location, context) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Working...")
              ]),
        ));
    _firestore
        .collection('User locations')
        .document(user.uid)
        .collection(user.uid)
        .document(saveName)
        .setData({
      'latlng': {
        'latitude': location.latLng.latitude,
        'longitude': location.latLng.longitude
      },
      'address': location.address.toString(),
      'default': null
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  addToFavorite(Product item, BuildContext context,
      FavoriteNotifier favoriteNotifier) async {
    try {
      var db = _firestore
          .collection('Favorites')
          .document(currentUser)
          .collection(currentUser)
          .document(item.name);
      await db.setData({'item': item.name}).whenComplete(() async {
        await getAllFavorites(context, favoriteNotifier);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  removeFromFavorites(
      Product item, context, FavoriteNotifier favoriteNotifier) {
    try {
      var documentsReference = _firestore
          .collection("Favorites")
          .document(currentUser)
          .collection(currentUser)
          .document(item.name)
          .get();
      documentsReference.then((value) => value.reference
          .delete()
          .whenComplete(() => getAllFavorites(context, favoriteNotifier)));
    } catch (e) {
      print("item deleted");
    }
  }

  getAllFavorites(BuildContext context, FavoriteNotifier favNotify) async {
    await _firestore
        .collection('Favorites')
        .document(currentUser)
        .collection(currentUser)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        element.data.forEach((key, value) {
          favNotify.favNotificationList(value);
        });
      });
    });

    return favNotify.favList;
  }

  editProduct(
      {context,
      Product product,
      Map<dynamic, dynamic> newData,
      File imageFile}) async {
    String message = "Please wait....";
    String imagePath = "";

    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Updating"),
              content: Row(
                children: [CircularProgressIndicator(), Text(message)],
              ),
            ),
        barrierDismissible: false);

    _storageReference =
        _firebaseStorage.ref().child("Products").child(product.name);

    if (_storageReference != null) {
      try {
        if (imageFile != null) {
          await _storageReference.delete().whenComplete(() async {
            _storageReference = _firebaseStorage
                .ref()
                .child("Products")
                .child(newData["Product Name"]);
            _storageUploadTask = _storageReference.putFile(imageFile);
            await _storageUploadTask.onComplete.then((file) async {
              imagePath = await file.ref.getDownloadURL();

              message = "Image replaced";
            });
          });
        } else {
          imagePath = product.image.toString();
        }
        uploadUpdatedImage(context, product, newData, imagePath);
      } catch (e) {
        Navigator.pop(context);
        print(e.toString());
      }
    } else {
      if (imageFile != null) {
        try {
          _storageReference =
              _firebaseStorage.ref().child("Products").child(product.name);
          _storageUploadTask = _storageReference.putFile(imageFile);
          await _storageUploadTask.onComplete.then((file) async {
            imagePath = await file.ref.getDownloadURL();

            message = "Image uploaded";
            uploadUpdatedImage(context, product, newData, imagePath);
          });
        } catch (e) {
          Navigator.pop(context);
          print(e.toString());
        }
      } else {
        print("please upload an image! File filed can not be empty");
      }
    }
  }

  uploadUpdatedImage(
      BuildContext context, Product product, newData, imagePath) {
    print("Image path");

    print(imagePath);

    try {
      _firestore
          .collection("Products")
          .document(product.name)
          .updateData(Product().updateToFireStore(newData, imagePath))
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print(e.toString());
    }
  }

  deleteItem(Product product, context) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Are you sure"),
              content: Text("You want to do this?"),
              actions: [
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                            title: Text("Deleting"),
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Please await..")
                              ],
                            )));
                    _storageReference = _firebaseStorage
                        .ref()
                        .child("Products")
                        .child(product.name);
                    if (_storageReference != null)
                      await _storageReference.delete();

                    await _firestore
                        .collection('Products')
                        .document(product.name)
                        .delete()
                        .whenComplete(() {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    parsedIndex: 0,
                                  )));
                    });
                  },
                )
              ],
            ));
  }

  searchProduct(String query) {}
} //end class
