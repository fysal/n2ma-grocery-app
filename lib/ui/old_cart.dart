import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n2ma/ui/checkout.dart';
import 'package:n2ma/database/databaseHelper.dart';
import 'package:n2ma/styles/customStyles.dart';
import 'package:n2ma/tools/customColors.dart';
import 'package:n2ma/modals/itemModal.dart';
import 'package:n2ma/tools/customIcons.dart';
import 'package:n2ma/backendInterfaces/singin-signup.dart';
import 'package:provider/provider.dart';

class OldCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OldCartState();
}

class _OldCartState extends State<OldCart> {
  GroceryItem item;
  var _controller = TextEditingController();

  double total ;
  List cartPrices = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context, listen: true);
    ScreenUtil.init(context);
    return user == null ? userNull(context) : userAvailable(user);
  }

  textRotated() {
    return Transform.rotate(
      child: Container(
        child: Text(
          "MY SHOPPING CART",
          style: TextStyle(
            color: Colors.blueGrey.withOpacity(.3),
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
      angle: -80.1,
    );
  }

  cartCard(GroceryItem item, DocumentSnapshot snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(350),
          height: ScreenUtil().setHeight(280),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: ScreenUtil().setWidth(240),
                  height: ScreenUtil().setWidth(210),
                  decoration: BoxDecoration(
                      color: Color(int.parse(
                          snapshot['itemBg'].toString().substring(6, 16))),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Positioned(
                top: 10,
                left: -5,
                child: Image.asset(
                  item.image,
                  width: MediaQuery.of(context).size.width * .36,
                  height: MediaQuery.of(context).size.height * .110,
                  fit: BoxFit.fitHeight,
                ),
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                item.type.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.black12),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 140),
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Shs",
                  style: TextStyle(letterSpacing: 0),
                ),
                SizedBox(
                  width: 1,
                ),
                Text(snapshot['itemTotal'].toString(),
                    style: priceStyle.copyWith(
                        fontWeight: FontWeight.normal, fontSize: 20)),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
            height: 100,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                       // DatabaseHelper().incrementQuantity(snapshot);
                        },
                    icon: Icon(Icons.add),
                  ),
                  Container(
                    height: 50,
                    width: 25,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: snapshot['quantity'].toString()),
                      // controller: _controller,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (snapshot['quantity'] > 1) {
                      //  DatabaseHelper().decrementQty(snapshot);
                      }
                    },
                    icon: Icon(Icons.remove),
                  ),
                ],
              ),
              FlatButton(
                onPressed: () =>
                    DatabaseHelper().deleteItemFromCart(snapshot, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  userNull(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: ClipOval(
                  child: Container(
                    width: ScreenUtil().setWidth(600),
                    height: ScreenUtil().setWidth(600),
                    color: Colors.blueGrey.withOpacity(.2),
                  ),
                ),
              ),
              Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Icon(
                    CustomIcons.basket,
                    size: ScreenUtil().setWidth(450),
                    color: Colors.blueGrey,
                  )),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Cart Empty",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(60),
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey),
          ),
          Text(
            "You have nothing in cart",
            style: TextStyle(fontSize: ScreenUtil().setSp(39)),
          ),
          SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserAccess(),
                )),
            child: Container(
              width: MediaQuery.of(context).size.width * .6,
              child: Material(
                borderRadius: BorderRadius.circular(50),
                color: green,
                elevation: 1.0,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(50)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white.withOpacity(0.5),
                        )
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  userAvailable(user) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Cart")
          .document(user.uid)
          .collection(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        Size screenSize = MediaQuery.of(context).size;
        return snapshot.hasData ? Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 10, right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Cart",
                    style: nameStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(70)),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("items"),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            snapshot.data != null
                                ? snapshot.data.documents.length.toString()
                                : "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black45,
                                letterSpacing: 2),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                width: screenSize.width,
                height: ScreenUtil().uiHeightPx * .29,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: !snapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            item =
                                GroceryItem.map(snapshot.data.documents[index]);
                            return cartCard(
                                item, snapshot.data.documents[index]);
                          },
                        ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              decoration: BoxDecoration(
                color: softWhite,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(.3),
                      blurRadius: 20,
                      spreadRadius: 10,
                      offset: Offset(10, 15))
                ],
              ),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -35,
                    right: screenSize.width / 8,
                    child: Container(
                        child: Text(
                      "Total amount",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(45),
                        fontWeight: FontWeight.w800,
                        color: Colors.black54.withOpacity(.3),
                      ),
                    )),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(price: total,),
                              )),
                          child: Container(
                            width: screenSize.width / 3,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                )),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(45)),
                            ),
                          ),
                        ),
                        Container(
                            width: screenSize.width / 2,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: green.withOpacity(.8),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                )),
                            child:
                            computeTotal(user),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ) :
        Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

Widget computeTotal(user){
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Cart")
          .document(user.uid)
          .collection(user.uid)
          .snapshots().asyncMap((snapData) async{
          if(cartPrices.length > 0){
            cartPrices.clear();
          }
          for(int i = 0; i < snapData.documents.length; i++){
           cartPrices.add(snapData.documents[i]['itemTotal']);
         }
          total = cartPrices.fold(0,(prev, nxt) =>  prev + nxt);

      }),
         builder: (context, snapshot){
          ScreenUtil.init(context);
           return Text("UGX ${total.toString()}",
             style: TextStyle(color:Colors.white,fontSize: ScreenUtil().setSp(45)),);
         },

    );



}

}

class ShapeClip extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(40, size.height / 2);
//    path.quadraticBezierTo(size.width / 4 - 40, size.height / 2, size.width / 3, size.height / 2 + 100);
    path.lineTo(size.width, size.height);
//    path.quadraticBezierTo(size.width / 3, size.height / 2 + 100, size.width / 3 + 80, size.height / 2 + 100);
    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width, 0.0);
    path.lineTo(40, size.height / 2);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class curvedShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
