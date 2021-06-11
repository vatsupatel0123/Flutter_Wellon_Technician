import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  BuildContext _ctx;

  //GLOBLE DECLARE SHAREPRE
  bool _isdataLoading = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();

  String _myActivity;
  String _myActivityResult;

  String spfullname="",provider_id="0";
  String mobileNo="",emailval="";
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _firstname,_middlename,_lastname,_mobilenumber,_emailid,_address,_pincode,_referral;
  String _firmname,_houseno,_housename,_street,_area,_landmark,_pancard,_aadharcard,_gst;
  String firstname,middlename,lastname,mobilenumber,emailid,address,pincode,gender,ref_code;
  String tech_firm_name,house_no,house_name,address1,address2,address3,gst_number,aadhar_number,pancard_number;
  int _radioValue1=0;
  SharedPreferences prefs;
  String _coachingLevel = 'Education Level';

  NetworkUtil _netUtil = new NetworkUtil();

  TextEditingController _first_namecontroller=new TextEditingController();
  TextEditingController _middle_namecontroller=new TextEditingController();
  TextEditingController _last_namecontroller=new TextEditingController();
  TextEditingController _number_namecontroller=new TextEditingController();
  TextEditingController _email_namecontroller=new TextEditingController();
  TextEditingController _gender_namecontroller=new TextEditingController();
  TextEditingController _address_namecontroller=new TextEditingController();
  TextEditingController _firmname_namecontroller=new TextEditingController();
  TextEditingController _houseno_namecontroller=new TextEditingController();
  TextEditingController _housename_namecontroller=new TextEditingController();
  TextEditingController _street_namecontroller=new TextEditingController();
  TextEditingController _area_namecontroller=new TextEditingController();
  TextEditingController _landmark_namecontroller=new TextEditingController();
  TextEditingController _pincode_namecontroller=new TextEditingController();
  TextEditingController _pancard_namecontroller=new TextEditingController();
  TextEditingController _aadharcard_namecontroller=new TextEditingController();
  TextEditingController _gst_namecontroller=new TextEditingController();
  TextEditingController _referral_namecontroller=new TextEditingController();

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    mobileNo= prefs.getString("mobile_numbers") ?? '';
      _netUtil.post(RestDatasource.GET_REGISTER_DATA, body: {
      'mobile_numbers' : mobileNo,
      }).then((dynamic res) async {
        //print(res);
        setState(() {
          _firstname=res[0]["first_name"];
          _middlename=res[0]["middle_name"];
          _lastname=res[0]["last_name"];
          _emailid=res[0]["email_id"];
          gender=res[0]["gender"];
          _firmname=res[0]["tech_firm_name"];
          _houseno=res[0]["house_no"];
          _housename=res[0]["house_name"];
          _street=res[0]["address1"];
          _area=res[0]["address2"];
          _landmark=res[0]["address3"];
          _pincode=res[0]["pincode"];
          _gst=res[0]["gst_number"];
          _aadharcard=res[0]["aadhar_number"];
          _pancard=res[0]["pancard_number"];
          ref_code=res[0]["reg_sp_referal"];
          _isdataLoading=false;

          _first_namecontroller.text=_firstname;
          _middle_namecontroller.text=_middlename;
          _last_namecontroller.text=_lastname;
          _email_namecontroller.text=_emailid;
          _firmname_namecontroller.text=_firmname;
          _houseno_namecontroller.text=_houseno;
          _housename_namecontroller.text=_housename;
          _street_namecontroller.text=_street;
          _area_namecontroller.text=_area;
          _landmark_namecontroller.text=_landmark;
          _pincode_namecontroller.text=_pincode;
          _gst_namecontroller.text=_gst;
          _pancard_namecontroller.text=_pancard;
          _aadharcard_namecontroller.text=_aadharcard;
          _referral_namecontroller.text=ref_code;
          _radioValue1=(gender=="Male")?0:1;
        });
      });
  }

  //Load Data
  //On Refresh


  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;


  @override
  initState() {
    _loadPref();
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _myActivity = '';
    _myActivityResult = '';
  }


  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      ////print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      mobileNo = arguments['mobileNo'];
      _mobilenumber=mobileNo;
      _number_namecontroller.text=_mobilenumber;
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            title: Text("Register",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w600),),
          ),
          backgroundColor: Colors.white,
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Form(
                    key: formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("First Name", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _first_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]+')),
                              ],
                              onSaved: (val) {
                                setState(() {
                                  _firstname = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _firstname = val;
                                });
                              },
                              validator: validateFirstName,
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
                                  hintText: 'First Name'
                              ),)
                        ),

                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Middle Name", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                                controller: _middle_namecontroller,
                                obscureText: false,
                                style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]+')),
                                ],
                                onSaved: (val) {
                                  setState(() {
                                    _middlename = val;
                                  });
                                },
                              onChanged: (val) {
                                setState(() {
                                  _middlename = val;
                                });
                              },
                              validator: validateMiddleName,
                              decoration: InputDecoration(
                                  labelStyle: GoogleFonts.lato(color: Colors.green),
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
                                      borderSide: BorderSide(color: Colors.white)
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintText: 'Middle Name',
                              ),)
                        ),

                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Last Name", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: _last_namecontroller,
                                obscureText: false,
                                style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]+')),
                                ],
                                onSaved: (val) {
                                  setState(() {
                                    _lastname = val;
                                  });
                                },
                              onChanged: (val) {
                                setState(() {
                                  _lastname = val;
                                });
                              },
                              validator: validateLastName,
                              decoration: InputDecoration(
                                  labelStyle: GoogleFonts.lato(color: Colors.black),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintText: 'Last Name'
                              ),)
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Technician Firm Name", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _firmname_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.text,
                              onSaved: (val) {
                                setState(() {
                                  _firmname = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _lastname = val;
                                });
                              },
                              decoration: InputDecoration(
                                  labelStyle: GoogleFonts.lato(color: Colors.black),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintText: 'Firm Name'
                              ),)
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Mobile Number", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                                controller: _number_namecontroller,
                                obscureText: false,
                                enabled: false,
                                style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                keyboardType: TextInputType.text,
                                onSaved: (val) {
                                  setState(() {
                                    _mobilenumber = val;
                                  });
                                },
                                validator: validateMobile,
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
                                      borderSide: BorderSide(color: Colors.white)
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintText: 'Enter Your Mobile Number'
                              ),)
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Gender", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Container(
                            child:Table(
                              children: [
                                TableRow(
                                    children: [
                                      TableCell(child: new Row(
                                        children: <Widget>[
                                          new Radio(
                                            value: 0,
                                            activeColor: Colors.green,
                                            groupValue: _radioValue1,
                                            onChanged: (value) {
                                              setState(() {
                                                _radioValue1 = value;
                                                //print(_radioValue1);
                                              }
                                              );

                                            },
                                          ),
                                          new Text('Male', style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                          new Radio(
                                            value: 1,
                                            activeColor: Colors.green,
                                            groupValue: _radioValue1,
                                            onChanged: (value) {
                                              setState(() {
                                                _radioValue1 = value;
                                                //print(_radioValue1);
                                              });
                                            },
                                          ),
                                          new Text('Female', style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                        ],
                                      )),
                                    ]
                                ),
                              ],
                            ),

                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Email ID", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              initialValue: null,
                              controller: _email_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (val) {
                                setState(() {
                                  _emailid = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _emailid = val;
                                });
                              },
                              validator: validateEmail,
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
                                      borderSide: BorderSide(color: Colors.white)
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintText: 'Enter Your Email ID'
                              ),)
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Container(
                                child: Text("House / Unit No", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Container(
                                child: Text("House / Unit Name", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                    ),)
                              ),
                            ),
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                        hintText: 'House / Building / Unit Name'
                                    ),)
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Container(
                                child: Text("Street", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Container(
                                child: Text("Area", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                    ),)
                              ),
                            ),
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                    ),)
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Container(
                                child: Text("Landmark", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Container(
                                child: Text("Pincode", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                    ),)
                              ),
                            ),
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: TextFormField(
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
                                    maxLength: 6,
                                      validator: validatePin,
                                    decoration: InputDecoration(
                                      counterText: "",
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
                                    ),)
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("PAN Card Number", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              initialValue: null,
                              controller: _pancard_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.text,
                              onSaved: (val) {
                                setState(() {
                                  _pancard = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _pancard = val;
                                });
                              },
                              maxLength: 10,
                              validator: validatepancard,
                              decoration: InputDecoration(
                                counterText: "",
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
                                  hintText: 'PAN Card Number'
                              ),)
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Aadhar Card Number", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              controller: _aadharcard_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.number,
                              onSaved: (val) {
                                setState(() {
                                  _aadharcard = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _aadharcard = val;
                                });
                              },
                              maxLength: 12,
                              validator: (val){
                                  if (val.length != 12)
                                    return "Enter Valid Adharcard No";
                                  else
                                    return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
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
                                  hintText: 'Aadhar Card No'
                              ),)
                        ),
                        SizedBox(
                          height: 3,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("GST Number(Optional)", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              controller: _gst_namecontroller,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              keyboardType: TextInputType.text,
                              onSaved: (val) {
                                setState(() {
                                  _gst = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _gst = val;
                                });
                              },
                              maxLength: 15,
                              validator: validategst,
                              decoration: InputDecoration(
                                counterText: "",
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
                                  hintText: 'GST Number'
                              ),)
                        ),
                        SizedBox(
                          height: 3,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text("Referral Code(Optional)", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: TextFormField(
                              controller: _referral_namecontroller,
                              enabled: (ref_code==null)?true:false,
                              obscureText: false,
                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              onSaved: (val) {
                                setState(() {
                                  _referral = val.toUpperCase();
                                  _referral_namecontroller.text=_referral;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _referral = val.toUpperCase();
                                });
                              },
                              validator: validaterefel,
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
                                  hintText: 'Referral Code'
                              ),)
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
//                          Navigator.of(_ctx).pushReplacementNamed("/registrationsecond");
                        if (_isLoading == false) {
                          final form = formKey.currentState;
                          if (form.validate()) {
                            //print("hii");
                            //print(_referral_namecontroller.text);
                            //print(form.validate());
                            setState(() => _isLoading = true);
                            form.save();
                            NetworkUtil _netUtil = new NetworkUtil();
                            _netUtil.post(RestDatasource.URL_REGISTER_UPDATE, body: {
                              "first_name": _firstname,
                              "middle_name": _middlename,
                              "last_name": _lastname,
                              "mobile_numbers": _mobilenumber,
                              "email_id": _emailid,
                              "gender":(_radioValue1==0)?"Male":"Female",
                              "tech_firm_name": _firmname,
                              "house_no": _houseno,
                              "house_name": _housename,
                              "address1": _street,
                              "address2": _area,
                              "address3": _landmark,
                              "pincode":_pincode,
                              "gst_number":_gst,
                              "pancard_number":_pancard,
                              "aadhar_number":_aadharcard,
                              "reg_sp_referal":(_referral_namecontroller.text!=null)?_referral_namecontroller.text:"",
                            }).then((dynamic res) async {
                              //print(res);
                              if (res["statusupdate"] == "yes") {
                                formKey.currentState.reset();
                                //FlashHelper.successBar(context, message: "Successfull");
                                setState(() => _isLoading = false);
                                Navigator.of(_ctx).pushReplacementNamed("/registrationsecondchange",
                                    arguments: {
                                      "mobileNo" : mobileNo,
                                    });
                              }
                              else if(res["email_id_already_taken"] == "email id Already taken Please enter new email id"){
                                FlashHelper.errorBar(context, message: "Email Id Already Used.");
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                              else if(res["refcodenotmatch"] == "refcode not null but not match"){
                                FlashHelper.errorBar(context, message: "Referral Code Invalid.");
                                setState(() => _isLoading = false);
                              }
                              else {
                                FlashHelper.errorBar(context, message: "Something is Wrong");
                                setState(() => _isLoading = false);
                              }
                            });
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.green,
                          ),
                          child: Text("Next", style: GoogleFonts.lato(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    }
  }

  String validateFirstName(String value) {
    if (value.length == 0)
      return 'Enter First Name';
    else
      return null;
  }

  String validateMiddleName(String value) {
    if (value.length == 0)
      return 'Enter Middle Name';
    else
      return null;
  }

  String validateLastName(String value) {
    if (value.length == 0)
      return 'Enter Last Name';
    else
      return null;
  }

  String validatepancard(String value) {
    Pattern pattern ="[A-Z]{5}[0-9]{4}[A-Z]{1}";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Pan Card Number';
    else
      return null;
  }
  String validategst(String value) {
    Pattern pattern ="[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[A-Z1-9]{1}[Z]{1}[A-Z0-9]{1}";
    RegExp regex = new RegExp(pattern);
    if(value!="") {
      if (!regex.hasMatch(value))
        return 'Enter Valid GST Number';
      else
        return null;
    }else
      return null;
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else if(value=="Already Used")
      return 'Email Id Already Used';
    else
      return null;
  }
  String validaterefel(String value) {
    var check=isUppercase(value);
    //print(check);
    if (check!=true)
      return 'Enter Refferal Code in Capital Letters';
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validatePin(String value) {
    if (value.length != 6)
      return 'Valid Pincode digit';
    else
      return null;
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 30);
    setState(() {
//      imageURI = imag;
    });
  }
}



