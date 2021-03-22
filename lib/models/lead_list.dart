
import 'package:flutter/material.dart';
class LeadList {
  final String UserId;
  final String Name;
  final String Contact;
  final String Password;
  final String RegisteredOn;
  final String IsApprove;
  final String IsActive;
  final String Balance;


  LeadList({
    @required this.UserId,
    @required this.Name,
    @required this.Contact,
    @required this.Password,
    @required this.IsApprove,
    @required this.IsActive,
    @required this.RegisteredOn,
    @required this.Balance,
  });

  factory LeadList.fromJson(Map<String, dynamic> json) {
    return LeadList(
      UserId: json['UserId'],
      Name: json['Name'],
      Contact: json['Contact'],
      Password: json['Password'],
      RegisteredOn: json['RegisteredOn'],
      IsApprove: json['IsApprove'],
      IsActive: json['IsActive'],
      Balance: json['Balance'],
    );
  }
}
