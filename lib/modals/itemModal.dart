import 'package:flutter/material.dart';


class GroceryItem{
  String name;
  String unit;
  String type;
  var price;
  String image;
  Color color;

  GroceryItem(this.name,this.price,this.type,this.unit, this.image, {this.color});

  GroceryItem.fromJson(Map<String, dynamic> json):
      name = json['itemName'] as String,
      image = json['itemImage'] as String,
      price = json['itemPrice'] as double,
      type = json['itemType'] as String,
      color = json['itemBg'] as Color,
      unit = json['itemUnit'] as String;


  GroceryItem.map(dynamic map):
    name = map['itemName'] as String,
    image = map['itemImage'] as String,
    price = map['itemPrice'],
    type = map['itemType'] as String,
    //color = map['itemBg'] as Color,
    unit = map['itemUnit'] as String;


  toMap(){
    Map json = Map<String, dynamic>();
    json['itemName'] = name;
    json['itemImage'] = image;
    json['itemPrice'] = price;
    json['itemType'] = type;
    json['itemBg'] = color;
    json['unit'] = unit;
    return json;
  }

  toJson(){
    return{
      "itemName" : name,
      "itemImage" : image,
      "itemPrice" : price,
      "itemType" : type,
      "itemBg" : color,
      "unit" : unit
    };
  }


}

List<GroceryItem> fruits = [
  GroceryItem('Bananas',3000,'fruit','kg','assets/images/banana.png',color:Color(0xFFF4E17A)),
  GroceryItem('Mangoes',6000,'fruit','unit','assets/images/mangoes.png', color:Color(0xFFFFFC599)),
  GroceryItem('Water melon zebra',6000,'fruit','unit','assets/images/watermelo-stripes.png',color:Color(0xFFC4D6A1)),
  GroceryItem('Beetroot',1000,'fruit','unit','assets/images/beetroot.png',color:Color(0xFFF1AEAF)),
  GroceryItem('Matoke',3000,'vegetable','unit','assets/images/matoke.png', color:Color(0xFFC4D6A1)),
  GroceryItem('Water Melon',5000,'fruit','size','assets/images/watermelo.png', color: Color(0XFFFDF1BC)),

  GroceryItem('Pineapple',5000,'fruit','kg','assets/images/pineapple.png', color: Color(0xFFF9EDC6)),
  GroceryItem('Bananas',700,'fruit','unit','assets/images/banana.png',color:Color(0xFFDED0A4)),
  GroceryItem('Mangoes',4500,'fruit','unit','assets/images/mangoes.png', color: Color(0XFFFDF1BC)),
  GroceryItem('Matoke',3000,'vegetable','unit','assets/images/matoke.png',color:Color(0xFFFFFC599)),
  GroceryItem('Water Melon',5000,'fruit','size','assets/images/watermelo.png',color:Color(0xFFC4D6A1)),
  GroceryItem('Bananas',2300,'fruit','unit','assets/images/banana.png',color:Color(0xFFF4E17A)),
];