
import 'dart:core';

import 'package:flutter/material.dart';
class CategoryProductList {
  final String category_id;
  final String cproduct_id;
  final String category_name;
  final String is_active;
  final String productname;
  final String productprice;
  int minmum_qua;
  int original_minmum_qua;
  final String image1;
  final String image2;
  final String image3;
  final String gstrate;
  final String gst_date;
  final String price;
  final String incl_excl_gst;
  final String gst_price;
  final String invoice_price;
  bool isexpanded;
  bool image_expand;
  bool iscollapsage;
  bool isLoading;
  double imagesizeheight;
  double imagesizewidth;
  AlignmentGeometry alignment;


  CategoryProductList({
    @required this.category_id,
    @required this.cproduct_id,
    @required this.category_name,
    @required this.is_active,
    @required this.productname,
    @required this.productprice,
    @required this.minmum_qua,
    @required this.original_minmum_qua,
    @required this.image1,
    @required this.image2,
    @required this.image3,
    @required this.isexpanded,
    @required this.image_expand,
    @required this.iscollapsage,
    @required this.imagesizeheight,
    @required this.imagesizewidth,
    @required this.alignment,
    @required this.price,
    @required this.gstrate,
    @required this.gst_date,
    @required this.incl_excl_gst,
    @required this.gst_price,
    @required this.invoice_price,
    @required this.isLoading,
  });

  factory CategoryProductList.fromJson(Map<String, dynamic> json) {
    return CategoryProductList(
      category_id: json['category_id'].toString(),
      cproduct_id: json['cproduct_id'].toString(),
      category_name: json['category_name'],
      is_active: json['is_active'],
      productname: json['productname'],
      productprice: json['product_price'],
      price: json['price'],
      gstrate: json['gstrate'],
      gst_date: json['gst_date'],
      incl_excl_gst: json['incl_excl_gst'],
      gst_price: json['gst_price'],
      invoice_price: json['invoice_price'],
      minmum_qua: int.parse(json['minmum_qua']),
      original_minmum_qua: int.parse(json['minmum_qua']),
      image1: json['image1'],
      image2: json['image2']==""?"null":json['image2'],
      image3: json['image3']==""?"null":json['image3'],
      isexpanded: false,
      image_expand: false,
      isLoading: false,
      iscollapsage: true,
      imagesizeheight: 125,
      imagesizewidth: 125,
      alignment: Alignment.centerLeft,
    );
  }
}