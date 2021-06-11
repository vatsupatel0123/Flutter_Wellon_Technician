import 'package:flutter/material.dart';
class NotificationList {
  final String notification_id;
  final String provider_id;
  final String order_id;
  final String noti_title;
  final String noti_description;
  final String created_at;
  final String updated_at;

  NotificationList({
    @required this.notification_id,
    @required this.provider_id,
    @required this.order_id,
    @required this.noti_title,
    @required this.noti_description,
    @required this.created_at,
    @required this.updated_at,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    return NotificationList(
      notification_id: json['notification_id'].toString(),
      provider_id: json['provider_id'].toString(),
      order_id: json['order_id'].toString(),
      noti_title: json['noti_title'],
      noti_description: json['noti_description'],
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
    );
  }
}
