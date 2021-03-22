import 'dart:async';
import 'dart:ui';

import 'package:clippy_flutter/arc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/auth.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/user.dart';
import 'package:wellon_partner_app/screens/login/login_screen_presenter.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
//import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class ChangeNumberOtpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChangeNumberOtpScreenState();
  }
}

class ChangeNumberOtpScreenState extends State<ChangeNumberOtpScreen>{
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true,_isResendLoading = false,resendMessageVisible = false,timervisible=false;
  String _otpcode;
  LoginScreenPresenter _presenter;
  String token="";
  NetworkUtil _netUtil = new NetworkUtil();
  Duration _duration;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String mobileNo = "",id ="0",otp = "",status="",timer,newmobilenumber;

  var _connector = FirebaseMessaging();

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;
  Timer _timer;

  @override
  initState() {
    _firebaseMessaging.getToken().then((String t) {
      assert(t != null);
      setState(() {
        token=t;
        print("token  "+token);
      });
    });
    super.initState();
    print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    startTime();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }



  startTime() async {
    _duration = new Duration(minutes: 2);
    _timer=Timer(_duration, navigationPage);

  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }


  void navigationPage() async {
    setState(() {
      timervisible=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      mobileNo = arguments['mobile_numbers'];
      newmobilenumber = arguments['new_mobile_number'];
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,

            title: Text("OTP Verification",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w600),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.green,
          ),
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 10, bottom: 10,right: 10,),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "A text with a One Time Password (OTP) has been send to your mobile number.",
                          style: GoogleFonts.lato(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Container(
                          child: Column(
                              children: <Widget>[
                                Form(
                                  key: formKey,
                                  child :Container(
                                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                      child: TextFormField(
                                        obscureText: false,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontSize: 18,fontWeight: FontWeight.w700),
                                        onSaved: (val) {
                                          setState(() {
                                            _otpcode = val;
                                          });
                                        },
                                        maxLength: 6,
                                        validator: (val) {
                                          return val.length != 6
                                              ? "Please enter 6 digit OTP Code"
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          counterText: "",
                                          labelStyle: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontSize: 18,fontWeight: FontWeight.w700),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green,width: 2,
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              borderSide: BorderSide(
                                                width: 2, color: Colors.green,
                                              )
                                          ),
                                          border: OutlineInputBorder(
                                            // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              borderSide: BorderSide(color: Colors.white24)
                                            //borderSide: const BorderSide(),
                                          ),
                                          labelText: 'Enter OTP',
                                        ),)
                                  ),
                                ),
                                Visibility(
                                  visible: resendMessageVisible,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.blue.shade700,size: 23,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "A new code has been sent to your mobile number.",
                                          style: GoogleFonts.lato(color: Colors.blue.shade700,fontSize: 15,fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          if (_isLoading == false) {
                                            final form = formKey.currentState;
                                            if (form.validate()) {
                                              form.save();
                                              setState(() => _isLoading = true);
                                              _netUtil.post(RestDatasource
                                                  .CONTACT_UPDATE_OTP_CHECK,
                                                  body: {
                                                    "sp_otp_code": _otpcode,
                                                    "mobile_numbers": mobileNo,
                                                    "new_mobile_number": newmobilenumber,
                                                  }).then((dynamic res) async {
                                                print(res);
                                                if (res["status"] == "true") {
                                                  setState(() => _isLoading = false);
                                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  prefs.setString("mobile_numbers", newmobilenumber);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                      context, "/myprofile");
                                                }
                                                else
                                                if (res["status"] == "false") {
                                                  FlashHelper.errorBar(context,
                                                      message: "Enter Valid OTP");
                                                }
                                                else {}
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              color: Colors.lightGreenAccent.shade700,
                                            ),
                                            child: _isLoading ? CircularProgressIndicator(backgroundColor: Colors.black,) : Text("SUBMIT", style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontSize: 20,fontWeight: FontWeight.w700),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      (timervisible==true)?
                                      Container(
                                        margin: EdgeInsets.only(left: 5, right: 5, top: 30),
                                        child: InkWell(
                                          onTap: () {
                                            _netUtil.post(RestDatasource.RESEND_OTP, body: {
                                              "mobile_numbers": mobileNo,
                                            }).then((dynamic res) async {
                                              if(res["status"]=="true"){
                                                setState(() {
                                                  resendMessageVisible = true;
                                                  timervisible=false;
                                                  startTime();
                                                });
                                              }
                                            });
                                          },
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5),
                                                ),
                                                side: BorderSide(width: 1, color: Colors.green)),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                              child: _isResendLoading
                                                  ? new CircularProgressIndicator(
                                                  backgroundColor: Colors.white)
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Resend OTP", style: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                  Icon(Icons.arrow_forward, size: 20,
                                                    color: Colors.green,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ):
                                      Container(
                                        margin: EdgeInsets.only(left: 5, right: 5, top: 30),
                                        child: InkWell(
                                          onTap: () {
                                            Fluttertoast.showToast(msg: "Please Wait 2 Minutes",backgroundColor: Colors.green,fontSize: 18);
                                          },
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5),
                                                ),
                                                side: BorderSide(width: 1, color: Colors.green)),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                              child: _isResendLoading
                                                  ? new CircularProgressIndicator(
                                                  backgroundColor: Colors.white)
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Resend OTP", style: GoogleFonts.lato(color: Colors.green,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                  Icon(Icons.arrow_forward, size: 20,
                                                    color: Colors.green,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 30),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("© " +CommonHelper().getCurrentDate(), style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                                            InkWell(
                                              onTap: () async {
                                                CommonHelper().getWebSiteUrl(RestDatasource.BASE_URL);
                                              },
                                              child: Text(", wellonwater.com ", style: GoogleFonts.lato(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Text(", Inc.", style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                                            // Text(" Design by", style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                                            // InkWell(
                                            //   onTap: () async {
                                            //     CommonHelper().getWebSiteUrl(RestDatasource.KARON);
                                            //   },
                                            //   child: Text(" Karon Infotech", style: GoogleFonts.lato(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.w600),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      );
    }
  }



  @override
  void onLoginError(String errorTxt) {
    if (status == "newregistration") {
      if(otp==_otpcode) {
        //FlashHelper.successBar(context, message: "New Register");
        Navigator.of(context).pushNamed("/registration",
            arguments: {
              "mobileNo": mobileNo,
            });
      }
      else{
        FlashHelper.errorBar(context, message: "Enter Valid OTP");
      }
    }
    else if (status == "halfregister") {
      if(otp==_otpcode) {
        //FlashHelper.successBar(context, message: "Half Register");
        Navigator.of(context).pushNamed("/registration",
            arguments: {
              "mobileNo": mobileNo,
            });
      }
      else{
        FlashHelper.errorBar(context, message: "Enter Valid OTP");
      }
    }
    else
    {
      FlashHelper.errorBar(context, message: "Enter Valid OTP");
    }
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    //_showSnackBar(user.toString());
    setState(() => _isLoading = false);
    if(status=="newregistration")
    {
      Navigator.of(context).pushNamed("/registration",
          arguments: {
            "mobileNo" : mobileNo,
          });
    }
    else if(status=="halfregistration")
    {
      Navigator.of(context).pushNamed("/registration",
          arguments: {
            "mobileNo" : mobileNo,
          });
    }
    else
    {
      var db = new DatabaseHelper();
      await db.saveUser(user);
      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_IN);
    }

  }
}
