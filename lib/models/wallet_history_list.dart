
import 'package:flutter/material.dart';
class WalletHistoryList {
  final String withdraw_id;
  final String provider_id;
  final String order_id;
  final String amount;
  final String amount_type;
  final String amount_status;
  final String wallet_date_time;
  final String updated_at;
  final String created_at;
  final String wallet_remark;


  WalletHistoryList({
    @required this.withdraw_id,
    @required this.provider_id,
    @required this.order_id,
    @required this.amount,
    @required this.amount_type,
    @required this.amount_status,
    @required this.wallet_date_time,
    @required this.updated_at,
    @required this.created_at,
    @required this.wallet_remark,
  });

  factory WalletHistoryList.fromJson(Map<String, dynamic> json) {
    return WalletHistoryList(
      withdraw_id: json['withdraw_id'].toString(),
      provider_id: json['provider_id'].toString(),
      order_id: json['order_id'].toString(),
      amount: json['amount'],
      amount_type: json['amount_type'],
      amount_status: json['amount_status'],
      wallet_date_time: json['wallet_date_time'],
      updated_at: json['updated_at'],
      created_at: json['created_at'],
      wallet_remark: json['wallet_remark'],
    );
  }
}
