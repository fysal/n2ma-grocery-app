import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:n2ma/ui/orderDetail.dart';
import 'package:n2ma/modals/order.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Order order;

  var date;
  Firestore db;
  @override
  void initState() {
    db = Firestore.instance;
    order = Order();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true);
    var user = Provider.of<FirebaseUser>(context);
    print(user.uid);
    return user == null
        ? Center(
            child: Text("Empty"),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "My Order History",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: ScreenUtil().setSp(66),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: screenSize.height,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: StreamBuilder(
                        stream: db
                            .collection('Orders')
                            .where('owner', isEqualTo: user.uid.toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.data == null
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : snapshot.data.documents.length < 1
                                  ? Center(
                                      child: Text("You have no orders"),
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: ordersWidget(
                                              snapshot.data.documents[index]),
                                        );
                                      },
                                    );
                        }),
                  ),
                ),
              ),
            ],
          );
  }

  ordersWidget(dynamic snapshot) {
    return Builder(
      builder: (context) {
        var formatDate = DateFormat("d-MM yyy : hh:MM a");
        order = Order.fromOrderTable(snapshot);
        date = formatDate.format(order.orderDate.toDate());
        ScreenUtil.init(context, allowFontScaling: true);
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(
                        order: order,
                      ))),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DottedBorder(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              dashPattern: [10, 10, 6, 3],
              color: Colors.black26,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: SafeArea(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Order No. :  ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                order.orderId.toString().substring(0, 15),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(date.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black45)),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text("Status:"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Text(order.status,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(40,
                                        allowFontScalingSelf: true))),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.amberAccent,
                              size: ScreenUtil().setWidth(70),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SafeArea(
                    child: Row(children: <Widget>[
                      Container(
                        child: Text("UGX"),
                      ),
                      SizedBox(width: 5),
                      Container(
                        child: Text(
                          order.grandTotal.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil()
                                  .setSp(40, allowFontScalingSelf: true)),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
