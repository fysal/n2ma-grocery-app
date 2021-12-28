import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String name;
  String image;
  List<ProductVariation> variations;
  var color;
  String type;
  String unitOfMeasure;
  int id;

  Product(
      {this.id,
        this.name,
      this.image,
      this.color,
      this.type,
      this.variations,
      this.unitOfMeasure});

  Product.fromFirebase(DocumentSnapshot data) {
    this.variations = List();

    data['Product Variations'].forEach((k,v) =>
        this.variations.add(ProductVariation(name: k, price: v)));
    this.name = data['Product Name'];
    this.type = data['Type'];
    this.image = data['Product Image'];
    this.unitOfMeasure = data['Unit of Measure'];
    this.color = data['Background Color'];
  }

  toFirebase(product, downUrl) {
    return {
      'Product Name': product.name,
      'Product Image': downUrl,
      'Product Variations': Map.fromIterable(product.variations,
          key: (v) => v.name, value: (v) => v.price),
      'Background Color': product.color.toString(),
      'Type': product.type,
      'Unit of Measure': product.unitOfMeasure
    }; 
}

updateToFireStore(Map<dynamic,dynamic>newData,downUrl){
    return{
      'Product Name': newData["Product Name"],
      'Product Image': downUrl,
      'Background Color': newData["Background Color"].toString(),
      'Type': newData["Type"],
      'Unit of Measure': newData['Unit of Measure'],
      'Product Variations': Map.fromIterable(newData['Product Variations'], key: (v)=>v.name, value: (v)=>v.price)
    };
}

}

class ProductVariation {
  var price;
  var name;
  ProductVariation({this.name, this.price});
}
