
import 'package:flutter/material.dart';
class OrderLogList{
  final String order_status;
  final String order_pending_date;
  final String remark;


  OrderLogList({
    @required this.order_status,
    @required this.order_pending_date,
    @required this.remark,
  });

  factory OrderLogList.fromJson(Map<String, dynamic> json) {
    return OrderLogList(
      order_status: json['order_status'],
      order_pending_date: json['order_pending_date'],
      remark: json['remark'],
    );
  }
}
