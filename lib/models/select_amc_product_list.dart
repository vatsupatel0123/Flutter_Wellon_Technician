
import 'package:flutter/material.dart';
class SelectAMCProductList {
  final String product_name;
  final String remask;
  final String product_image;


  SelectAMCProductList({
    @required this.product_name,
    @required this.remask,
    @required this.product_image,
  });

  factory SelectAMCProductList.fromJson(Map<String, dynamic> json) {
    return SelectAMCProductList(
      product_name: json['product_name'],
      remask: json['remask'],
      product_image: json['product_image'],
    );
  }
}
