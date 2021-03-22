
import 'package:flutter/material.dart';
class ProductKitList {
  final String kit_id;
  final String op_title;
  final String status;
  final String price;

  ProductKitList({
    @required this.kit_id,
    @required this.op_title,
    @required this.status,
    @required this.price,
  });

  factory ProductKitList.fromJson(Map<String, dynamic> json) {
    return ProductKitList(
      kit_id: json['kit_id'].toString(),
      op_title: json['op_title'],
      status: json['status'],
      price: json['price'].toString(),
    );
  }
}
