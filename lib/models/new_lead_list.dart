
import 'package:flutter/material.dart';
class NewLeadList {
  String serviceprovider_name;
  String order_id;
  String prefer_date;
  String prefer_time;
  String house_no;
  String house_name;
  String address1;
  String address2;
  String address3;
  String google_address;
  String pincode;
  String order_date_time;
  String expire_date_time;
  String expire_time;
  String olat;
  String olong;
  String slat;
  String slong;
  String km;
  String service_type;
  int brandid;
  int modelid;
  String brandname;
  String otherbrand;
  String othermodel;
  String brandimg;
  String modelname;
  String modelimg;
  String ro_img;
  String instance_normal;
  String customer_name;
  String other_customer_name;
  String other_customer_number;
  String who_order;
  String customer_remark;
  String o_type_name;
  String o_category;
  String o_machine;
  String payable_amount;
  String raw_tds;
  String ro_capacity;
  String system_old_new;
  String old_year;
  String is_ro;


  NewLeadList({
    this.serviceprovider_name,
    this.order_id,
    this.prefer_date,
    this.prefer_time,
    this.house_no,
    this.house_name,
    this.address1,
    this.address2,
    this.address3,
    this.google_address,
    this.pincode,
    this.order_date_time,
    this.expire_date_time,
    this.expire_time,
    this.olat,
    this.olong,
    this.slat,
    this.slong,
    this.km,
    this.service_type,
    this.brandid,
    this.modelid,
    this.brandname,
    this.otherbrand,
    this.othermodel,
    this.brandimg,
    this.modelname,
    this.modelimg,
    this.ro_img,
    this.instance_normal,
    this.customer_name,
    this.other_customer_name,
    this.other_customer_number,
    this.who_order,
    this.customer_remark,
    this.o_type_name,
    this.o_category,
    this.o_machine,
    this.payable_amount,
    this.raw_tds,
    this.ro_capacity,
    this.system_old_new,
    this.old_year,
    this.is_ro,
  });

  factory NewLeadList.fromJson(Map<String, dynamic> json) {
    return NewLeadList(
      serviceprovider_name: json['serviceprovider_name'],
      order_id: json['order_id'].toString(),
      prefer_date: json['prefer_date'],
      prefer_time: json['prefer_time'],
      house_no: json['house_no_cust'],
      house_name: json['house_name_cust'],
      address1: json['address_street'],
      address2: json['address_area'],
      address3: json['address_landmark'],
      google_address: json['google_address'],
      pincode: json['pincode'],
      order_date_time: json['order_date_time'],
      expire_date_time: json['expire_date_time'],
      //minute:expire_date_time.minute,
      expire_time: json['expire_time'],
      olat: json['olat'],
      olong: json['olong'],
      slat: json['slat'],
      slong: json['slong'],
      km: json['km'],
      service_type: json['service_type'],
      brandid: json['brandid'],
      modelid: json['modelid'],
      brandname: json['brandname'],
      otherbrand: json['otherbrand'],
      othermodel: json['othermodel'],
      brandimg: json['brandimg'],
      modelname: json['modelname'],
      modelimg: json['modelimg'],
      ro_img: json['ro_product_photo'],
      instance_normal: json['instance_normal'],
      customer_name: json['customer_name'],
      other_customer_name: json['other_customer_name'],
      other_customer_number: json['other_customer_number'],
      who_order: json['who_order'],
      customer_remark: json['customer_remark'],
      o_type_name: json['o_type_name'],
      o_category: json['o_category'],
      o_machine: json['o_machine'],
      payable_amount: json['payable_amount'],
      raw_tds: json['raw_tds'],
      ro_capacity: json['ro_capacity'],
      system_old_new: json['system_old_new'],
      old_year: json['old_year'],
      is_ro: json['is_ro'],
    );
  }
}
