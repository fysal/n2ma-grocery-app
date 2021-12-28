import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  var orderId;
  var grandTotal;
  var subtTotal;
  var deliveryCharge;
  List<Map<String, dynamic>> orderItems = [];
  var pickUpLocation;
  var paymentMethod;
  var orderDate;
  String status;
  var owner;

  Order(
      {this.orderId,
      this.grandTotal,
      this.subtTotal,
      this.deliveryCharge,
      this.orderItems,
      this.paymentMethod,
      this.pickUpLocation,
      this.status,
      this.orderDate,
      this.owner});

  toOrderTable(List<Order> cartData) {
    //this.orderId = cartData[0].orderId;
    this.subtTotal = cartData.first.subtTotal;
    this.deliveryCharge = cartData.first.deliveryCharge;
    this.grandTotal = cartData.first.grandTotal;
    this.orderDate = cartData.first.orderDate;
    // this.orderItems = cartData.first.orderItems;
    this.paymentMethod = cartData.first.paymentMethod;
    // this.pickUpLocation = cartData.first.pickUpLocation;
    this.status = cartData.first.status;
    this.owner = cartData.first.owner ? cartData.first.owner : null;
  }

  commitOrder(Map<String, dynamic> data) {
    this.grandTotal = data['grandTotal'];
  }

  Order.fromOrderTable(DocumentSnapshot snapshot) {
    this.orderId = snapshot.documentID;
    this.subtTotal = snapshot['subtotal'];
    this.deliveryCharge = snapshot['deliveryCharge'];
    this.grandTotal = snapshot['grandTotal'];
    this.orderItems = List<Map<String, dynamic>>.from(snapshot['cartItems']);
    this.pickUpLocation = snapshot['pickUpLocation'];
    this.paymentMethod = snapshot['paymentMethod'];
    this.orderDate = snapshot['orderDate'];
    this.status = snapshot['status'];
    this.owner = snapshot['owner'];
  }
}

class CartItem {
  var itemName;
  var itemPrice;
  int qty;

  CartItem({this.itemName, this.itemPrice, this.qty});
}
