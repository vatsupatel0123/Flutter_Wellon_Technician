
import 'package:flutter/material.dart';
class MyOrderDetailsList {
  String product_id;
  String quantity;
  String price;
  String productname;
  String image1;
  String gstprice;
  bool chkproduct;


  MyOrderDetailsList({
    this.product_id,
    this.quantity,
    this.price,
    this.productname,
    this.image1,
    this.gstprice,
    this.chkproduct,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["product_id"] = product_id;
    map["quantity"] = quantity;
    map["price"] = price;
    map["gstprice"] = gstprice;
    map["productname"] = productname;
    return map;
  }

  factory MyOrderDetailsList.fromJson(Map<String, dynamic> json) {
    return MyOrderDetailsList(
      product_id: json['product_id'].toString(),
      quantity: json['quantity'],
      price: json['price'],
      productname: json['productname'],
      image1: json['image1'].toString(),
      gstprice: json['gstprice'].toString(),
      chkproduct: false,
    );
  }
}