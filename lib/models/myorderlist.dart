import 'package:flutter/material.dart';

class MyorderList {
  final String sporder_id;
  final String provider_id;
  final String address1;
  final String address2;
  final String landmark;
  final String pincode;
  final String country;
  final String state;
  final String city;
  final String status;
  final String totalpay;
  final String wallet_amount;
  final String wallet_pay;
  final String cash_amount;
  final String cash_pay;
  final String order_date_time;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String mobile_numbers;
  final String totalproduct;

  MyorderList({
    @required this.sporder_id,
    @required this.provider_id,
    @required this.address1,
    @required this.address2,
    @required this.landmark,
    @required this.pincode,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.status,
    @required this.totalpay,
    @required this.wallet_amount,
    @required this.wallet_pay,
    @required this.cash_amount,
    @required this.cash_pay,
    @required this.order_date_time,
    @required this.first_name,
    @required this.middle_name,
    @required this.last_name,
    @required this.mobile_numbers,
    @required this.totalproduct,
  });

  factory MyorderList.fromJson(Map<String, dynamic> json) {
    return MyorderList(
      sporder_id: json["productsdetails"]['sporder_id'].toString(),
      provider_id: json["productsdetails"]['provider_id'].toString(),
      address1: json["productsdetails"]['address1'],
      address2: json["productsdetails"]['address2'],
      landmark: json["productsdetails"]['landmark'].toString(),
      pincode: json["productsdetails"]['pincode'].toString(),
      country: json["productsdetails"]['country'].toString(),
      state: json["productsdetails"]['state'].toString(),
      city: json["productsdetails"]['city'].toString(),
      status: json["productsdetails"]['status'].toString(),
      totalpay: json["productsdetails"]['totalpay'].toString(),
      wallet_amount: json["productsdetails"]['wallet_amount'].toString(),
      wallet_pay: json["productsdetails"]['wallet_pay'].toString(),
      cash_amount: json["productsdetails"]['cash_amount'].toString(),
      cash_pay: json["productsdetails"]['cash_pay'].toString(),
      order_date_time: json["productsdetails"]['order_date_time'].toString(),
      first_name: json["productsdetails"]['first_name'].toString(),
      middle_name: json["productsdetails"]['middle_name'].toString(),
      last_name: json["productsdetails"]['last_name'].toString(),
      mobile_numbers: json["productsdetails"]['mobile_numbers'].toString(),
      totalproduct: json['totalproduct'].toString(),
    );
  }
}