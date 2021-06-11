
import 'package:flutter/material.dart';
class CartList {
  String cart_id;
  String provider_id;
  String cproduct_id;
  String quantity;
  String is_deleted;
  String created_at;
  String updated_at;
  String category_id;
  String productname;
  String productprice;
  int qty;
  String minmum_qua;
  String image1;
  String image2;
  String image3;
  String is_active;
  String gstrate;
  String gst_date;
  String price;
  String incl_excl_gst;
  String gst_price;
  String invoice_price;
  String value;


  CartList({
    this.cart_id,
    this.provider_id,
    this.cproduct_id,
    this.quantity,
    this.is_deleted,
    this.created_at,
    this.updated_at,
    this.category_id,
    this.productname,
    this.productprice,
    this.qty,
    this.minmum_qua,
    this.image1,
    this.image2,
    this.image3,
    this.is_active,
    this.gstrate,
    this.gst_date,
    this.price,
    this.incl_excl_gst,
    this.gst_price,
    this.invoice_price,
    this.value
  });

  factory CartList.fromJson(Map<String, dynamic> json) {
    return CartList(
        cart_id:json["cart_id"].toString(),
        provider_id:json["provider_id"].toString(),
        cproduct_id:json["cproduct_id"].toString(),
        quantity:json["quantity"].toString(),
        is_deleted:json["is_deleted"].toString(),
        created_at:json["created_at"].toString(),
        updated_at:json["updated_at"].toString(),
        category_id:json["category_id"].toString(),
        productname:json["productname"].toString(),
        productprice:json["product_price"].toString(),
        minmum_qua:json["minmum_qua"].toString(),
        image1:json["image1"].toString(),
        image2:json["image2"].toString(),
        image3:json["image3"].toString(),
        is_active:json["is_active"].toString(),
        gstrate:json["gstrate"].toString(),
        gst_date:json["gst_date"].toString(),
        price:json["price"].toString(),
        incl_excl_gst:json["incl_excl_gst"].toString(),
        gst_price:json["gst_price"].toString(),
        invoice_price:json["invoice_price"].toString(),
        qty:int.parse(json["quantity"]),
        value:""
    );
  }
}