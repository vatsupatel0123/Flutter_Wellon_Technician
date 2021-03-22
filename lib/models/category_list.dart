
import 'package:flutter/material.dart';
class CategoryList {
  final String category_id;
  final String category_name;
  final String cat_image;
  final String is_active;
  final String productcount;


  CategoryList({
    @required this.category_id,
    @required this.category_name,
    @required this.cat_image,
    @required this.is_active,
    @required this.productcount,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      category_id: json['category_id'].toString(),
      category_name: json['category_name'],
      cat_image: json['cat_image'],
      is_active: json['is_active'],
      productcount: json['productcount'].toString(),
    );
  }
}