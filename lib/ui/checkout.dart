import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:intl/intl.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/ui/pickUpLocations.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/location.dart';
import 'package:n2ma/modals/order.dart';
import 'package:n2ma/modals/userModal.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  var price;
  List<CartItem> cartItems = [];
  @override
  State<StatefulWidget> createState() => _Checkout();
  Checkout({this.price, this.cartItems});
}

class _Checkout extends State<Checkout> {
  int _deliveryPrice = 5000;
  Firestore _firestore;
  User _dbUser;
  String _selectedPayment = "MTN - Mobile money";
  var _locationPref;
  List<Order> _orderItemList = [];
  UserPickUpLocation _userPickUpLocation;
  Map<String, dynamic> _myCartData;
  Map<String, dynamic> _location = Map();

  @override
  void initState() {
    super.initState();
    _firestore = Firestore.instance;
    _dbUser = User();
  }

  getPreferences() async {
    _locationPref = await SharedPreferences.getInstance();
    setState(() {
      _locationPref.getString("keyLoc");
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    ScreenUtil.init(context, allowFontScaling: true);
    Size screenSize = MediaQuery.of(context).size;
    getPreferences();

    // _getPickUpLocation(user) ;

    return StreamBuilder(
        stream: _firestore
            .collection("Cart")
            .document(user.uid)
            .collection(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0XFFF3F3F3),
            body: snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 40.0, left: 20, right: 18, bottom: 8.0),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Colors.black45,
                                size: ScreenUtil().setWidth(90),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Checkout",
                              style: titleStyles.copyWith(
                                fontSize: ScreenUtil().setSp(66),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Billing Information",
                                      style: checkoutTitles.copyWith(
                                          fontSize: ScreenUtil().setSp(40,
                                              allowFontScalingSelf: true)),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 1.0,
                                borderOnForeground: true,
                                //shadowColor: Colors.black,
                                color: Colors.white,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: _firestore
                                              .collection("Users")
                                              .document(user.uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData)
                                              _dbUser = User.map(snapshot.data);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text("${_dbUser.fullName}",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: ScreenUtil()
                                                              .setSp(40),
                                                        )),
                                                    GestureDetector(
                                                      onTap: () => null,
                                                      child: Text(
                                                        "change".toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(30)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text("${_dbUser.emailAddress}"),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text("${_dbUser.telephone}"),
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Pick up location",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    ScreenUtil().setSp(40)),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PickUpLocations(user))),
                                            child: Text(
                                              "Update".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      ScreenUtil().setSp(30)),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(_locationPref.getString("keyLoc") !=
                                              null
                                          ? _locationPref.getString("keyLoc")
                                          : "City name, province"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Payment Method",
                                      style: checkoutTitles.copyWith(
                                          fontSize: ScreenUtil().setSp(40,
                                              allowFontScalingSelf: true)),
                                    ),
                                    GestureDetector(
                                      onTap: () => null,
                                      child: Text(
                                        "change".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: ScreenUtil().setSp(30)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  children: <Widget>[
                                    paymentMethod(
                                        methName: "MTN - Mobile money"),
                                    paymentMethod(methName: "Airtel - Money"),
                                    paymentMethod(methName: "VISA"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Order summery",
                                      style: checkoutTitles.copyWith(
                                          fontSize: ScreenUtil().setSp(40,
                                              allowFontScalingSelf: true)),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    parsedIndex: 4,
                                                  ))),
                                      child: Text(
                                        "Update".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: ScreenUtil().setSp(30)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                child: DataTable(
                                    dataRowHeight: 75,
                                    columnSpacing: 10.0,
                                    columns: [
                                      DataColumn(label: Text("Items in cart")),
                                    ],
                                    rows: _listOfCartItems(widget.cartItems)
                                    // _listOfCells(snapshot.data, ScreenUtil),
                                    ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Sub total: ",
                                                ),
                                                Text(
                                                  "Ugx ${widget.price}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(40),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Delivery cost: ",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  "Ugx $_deliveryPrice",
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(40),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Grand total: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black38),
                                                ),
                                                Text(
                                                  "Ugx ${widget.price + _deliveryPrice}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize:
                                                        ScreenUtil().setSp(50),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FlatButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            )),
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(18),
                                            width: screenSize.width,
                                            decoration: BoxDecoration(
                                                color: green,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "CONTINUE SHOPPING",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(40)),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          await _getPickUpLocation(user);
                                          DatabaseHelper(currentUser: user.uid)
                                              .storeOrder(
                                                  collectOrderItems(user),
                                                  user,
                                                  context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(18),
                                          alignment: Alignment.center,
                                          width: ScreenUtil.screenWidth,
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            "PLACE ORDER NOW",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w800,
                                                fontSize:
                                                    ScreenUtil().setSp(46),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          );
        });
  }

  List<DataRow> _listOfCartItems(List<CartItem> cartItems) {
    return cartItems
        .map((cartData) => DataRow(cells: [
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        cartData.itemName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(45),
                            fontWeight: FontWeight.w700),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "UGX: ",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(35),
                                    color: Colors.black45),
                              ),
                              Text(
                                cartData.itemPrice.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black38,
                                    fontSize: ScreenUtil()
                                        .setSp(45, allowFontScalingSelf: true)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Qty: ${cartData.qty.toString()}",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: ScreenUtil().setSp(45)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]))
        .toList();
  }

  paymentMethod({String methName, String img, int value, bool isSelected}) {
    return Row(
      children: <Widget>[
        Radio(
          onChanged: (value) => setState(() {
            _selectedPayment = value;
          }),
          groupValue: _selectedPayment,
          value: methName,
        ),
        Text(methName),
      ],
    );
  }

  _getPickUpLocation(FirebaseUser user) async {
    var locationSnap = _firestore
        .collection("User locations")
        .document(user.uid)
        .collection(user.uid)
        .where('address', isEqualTo: await _locationPref.getString("keyLoc"))
        .snapshots();
    await locationSnap.first.then((value) async => _userPickUpLocation =
        UserPickUpLocation.fromDatabase(value.documents.first));

    setState(() {
      _location.addAll({
        'address': _userPickUpLocation.address,
        'latlng': _userPickUpLocation.latlng
      });
    });

    return _location;
  }

  Map collectOrderItems(FirebaseUser user) {
    _myCartData = {
      'id': DateFormat('yMDhms').format(DateTime.now()),
      'grandTotal': widget.price + _deliveryPrice,
      'subTotal': widget.price,
      'deliveryCharge': _deliveryPrice,
      'cartItems': mapListItems(),
      'pickUpLocation': _location,
      'status': 'pending',
      'orderDate': DateTime.now(),
      'paymentMethod': _selectedPayment,
    };
    return _myCartData;
  }

  List<Map<String, dynamic>> mapListItems() {
    List<Map<String, dynamic>> checkList = [];
    try {
      for (int i = 0; i < widget.cartItems.length; i++) {
        checkList.add({
          'Product': widget.cartItems[i].itemName,
          'Qty': widget.cartItems[i].qty,
          'price': widget.cartItems[i].itemPrice
        });
      }

      return checkList;
    } catch (e) {
      print(e);
    }
  }
}
