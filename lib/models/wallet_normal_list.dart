
import 'package:flutter/material.dart';
class WalletNormal {
  final String wallet_id;
  final String provider_id;
  final String order_id;
  final String sp_trans_id;
  final String amount;
  final String amount_type;
  final String amount_status;
  final String wallet_date_time;
  final String updated_at;
  final String created_at;
  final String wallet_type;
  final String wallet_remark;


  WalletNormal({
    @required this.wallet_id,
    @required this.provider_id,
    @required this.order_id,
    @required this.sp_trans_id,
    @required this.amount,
    @required this.amount_type,
    @required this.amount_status,
    @required this.wallet_date_time,
    @required this.updated_at,
    @required this.created_at,
    @required this.wallet_type,
    @required this.wallet_remark,
  });

  factory WalletNormal.fromJson(Map<String, dynamic> json) {
    return WalletNormal(
      wallet_id: json['wallet_id'].toString(),
      provider_id: json['provider_id'].toString(),
      order_id: json['order_id'].toString(),
      sp_trans_id: json['sp_trans_id'].toString(),
      amount: json['amount'],
      amount_type: json['amount_type'],
      amount_status: json['amount_status'],
      wallet_date_time: json['wallet_date_time'],
      updated_at: json['updated_at'],
      created_at: json['created_at'],
      wallet_type: json['wallet_type'],
      wallet_remark: json['wallet_remark'],
    );
  }
}
