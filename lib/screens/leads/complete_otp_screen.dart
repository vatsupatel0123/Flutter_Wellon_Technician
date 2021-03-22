import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class CompleteOtpScreen extends StatefulWidget {
  @override
  _CompleteOtpScreenState createState() => _CompleteOtpScreenState();
}

class _CompleteOtpScreenState extends State<CompleteOtpScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;
  bool _isLoading = false,_isResendLoading = false,resendMessageVisible = false,timervisible=false;
  String _otp="",order_id="0",provider_id="0";
  Duration _duration;
  Timer _timer;
  final formKey = new GlobalKey<FormState>();

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadpref() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      provider_id = prefs.getString("provider_id") ?? '';
    });
  }

  @override
  initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _loadpref();
    startTime();
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

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        order_id = arguments['order_id'].toString();
        print(order_id);
        _isLoading=false;
      });
    }else{
      print("argument are Null");
    }
    return new Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,

        title: Text("OTP Verification",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w600),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.green,
      ),
      body:
      Stack(
        children: [
          // Container(
          //   child: Image.asset("images/otp.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: new Image.asset(
          //     'images/phone.png', width: 220, height: 200,),
          // ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, top: 20, bottom: 0,right: 10,),
                alignment: Alignment.topLeft,
                child: Text(
                  "A text with a One Time Password (OTP) has been send to Customer mobile number.",
                  style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontSize: 15,fontWeight: FontWeight.w600),),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: TextFormField(
                    obscureText: false,
                    style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontSize: 15,fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.number,
                    onSaved: (val) {
                      setState(() {
                        _otp = val;
                      });
                    },
                      validator: (val) {
                        return val.length != 6
                            ? "Please enter 6 digit OTP Code"
                            : null;
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.green),
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
                      )
                  ),
                ),
              ),
              Visibility(
                visible: resendMessageVisible,
                child: Container(
                  margin: EdgeInsets.only(left: 20,right: 0,top: 0,bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.blue.shade700,size: 20,),
                      SizedBox(
                        width: 1,
                      ),
                      Text(
                        "A new code has been sent to your mobile number.",
                        style: GoogleFonts.lato(color: Colors.blue.shade700,fontSize: 14,fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              (timervisible==true)?Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("You didn't get OTP? ",style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: (){
                        _netUtil.post(RestDatasource.COMPLETE_ORDER_FIRST, body: {
                          "order_id": order_id,
                          "provider_id": provider_id,
                        }).then((dynamic res) async {
                          print(res);
                          if(res["status"]=="true") {
                            setState(() {
                              resendMessageVisible = true;
                              timervisible=false;
                              startTime();
                            });
                          }
                        });
                      },
                        child: Text("Resend OTP",style: GoogleFonts.lato(color: Colors.blueAccent,letterSpacing: 1,fontSize: 17,fontWeight: FontWeight.w600))
                    ),
                  ],
                ),
              ):
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("You didn't get OTP? ",style: GoogleFonts.lato(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600)),
                    InkWell(
                        onTap: (){
                          Fluttertoast.showToast(msg: "Please Wait 2 Minutes",backgroundColor: Colors.green,fontSize: 18,gravity: ToastGravity.CENTER);
                        },
                        child: Text("Resend OTP",style: GoogleFonts.lato(color: Colors.blueAccent,letterSpacing: 1,fontSize: 17,fontWeight: FontWeight.w600))
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: InkWell(
                    onTap: () async {
                      final form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        _netUtil.post(RestDatasource.ACCEPT_PROCCESS_ORDER, body: {
                          "provider_id":provider_id,
                          "order_id": order_id,
                          "order_complete_otp": _otp,
                        }).then((dynamic res) async {
                          print(res);
                          if (res["status"] == "Order completed") {
                            formKey.currentState.reset();
                            Navigator.of(context).pushNamed("/completethanks",arguments: {
                              "status" : "complete"
                            });
                          }
                          else if(res["status"] == "Otp Not Match Please Try again"){
                            FlashHelper.errorBar(context, message: "Please Enter Valid OTP.");
                          }
                          else{
                            Navigator.of(context).pushNamed("/completethanks",arguments: {
                              "status" : "complete"
                            });
                          }
                        });
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(
                          color: Colors.lightGreen,
                          width: 3
                        ),
                        color: Colors.green.shade500,
                      ),
                      child: Text("VERIFY", style: GoogleFonts.lato(color: Colors.white,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w800),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
