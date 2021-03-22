
import 'package:flutter/material.dart';
class MyOrderDetailsList {
  final String product_id;
  final String quantity;
  final String price;
  final String productname;
  final String image1;


  MyOrderDetailsList({
    @required this.product_id,
    @required this.quantity,
    @required this.price,
    @required this.productname,
    @required this.image1,
  });

  factory MyOrderDetailsList.fromJson(Map<String, dynamic> json) {
    return MyOrderDetailsList(
      product_id: json['product_id'].toString(),
      quantity: json['quantity'],
      price: json['price'],
      productname: json['productname'],
      image1: json['image1'].toString(),
    );
  }
}