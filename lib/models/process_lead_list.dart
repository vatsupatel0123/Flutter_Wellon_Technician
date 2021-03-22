
import 'package:flutter/material.dart';
class ProcessLeadList {
  final String order_id;
  final String customer_id;
  final String type_id;
  final String orderd_contact_number;
  final String orderd_name;
  String house_no;
  String house_name;
  String address1;
  String address2;
  String address3;
  final String pincode;
  final String latitude;
  final String longitude;
  final String olat;
  final String olong;
  final String ro_product_photo;
  final String prefer_date;
  final String prefer_time;
  final String order_date_time;
  final String expire_date_time;
  final String order_status;
  final String order_created_by;
  final String is_complete_customer;
  final String is_complete_sp;
  final String order_complete_date_time;
  final String cust_remark;
  final String created_at;
  final String updated_at;
  final String log_date_time;
  int brandid;
  int modelid;
  String brandname;
  String other_brand;
  String other_model;
  String brandimg;
  String modelname;
  String modelimg;
  String customer_name;
  String who_order_for;
  String other_cust_name;
  String other_cust_contact;
  String o_type_name;
  String o_category;
  String o_machine;
  String instance_normal;
  String payable_amount;
  String cod_pay;
  String cod_amount;
  String paymode;
  String raw_tds;
  String ro_capacity;
  String system_old_new;
  String old_year;
  String ro_img;
  String is_ro;


  ProcessLeadList({
    @required this.order_id,
    @required this.customer_id,
    @required this.type_id,
    @required this.orderd_contact_number,
    @required this.orderd_name,
    this.house_no,
    this.house_name,
    this.address1,
    this.address2,
    this.address3,
    @required this.pincode,
    @required this.latitude,
    @required this.longitude,
    @required this.olat,
    @required this.olong,
    @required this.ro_product_photo,
    @required this.prefer_date,
    @required this.prefer_time,
    @required this.order_date_time,
    @required this.expire_date_time,
    @required this.order_status,
    @required this.order_created_by,
    @required this.is_complete_customer,
    @required this.is_complete_sp,
    @required this.order_complete_date_time,
    @required this.cust_remark,
    @required this.created_at,
    @required this.updated_at,
    @required this.log_date_time,
    this.brandid,
    this.modelid,
    this.brandname,
    this.other_brand,
    this.other_model,
    this.brandimg,
    this.modelname,
    this.modelimg,
    this.customer_name,
    this.who_order_for,
    this.other_cust_name,
    this.other_cust_contact,
    this.o_type_name,
    this.o_category,
    this.o_machine,
    this.instance_normal,
    this.payable_amount,
    this.cod_pay,
    this.cod_amount,
    this.paymode,
    this.raw_tds,
    this.ro_capacity,
    this.system_old_new,
    this.old_year,
    this.ro_img,
    this.is_ro,
  });

  factory ProcessLeadList.fromJson(Map<String, dynamic> json) {
    return ProcessLeadList(
      order_id: json['order_id'].toString(),
      customer_id: json['customer_id'].toString(),
      type_id: json['type_id'].toString(),
      orderd_contact_number: json['orderd_contact_number'],
      orderd_name: json['orderd_name'],
      house_no: json['house_no_cust'],
      house_name: json['house_name_cust'],
      address1: json['address_street'],
      address2: json['address_area'],
      address3: json['address_landmark'],
      pincode: json['pincode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      olat: json['olat'],
      olong: json['olong'],
      ro_product_photo: json['ro_product_photo'],
      prefer_date: json['prefer_date'],
      prefer_time: json['prefer_time'],
      order_date_time: json['order_date_time'],
      expire_date_time: json['expire_date_time'],
      order_status: json['order_status'],
      order_created_by: json['order_created_by'],
      is_complete_customer: json['is_complete_customer'],
      is_complete_sp: json['is_complete_sp'],
      order_complete_date_time: json['order_complete_date_time'],
      cust_remark: json['cust_remark'].toString(),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      log_date_time: json['log_date_time'],
      brandid: json['brandid'],
      modelid: json['modelid'],
      brandname: json['brand_name'],
      other_brand: json['other_brand'],
      other_model: json['other_model'],
      brandimg: json['brand_img'],
      modelname: json['model_name'],
      modelimg: json['model_img'],
      customer_name: json['customer_name'],
      who_order_for: json['who_order_for'],
      other_cust_name: json['other_cust_name'],
      other_cust_contact: json['other_cust_contact'],
      o_type_name: json['o_type_name'],
      o_category: json['o_category'],
      o_machine: json['o_machine'],
      instance_normal: json['is_instance'],
      payable_amount: json['payable_amount'],
      cod_pay: json['cod_pay'],
      cod_amount: json['cod_amount'],
      paymode: json['paymode'],
      raw_tds: json['raw_tds'],
      ro_capacity: json['ro_capacity'],
      system_old_new: json['system_type'],
      old_year: json['old_year'],
      ro_img: json['ro_img'],
      is_ro: json['is_ro'],
    );
  }
}
