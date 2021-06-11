
import 'package:flutter/material.dart';
class ProfileList {
  final String service_provider_lat;
  final String service_provider_long;
  final String about;
  final String short_description;
  final String shop_code;
  final String is_active;


  ProfileList({
    @required this.service_provider_lat,
    @required this.service_provider_long,
    @required this.about,
    @required this.short_description,
    @required this.shop_code,
    @required this.is_active,
  });

  factory ProfileList.fromJson(Map<String, dynamic> json) {
    return ProfileList(
      service_provider_lat: json['service_provider_lat'],
      service_provider_long: json['service_provider_long'],
      about: json['about'],
      short_description: json['short_description'],
      shop_code: json['shop_code'],
      is_active: json['is_active'],
    );
  }
}
