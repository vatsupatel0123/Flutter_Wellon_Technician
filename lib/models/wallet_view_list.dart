
import 'package:flutter/material.dart';
class WalletViewList {
  final String withdraw_id;
  final String provider_id;
  final String withdraw_amount;
  final String request_date_time;
  final String withdrawal_remark;
  final String withdraw_status;
  final String status_change_datetime;
  final String status_change_remark;
  final String updated_at;
  final String created_at;


  WalletViewList({
    this.withdraw_id,
    this.provider_id,
    this.withdraw_amount,
    this.request_date_time,
    this.withdrawal_remark,
    this.withdraw_status,
    this.status_change_datetime,
    this.status_change_remark,
    this.updated_at,
    this.created_at,
  });

  factory WalletViewList.fromJson(Map<String, dynamic> json) {
    return WalletViewList(
      withdraw_id: json['withdraw_id'].toString(),
      provider_id: json['provider_id'].toString(),
      withdraw_amount: json['withdraw_amount'].toString(),
      request_date_time: json['request_date_time'],
      withdrawal_remark: json['withdrawal_remark'],
      withdraw_status: json['withdraw_status'],
      status_change_datetime: json['status_change_datetime'],
      status_change_remark: json['status_change_remark'],
      updated_at: json['updated_at'],
      created_at: json['created_at'],
    );
  }
}
