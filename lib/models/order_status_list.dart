
import 'package:flutter/material.dart';
class OrderStatusList {
  String polog_id;
  String sporder_id;
  String remark;
  String log_status;
  String log_date_time;
  String delivered_data_time;
  String created_at;
  String updated_at;
  String orderreturnday;
  String date;


  OrderStatusList({
    this.polog_id,
    this.sporder_id,
    this.remark,
    this.log_status,
    this.log_date_time,
    this.delivered_data_time,
    this.created_at,
    this.updated_at,
    this.orderreturnday,
    this.date,
  });

  factory OrderStatusList.fromJson(Map<String, dynamic> json) {
    return OrderStatusList(
        polog_id:json["polog_id"].toString(),
        sporder_id:json["sporder_id"].toString(),
        remark:json["remark"].toString(),
        log_status:json["log_status"].toString(),
        log_date_time:json["log_date_time"].toString(),
        delivered_data_time:json["delivered_data_time"].toString(),
        created_at:json["created_at"].toString(),
        updated_at:json["updated_at"].toString(),
        orderreturnday:json["orderreturnday"].toString(),
        date:json["date"].toString(),
    );
  }
}