import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/models/user.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://wellonwater.com/";
  //static final BASE_URL = "http://wellonwater.com/test/demotest/";
  static final KARON = "https://karoninfotech.com/";
  static final BASE_URL_APP = BASE_URL + "api/";
  static final URL_GET_WEBSITE_TERM_AND_CONDITIONS = BASE_URL + "TermsCondition";

  static final URL_LOGIN = BASE_URL_APP + "login";
  static final URL_LOGIN_OTP = BASE_URL_APP + "spotpverify";
  static final RESEND_OTP= BASE_URL_APP + "resendotpspreg";
  static final GET_REGISTER_DATA = BASE_URL_APP + "registerserviceprovider";
  static final GET_REFCODE = BASE_URL_APP + "getreferralcodeamount";
  static final URL_REGISTER_UPDATE = BASE_URL_APP + "registerspupdate";

  static final HOME_COUNT_ORDER = BASE_URL_APP + "getspallordercounter";

  static final GET_NEW_ORDER= BASE_URL_APP + "getpendingorderlist";
  static final GET_Notification_NEW_ORDER= BASE_URL_APP + "getnotificationorder";
  static final ACCEPT_NEW_ORDER= BASE_URL_APP + "getacceptorderlist";
  static final REJECT_NEW_ORDER= BASE_URL_APP + "getrejectorderlist";
  static final CANCEL_PROCESS_ORDER= BASE_URL_APP + "getordercancelsp";

  //Shopping
  static final GET_CATEGORY= BASE_URL_APP + "getcategorylist";
  static final GET_CATEGORY_PRODUCT= BASE_URL_APP + "categoryproductlist";
  static final ADD_TO_CART= BASE_URL_APP + "addtocart";
  static final GET_CART_LIST= BASE_URL_APP + "cartlist";
  static final UPDATE_CART= BASE_URL_APP + "cartqunupdate";
  static final ADD_TO_CARTLIST_DELETE= BASE_URL_APP + "addtocartlistdelete";
  static final CART_LIST_DELETE= BASE_URL_APP + "addtocartallproductdelete";
  //shoppping

  static final GET_PROCCESS_ORDER= BASE_URL_APP + "getprocessorderlist";
  static final ACCEPT_PROCCESS_ORDER= BASE_URL_APP + "getcompleteorderlist";
  static final COMPLETE_ORDER_FIRST= BASE_URL_APP + "completeorderfirst";
  static final GET_SP_ORDERAMT= BASE_URL_APP + "getcompleteordermoney";

  static final GET_COMPLETE_ORDER= BASE_URL_APP + "getcompleteallorderlist";
  static final GET_COMPLETE_ORDER_LOG= BASE_URL_APP + "getorderloglist";

  static final GET_CANCEL_ORDER= BASE_URL_APP + "getcancelorderlist";

  static final URL_PROFILE_DATA= BASE_URL_APP + "getsplatlonglist";
  static final VERSION_CHECK= BASE_URL_APP + "versioncheck";
  static final URL_CHANGE_LOCATION= BASE_URL_APP + "getsplatlongupdatelist";
  static final URL_CHANGE_ACTIVE= BASE_URL_APP + "getspactiveupdate";
  static final URL_CHANGE_REVIEW= BASE_URL_APP + "getaboutupdate";

  static final SEND_PROFILE_PHOTO= BASE_URL_APP + "spprofileupdate";
  static final SEND_AADHAR_PHOTO= BASE_URL_APP + "spaadharcardupdate";
  static final SEND_VISITING_FPHOTO= BASE_URL_APP + "spvisitingcardfrontupdate";
  static final SEND_VISITING_LPHOTO= BASE_URL_APP + "spvisitingcardbackupdate";
  static final SEND_PANCARD_PHOTO= BASE_URL_APP + "pancardpicupdate";
  static final SEND_GST_PHOTO= BASE_URL_APP + "gstcertipicupdate";
  static final GET_ALL_PHOTO= BASE_URL_APP + "getallspphotos";

  static final GET_LAT_LONG= BASE_URL_APP + "getregsplatlongreturn";
  static final UPDATE_LAT_LONG= BASE_URL_APP + "getregsplatlongupdate";
  static final UPDATE_ADDRESS= BASE_URL_APP + "spaddressupdate";

  static final GET_SP_SERVICE= BASE_URL_APP + "getregspservicetypereturn";
  static final UPDATE_SP_SERVICE= BASE_URL_APP + "getregspservicetype";

  static final GET_CUS_ORDER_RATING= BASE_URL_APP + "getorderrating";
  static final GET_ORDER_KIT= BASE_URL_APP + "getorderproductkit";

  static final GET_WITHDRAW_MONEY= BASE_URL_APP + "getwithdrawmoneyreturn";
  static final SEND_WITHDRAW_MONEY_REQ= BASE_URL_APP + "getwithdrawmoney";
  static final GET_WALLET_NORMAL= BASE_URL_APP + "getwalletnormal";
  static final GET_WALLET_LEDGER= BASE_URL_APP + "getwalletledger";
  static final GET_WALLET_TOTAL_AMT= BASE_URL_APP + "gettotalbalance";
  static final SCANNER_REWARD= BASE_URL_APP + "productscannercheck";

  static final URL_NOTIFICATION = BASE_URL_APP + "notificationserviceprovide";
  static final URL_CHANGE_PASSWORD = BASE_URL_APP + "ChangePassword";

  static final CONTACT_UPDATE = BASE_URL_APP + "getcontactnumberupdate";
  static final CONTACT_UPDATE_OTP_CHECK = BASE_URL_APP + "contactupdateotpcheck";

  static final URL_SHOPPING = BASE_URL_APP + "https://flutter.io";
  static final GET_USERS_URL = "https://newbarkatichicken.in/api/getusers.php";
  static final GET_NEW_ = BASE_URL_APP + "getpendingorderlist";

  static final GET_SELECT_AMC_PRODUCT = BASE_URL_APP + "getAmcProduct";
  static final AMC_PRODUCT_IMAGE = BASE_URL + "productimages/";

  //Create Order
  static final CREATE_ORDER = BASE_URL_APP + "createsporder";
  static final MY_ORDER = BASE_URL_APP + "spproductorderlist";
  static final MY_ORDER_DETAILS = BASE_URL_APP + "spproductorderdetails";
  static final MY_ORDER_CANCEL = BASE_URL_APP + "spordercancel";
  static final MY_ORDER_STATUS = BASE_URL_APP + "sporderstatus";
  static final GET_BANK_NAME = BASE_URL_APP + "getBankList";
  //Create Order





  Future<User> login(String username, String password,String token) {
    return _netUtil.post(URL_LOGIN_OTP, body: {
      "provider_id": username,
      "sp_otp_code": password,
      "notification_token":token
    }).then((dynamic res) async {
      //print(res.toString());
      if(res["status"]=="false")throw new Exception("error");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("spfullname", res["spfullname"].toString());
      prefs.setString("provider_id", res["userdata"][0]["provider_id"].toString());
      prefs.setString("mobile_numbers", res["userdata"][0]["mobile_numbers"].toString());
      prefs.setString("first_name", res["userdata"][0]["first_name"].toString());
      prefs.setString("middle_name", res["userdata"][0]["middle_name"].toString());
      prefs.setString("last_name", res["userdata"][0]["last_name"].toString());
      prefs.setString("email_id", res["userdata"][0]["email_id"].toString());
      prefs.setString("latitude", res["userdata"][0]["latitude"].toString());
      prefs.setString("longitude", res["userdata"][0]["longitude"].toString());
      prefs.setString("profile_photo", res["userdata"][0]["profile_photo"].toString());
      return new User.map(res["userdata"][0]);
    });
  }


}