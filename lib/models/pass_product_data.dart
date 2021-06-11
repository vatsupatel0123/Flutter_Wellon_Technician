import 'package:flutter/material.dart';

class ItemData{
  String cproduct_id;
  String quantity;
  String price;

  ItemData({
    this.cproduct_id,
    this.quantity,
    this.price,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      cproduct_id: json['cproduct_id'].toString(),
      quantity: json['quantity'].toString(),
      price: json['price'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cproduct_id"] = cproduct_id;
    map["quantity"] = quantity;
    map["price"] = price;
    return map;
  }
}