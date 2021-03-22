import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/category_list.dart';
import 'package:wellon_partner_app/models/categoryproduct_list.dart';
import 'package:wellon_partner_app/models/product_cart_list.dart';
import 'package:wellon_partner_app/screens/shop/product_list_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import '../../sizeconfig.dart';
import 'order_thankyou.dart';

class PlaceOrderScreen extends StatefulWidget {
  final double total;
  var data;
  PlaceOrderScreen({this.total,this.data});
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> with TickerProviderStateMixin{
  BuildContext _ctx;
  int counter = 0;
  double total=0;
  int radiovalue=0;
  double width,height=80,imagesizeheight=100,imagesizewidth=100;
  AlignmentGeometry _alignment = Alignment.centerLeft;
  bool _isLoading = false,visiblebottomsheet=true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  NetworkUtil _netUtil = new NetworkUtil();
  final formKey2 = new GlobalKey<FormState>();
  final formKey3 = new GlobalKey<FormState>();
  String _otpcode,mobile_numbers,buttonvalue="Pay";
  bool checkboxwallet=false,checkboxcod=false,checkboxonline=false,checkboxledger=false,filladdress=false,filladdressupdate=false,addressdiplay=true;
  String firstname,middlename,lastname,mobilenumber,emailid,address,pincode,gender,profile_photo,street,area,landmark,house_no,house_name,total_balance_normal,total_balance_ledger;
  Future<List<ProductCartList>> productcartListdata;
  Future<List<ProductCartList>> productcartListfilterData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  final CarouselController _controller = CarouselController();
  var db = new DatabaseHelper();

  String _houseno,_housename,_street,_area,_landmark,_pincode,_city_name,_state_name,city_name,state_name;
  TextEditingController _mobileno_namecontroller=new TextEditingController();
  TextEditingController _houseno_namecontroller=new TextEditingController();
  TextEditingController _housename_namecontroller=new TextEditingController();
  TextEditingController _street_namecontroller=new TextEditingController();
  TextEditingController _area_namecontroller=new TextEditingController();
  TextEditingController _landmark_namecontroller=new TextEditingController();
  TextEditingController _pincode_namecontroller=new TextEditingController();
  TextEditingController _city_name_namecontroller=new TextEditingController();
  TextEditingController _state_name_namecontroller=new TextEditingController();
  TextEditingController _about_namecontroller=new TextEditingController();

  bool isOffline = false;
  SharedPreferences prefs;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _loadprofile();
    _loadWalletamt();
  }


  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }
  _loadWalletamt() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      total=widget.total;
      _netUtil.post(RestDatasource.HOME_COUNT_ORDER, body: {
        "provider_id": prefs.getString("provider_id"),
      }).then((dynamic res) async {
        setState(() {
          print(res);
          total_balance_normal = res["total_balance_normal"].toString();
          total_balance_ledger = res["total_balance_ledger"].toString();
          print(total_balance_normal);
        });
      });
    });
  }
  _loadprofile() async {
    prefs = await SharedPreferences.getInstance();
    mobile_numbers= prefs.getString("mobile_numbers") ?? '';
    setState(() {
      _netUtil.post(RestDatasource.GET_REGISTER_DATA, body: {
        "mobile_numbers":mobile_numbers,
      }).then((dynamic res) async {
        print(res);
        setState(() {
          firstname=res[0]["first_name"];
          middlename=res[0]["middle_name"];
          lastname=res[0]["last_name"];
          emailid=res[0]["email_id"];
          gender=res[0]["gender"];
          house_no=res[0]["house_no"];
          house_name=res[0]["house_name"];
          street=res[0]["address1"];
          area=res[0]["address2"];
          landmark=res[0]["address3"];
          pincode=res[0]["pincode"];
          city_name=res[0]["city_name"];
          state_name=res[0]["state_name"];

          profile_photo=res[0]["profile_photo"];
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Place Order",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.green,
          ),
            resizeToAvoidBottomInset: false,
            body:
            Stack(
              children: [
                SingleChildScrollView(
                  child: Visibility(
                  visible: filladdressupdate,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        children: [
                          Form(
                            key: formKey3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Mobile No", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  initialValue: null,
                                  controller: _mobileno_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) {
                                    setState(() {
                                      mobile_numbers = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      mobile_numbers = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter House No";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'Mobile No'
                                  ),),
                                SizedBox(height: 15,),
                                Container(
                                  child: Text("House / Unit No", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  initialValue: null,
                                  controller: _houseno_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _houseno = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _houseno = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter House No";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'House / Unit No'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("House / Unit Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  initialValue: null,
                                  controller: _housename_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _housename = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _housename = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter House Name";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'House / Unit Name'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("Street", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  initialValue: null,
                                  controller: _street_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _street = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _street = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter Street";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'Street'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("Area", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  initialValue: null,
                                  controller: _area_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _area = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _area = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter Area";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'Area'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("Landmark", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  initialValue: null,
                                  controller: _landmark_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _landmark = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _landmark = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Enter Landmark";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'Landmark'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("Pincode", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: null,
                                  controller: _pincode_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) {
                                    setState(() {
                                      _pincode = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _pincode = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length != 6)
                                      return "Valid Pincode digit";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'Pin Code'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("State Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: null,
                                  controller: _state_name_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _state_name = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _state_name = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Valid Pincode digit";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'State Name'
                                  ),),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Text("City Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: null,
                                  controller: _city_name_namecontroller,
                                  obscureText: false,
                                  style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                  keyboardType: TextInputType.text,
                                  onSaved: (val) {
                                    setState(() {
                                      _city_name = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _city_name = val;
                                    });
                                  },
                                  validator: (val){
                                    if (val.length == 0)
                                      return "Valid Pincode digit";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.lato(color: Colors.black),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.lightGreen.shade500
                                          )
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.white24)
                                        //borderSide: const BorderSide(),
                                      ),
                                      hintText: 'City Name'
                                  ),),
                                SizedBox(height:20),
                                InkWell(
                                  onTap: () {
                                      final form = formKey3.currentState;
                                      if (form.validate()) {
                                        setState(() {
                                          house_no = _houseno_namecontroller.text.toString();
                                          house_name = _housename_namecontroller.text.toString();
                                          street = _street_namecontroller.text.toString();
                                          area = _area_namecontroller.text.toString();
                                          landmark = _landmark_namecontroller.text.toString();
                                          pincode = _pincode_namecontroller.text.toString();
                                          state_name = _state_name_namecontroller.text.toString();
                                          city_name = _city_name_namecontroller.text.toString();
                                          filladdressupdate = false;
                                          addressdiplay = true;
                                        });
                                      }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.green.shade600,
                                    ),
                                    child: Text("Update", style: GoogleFonts.lato(color:Colors.white,fontSize:15,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                ),
                                SizedBox(height:20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                ),
                SingleChildScrollView(
                  child: Visibility(
                    visible: filladdress,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                          children: [
                            Form(
                              key: formKey2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Mobile No", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.characters,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.number,
                                    onSaved: (val) {
                                      setState(() {
                                        mobile_numbers = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        mobile_numbers = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter House No";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'Mobile No'
                                    ),),
                                  SizedBox(height: 15,),
                                  Container(
                                    child: Text("House / Unit No", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.characters,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _houseno = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _houseno = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter House No";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'House / Unit No'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("House / Unit Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _housename = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _housename = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter House Name";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'House / Unit Name'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("Street", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _street = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _street = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter Street";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'Street'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("Area", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _area = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _area = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter Area";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'Area'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("Landmark", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _landmark = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _landmark = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Enter Landmark";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'Landmark'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("Pincode", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.number,
                                    onSaved: (val) {
                                      setState(() {
                                        _pincode = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _pincode = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length != 6)
                                        return "Valid Pincode digit";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'Pin Code'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("State Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _state_name = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _state_name = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Valid Pincode digit";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'State Name'
                                    ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text("City Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: null,
                                    obscureText: false,
                                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                    keyboardType: TextInputType.text,
                                    onSaved: (val) {
                                      setState(() {
                                        _city_name = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        _city_name = val;
                                      });
                                    },
                                    validator: (val){
                                      if (val.length == 0)
                                        return "Valid Pincode digit";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.lato(color: Colors.black),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.lightGreen.shade500
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.white24)
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintText: 'City Name'
                                    ),),
                                  SizedBox(height:20),
                                  InkWell(
                                    onTap: () {
                                      final form = formKey2.currentState;
                                      if (form.validate()) {
                                        setState(() {
                                          house_no = _houseno;
                                          house_name = _housename;
                                          street = _street;
                                          area = _area;
                                          landmark = _landmark;
                                          pincode = _pincode;
                                          city_name = _city_name;
                                          state_name = _state_name;
                                          filladdress = false;
                                          addressdiplay = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        color: Colors.green.shade600,
                                      ),
                                      child: Text("add", style: GoogleFonts.lato(color:Colors.white,fontSize:15,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: addressdiplay,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15,bottom: 15),
                        margin: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffcccccc),
                              blurRadius: 5.0,
                              spreadRadius: 0
                            )
                          ]
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total",style: TextStyle(color: Color(0xff333333),fontSize: 20)),
                              Text("$total",style: TextStyle(color: Color(0xff4cb050),fontSize: 20)),
                            ],
                          ),
                        )
                      ),
                      InkWell(
                        onTap: ()
                        {
                          print(buttonvalue);
                          print(prefs.getString("provider_id"));
                          if(buttonvalue=="Confirm")
                            {
                              _netUtil.post(RestDatasource.CREATE_ORDER, body: {
                              "provider_id":prefs.getString("provider_id"),
                              "address1":house_no+" "+house_name,
                              "address2":street+" "+area,
                              "landmark":landmark,
                              "pincode":pincode,
                              "country":"",
                              "state":state_name,
                              "city":city_name,
                              "status":"new",
                              "totalpay":total.toString(),
                              "wallet_amount":checkboxwallet?total_balance_normal:"0",
                              "wallet_pay":checkboxwallet?"Y":"N",
                              "cash_amount":checkboxcod?total.toString():"0",
                              "cash_pay":checkboxcod?"Y":"N",
                              "productdata":widget.data
                              }).then((dynamic res) async {
                                print(res);
                                if(res["status"]=="insert")
                                  {
                                    db.deleteCart();
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        childCurrent: PlaceOrderScreen(),
                                        duration: Duration(milliseconds: 500),
                                        reverseDuration: Duration(milliseconds: 500),
                                        type: PageTransitionType.bottomToTop,
                                        child: OrderThankYou(),
                                      ),
                                    );
                                  }
                                else
                                  {
                                    Fluttertoast.showToast(msg: "Contact Admin..");
                                  }
                              });
                            }
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 15,bottom: 15),
                          margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.green
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Center(child: Text("Proceed To $buttonvalue",style: TextStyle(color: Colors.white,fontSize: 20),)),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: addressdiplay,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            addressdiplay=false;
                            filladdress=true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 15,bottom: 15),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffcccccc),
                                blurRadius: 5.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                              )
                            ]
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Center(child: Text("Add New Address",style: TextStyle(color: Colors.green,fontSize: 20),)),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: Container(
                          //color : Colors.green.shade200,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Address',
                                            style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                _mobileno_namecontroller.text=mobile_numbers;
                                                _houseno_namecontroller.text=house_no;
                                                _housename_namecontroller.text=house_name;
                                                _street_namecontroller.text=street;
                                                _area_namecontroller.text=area;
                                                _landmark_namecontroller.text=landmark;
                                                _pincode_namecontroller.text=pincode;
                                                _state_name_namecontroller.text=state_name;
                                                _city_name_namecontroller.text=city_name;
                                                filladdressupdate=true;
                                                addressdiplay=false;
                                              });
                                            },
                                            child: Text(
                                              'Edit Address',
                                              style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade700),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Mobile No : $mobile_numbers",
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 18,fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        ((house_no!=null)?house_no:"")+
                                            ((house_name!=null)?" , "+house_name:""),
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        (street!=null)?street+" ,":"",
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        (landmark!=null)?landmark+" ,":"",
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        ((area!=null)?area:"")+
                                            ((pincode!=null)?" - "+pincode:""),
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        ((city_name!=null)?city_name:"")+
                                            ((state_name!=null)?" - "+state_name:""),
                                        style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: Container(
                          //color : Colors.green.shade200,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment Type',
                                        style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          decoration: checkboxwallet
                                              ? BoxDecoration(
                                            color: Colors.lightBlue[50],
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                              : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:InkWell(
                                            onTap:(){
                                                if(checkboxwallet)
                                                  {
                                                    setState(() {
                                                      total=total+double.parse(total_balance_normal);
                                                      print(total);
                                                      checkboxwallet=false;
                                                    });
                                                  }
                                                else{
                                                  setState(() {
                                                    total=total-double.parse(total_balance_normal);
                                                    if(checkboxcod)
                                                    {
                                                      setState(() {
                                                        buttonvalue="Confirm";
                                                      });
                                                    }
                                                    else
                                                    {
                                                      if(total<=double.parse(total_balance_normal))//250<=500
                                                          {
                                                        setState(() {
                                                          buttonvalue="Confirm";
                                                        });
                                                      }
                                                      else{
                                                        setState(() {
                                                          buttonvalue="Pay";
                                                        });
                                                      }
                                                    }
                                                    print(total);
                                                    checkboxwallet=true;
                                                  });
                                                }
                                            },
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Center(
                                                          child: Checkbox(
                                                            value: checkboxwallet,
                                                            activeColor: Colors.green,
                                                            onChanged: (bool val){
                                                              setState(() {
                                                                if(val){
                                                                  setState(() {
                                                                    total=total-double.parse(total_balance_normal);
                                                                    if(checkboxcod)
                                                                    {
                                                                      setState(() {
                                                                        buttonvalue="Confirm";
                                                                      });
                                                                    }
                                                                    else
                                                                    {
                                                                      if(total<=double.parse(total_balance_normal))//250<=500
                                                                          {
                                                                        setState(() {
                                                                          buttonvalue="Confirm";
                                                                        });
                                                                      }
                                                                      else{
                                                                        setState(() {
                                                                          buttonvalue="Pay";
                                                                        });
                                                                      }
                                                                    }
                                                                    checkboxwallet=val;
                                                                  });
                                                                }
                                                                else
                                                                  {
                                                                    setState(() {
                                                                      total=total+double.parse(total_balance_normal);
                                                                      checkboxwallet=val;
                                                                    });
                                                                  }
                                                              });
                                                            },
                                                          )
                                                      ),
                                                      Text("Pay from Wallet",style: TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: Text("₹${total_balance_normal??"0"}",style: TextStyle(fontSize: 18),),
                                                  ),
                                                ],
                                              ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          decoration: checkboxledger
                                              ? BoxDecoration(
                                            color: Colors.lightBlue[50],
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                              : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:InkWell(
                                            onTap:(){
                                              if(checkboxledger)
                                              {
                                                setState(() {
                                                  total=total+double.parse(total_balance_ledger);
                                                  print(total);
                                                  checkboxledger=false;
                                                });
                                              }
                                              else{
                                                setState(() {
                                                  total=total-double.parse(total_balance_ledger);
                                                  if(checkboxledger)
                                                  {
                                                    setState(() {
                                                      buttonvalue="Confirm";
                                                    });
                                                  }
                                                  else
                                                  {
                                                    if(total<=double.parse(total_balance_ledger))//250<=500
                                                        {
                                                      setState(() {
                                                        buttonvalue="Confirm";
                                                      });
                                                    }
                                                    else{
                                                      setState(() {
                                                        buttonvalue="Pay";
                                                      });
                                                    }
                                                  }
                                                  print(total);
                                                  checkboxledger=true;
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Center(
                                                        child: Checkbox(
                                                          value: checkboxledger,
                                                          activeColor: Colors.green,
                                                          onChanged: (bool val){
                                                            setState(() {
                                                              if(val){
                                                                setState(() {
                                                                  total=total-double.parse(total_balance_ledger);
                                                                  if(checkboxledger)
                                                                  {
                                                                    setState(() {
                                                                      buttonvalue="Confirm";
                                                                    });
                                                                  }
                                                                  else
                                                                  {
                                                                    if(total<=double.parse(total_balance_ledger))//250<=500
                                                                        {
                                                                      setState(() {
                                                                        buttonvalue="Confirm";
                                                                      });
                                                                    }
                                                                    else{
                                                                      setState(() {
                                                                        buttonvalue="Pay";
                                                                      });
                                                                    }
                                                                  }
                                                                  checkboxledger=val;
                                                                });
                                                              }
                                                              else
                                                              {
                                                                setState(() {
                                                                  total=total+double.parse(total_balance_ledger);
                                                                  checkboxledger=val;
                                                                });
                                                              }
                                                            });
                                                          },
                                                        )
                                                    ),
                                                    Text("Pay from Ledger",style: TextStyle(fontSize: 18),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Text("₹${total_balance_ledger??"0"}",style: TextStyle(fontSize: 18),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          decoration: checkboxcod
                                              ? BoxDecoration(
                                            color: Colors.lightBlue[50],
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                              : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:InkWell(
                                            onTap:(){
                                              setState((){
                                                if(checkboxcod)
                                                  {
                                                    buttonvalue="Pay";
                                                    checkboxcod=false;
                                                  }
                                                else
                                                  {
                                                    checkboxcod=true;
                                                    buttonvalue="Confirm";
                                                  }
                                              });
                                            },
                                            child: Row(
                                                children: [
                                                  Center(
                                                      child: Checkbox(
                                                        value: checkboxcod,
                                                        activeColor: Colors.green,
                                                        onChanged: (bool val){
                                                          setState(() {
                                                            checkboxcod=val;
                                                            if(val)
                                                            {
                                                              buttonvalue="Confirm";
                                                            }
                                                            else
                                                            {
                                                              buttonvalue="Pay";
                                                            }
                                                          });
                                                        },
                                                      )
                                                  ),
                                                  Text("Cash On Delivery / COD",style: TextStyle(fontSize: 18)),
                                                ],
                                              ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          decoration: checkboxonline
                                              ? BoxDecoration(
                                            color: Colors.lightBlue[50],
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                              : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:InkWell(
                                            onTap:(){
                                              setState((){
                                                if(checkboxonline)
                                                {
                                                  buttonvalue="Pay";
                                                  checkboxonline=false;
                                                }
                                                else
                                                {
                                                  checkboxonline=true;
                                                  buttonvalue="Confirm";
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Center(
                                                    child: Checkbox(
                                                      value: checkboxonline,
                                                      activeColor: Colors.green,
                                                      onChanged: (bool val){
                                                        setState(() {
                                                          checkboxonline=val;
                                                          if(val)
                                                          {
                                                            buttonvalue="Confirm";
                                                          }
                                                          else
                                                          {
                                                            buttonvalue="Pay";
                                                          }
                                                        });
                                                      },
                                                    )
                                                ),
                                                Text("Online",style: TextStyle(fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}