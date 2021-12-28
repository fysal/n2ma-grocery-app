import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/ui/home.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/modals/productModal.dart';
import 'package:n2ma/notifiers/variationNotifier.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/tools/customIcons.dart';
import 'package:n2ma/backendInterfaces/editProduct.dart';
import 'package:n2ma/backendInterfaces/singin-signup.dart';
import 'package:provider/provider.dart';

class GroceryDetails extends StatefulWidget {
  Product _product;
  int index;
  int id;

  GroceryDetails(this._product, this.index, {this.id});

  @override
  State<StatefulWidget> createState() => _GroceryDetailsState();
}

class _GroceryDetailsState extends State<GroceryDetails> {
  var _controller = TextEditingController();
  int qty = 1;
  var amount;
  var actualPrice;

  Product product;
  FirebaseUser user;
  var _selectedItem;
  String initVariation;
  List<ProductVariation> _listOfVaraitions;

  @override
  void initState() {
    product = new Product();
    product.variations = List();
    initialize();
    super.initState();
  }

  initialize() {
    _controller.text = qty.toString();
    product = widget._product;
    _selectedItem = product.variations[0].name.toString();
    amount = product.variations[0].price * qty;
    actualPrice = product.variations[0].price;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    user = Provider.of<FirebaseUser>(context);
    var favs = Provider.of<FavoriteNotifier>(context);
    return Scaffold(
      backgroundColor:
          Color(int.parse(product.color.toString().substring(6, 16))),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ClipOval(
                    child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(.3),
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/images/man.png"))),
                ))
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  width: screenSize.height / 2.5,
                  height: 80,
                  child: Container(
                    child: Text(
                      product.type.toUpperCase(),
                      style: statsLabel.copyWith(
                          color: Colors.black38,
                          fontSize: ScreenUtil().setSp(40)),
                    ),
                  ),
                ),
                Positioned(
                  top: screenSize.width * .1,
                  height: screenSize.height * .4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(product.image))),
                  ),
                ),
                Positioned(
                  bottom:20, right: 20,
                  width: screenSize.width *.32 ,
                  height: screenSize.width * .09,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductDetail(product: product))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(20)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment:MainAxisAlignment.center, children: <Widget>[
                          Text("Edit",style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(50)),),
                          SizedBox(width: screenSize.width * .02,),
                          Icon(Icons.edit,color: Colors.white,size: ScreenUtil().setWidth(50),)
                        ],)
                        ),
                      ),
                       IconButton(icon: Icon((Icons.delete),size: screenSize.width *.069,),
                       onPressed: ()=> DatabaseHelper(currentUser: user.uid).deleteItem(product, context),
                       color: Colors.black45,),
                    ],
                  )
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => DatabaseHelper(currentUser: user.uid)
                        .addToFavorite(product, context, favs),
                    icon: favs.favList.contains(product.name) ? Icon(
                      Icons.favorite,
                      size: ScreenUtil().setWidth(80),
                      color: Colors.orange,
                    ) : Icon(
                      Icons.favorite_border,
                      size: ScreenUtil().setWidth(80),
                      color: Colors.black38,
                    ) ,
                  ),
                )
              ],
            ),
          ),
          bottomSheetWidget(context),
        ],
      ),
    );
  }

  Widget bottomSheetWidget(context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 0),
                color: Colors.black.withOpacity(.2))
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: screen.width * .78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 40, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name.toUpperCase(),
                    style: nameStyle.copyWith(
                        fontSize: ScreenUtil().setSp(80),
                        fontWeight: FontWeight.w800),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedItem,
                      onChanged: (val) => setState(() {
                        _selectedItem = val;
                      }),
                      items: product.variations
                          .map((dataValue) => DropdownMenuItem(
                                value: dataValue.name,
                                child: Text(dataValue.name),
                                onTap: () => setState(() {
                                  amount = dataValue.price * qty;
                                  actualPrice = dataValue.price;
                                }),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: statsLabel.copyWith(
                                fontSize: ScreenUtil().setSp(45)),
                          ),
                          Text(
                            "UGX ${amount}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(60), color: green),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Quantity",
                            style: statsLabel.copyWith(
                                fontSize: ScreenUtil().setSp(45)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                elevation: 5,
                                shadowColor: Colors.white,
                                child: Container(
                                  height: 37,
                                  width: 37,
                                  child: IconButton(
                                    onPressed: () => addQty(),
                                    icon: Icon(Icons.add,
                                        color: Colors.black38,
                                        size: ScreenUtil().setWidth(50)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {
                                        addQty();
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    controller: _controller,
                                    enabled: true,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(55),
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                elevation: 5,
                                shadowColor: Colors.white,
                                child: Container(
                                  height: 37,
                                  width: 37,
                                  child: IconButton(
                                    onPressed: () => reduceQty(),
                                    icon: Icon(Icons.remove,
                                        color: Colors.black38,
                                        size: ScreenUtil().setWidth(50)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return HomeScreen(
                      parsedIndex: 4,
                    );
                  })),
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, bottom: 15, top: 15),
                      decoration: BoxDecoration(
                        color: softerWhite,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        CustomIcons.cart,
                        color: Colors.black,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (user != null) {
                      DatabaseHelper(currentUser: user.uid).addItemToCart(
                          product: product,
                          totalAmount: amount,
                          variationString: _selectedItem,
                          qty: qty,
                          context: context);
                    } else {
                      showAlertDialog();
                    }
                  },
                  child: Material(
                      elevation: 5,
                      color: green,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        alignment: Alignment.center,
                        height: screen.width / 8,
                        width: screen.width / 2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Add to cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(45)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white30,
                              ),
                            ]),
                      )),
                ),
              ],
            ),
            margin: EdgeInsets.only(
                right: screen.width / 8,
                left: screen.width / 8,
                top: 5,
                bottom: 20),
          )
        ],
      ),
    );
  }

  addQty() {
    qty++;
    setState(() {
      _controller.text = qty.toString();
      amount = actualPrice * qty;
    });
  }

  reduceQty() {
    if (qty > 1) {
      qty--;
      setState(() {
        _controller.text = qty.toString();
        amount = amount - actualPrice;
      });
    } else {
      qty = 1;
      setState(() {
        _controller.text = qty.toString();
      });
    }
  }

  showAlertDialog() {
    CupertinoAlertDialog alertDialog = CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_alert),
            Text(
              "Alert",
              style: TextStyle(fontFamily: "Poppins"),
            ),
          ],
        ),
      ),
      content: Text("You must be logged in to continue"),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserAccess();
            }));
          },
          child: Text("SignIn"),
        )
      ],
    );
    showDialog(
      context: context,
      child: alertDialog,
    );
  }
}
