import 'dart:async';
import 'dart:ui';
import 'package:clippy_flutter/arc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/auth.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/user.dart';
import 'package:wellon_partner_app/screens/login/login_screen_presenter.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class LoginSecondScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginSecondScreenState();
  }
}

class LoginSecondScreenState extends State<LoginSecondScreen> implements LoginScreenContract,AuthStateListener{
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

  String mobileNo = "",id ="0",otp = "",status="",timer;

  LoginSecondScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      {
        Navigator.pushNamedAndRemoveUntil(context, '/bottomhome', (Route<dynamic>route) => false);
        LoadData.loadpref();
      }
  }
  var _connector = FirebaseMessaging();
  //OTPTextEditController controller;

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
        //print("token  "+token);
      });
    });
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    startTime();
    /*OTPInteractor.getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 5,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        //OTPStrategy(),
      ],
    );*/
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
      mobileNo = arguments['mobileNo'];
      id = arguments['id'];
      otp = arguments['otp'];
      status = arguments['status'];
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Arc(
                        arcType: ArcType.CONVEX,
                        edge: Edge.BOTTOM,
                        height: 70.0,
                        clipShadows: [ClipShadow(color: Colors.black)],
                        child: new Container(
                          height: 300,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Colors.green,
                          child: Container(
//                width: MediaQuery.of(context).size.width,
//                height: MediaQuery.of(context).size.height,
                            child: Image.asset("images/otp.png",fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(120, 20, 0, 0),
                      //   child: Text(
                      //     'Verify Mobile Number',
                      //     style: GoogleFonts.lato(
                      //         color: Colors.white,
                      //         fontSize: 22,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Arc(
                      //   arcType: ArcType.CONVEX,
                      //   edge: Edge.BOTTOM,
                      //   height: 70.0,
                      //   clipShadows: [ClipShadow(color: Colors.black)],
                      //   child: new Container(
                      //     height: 85,
                      //     width: MediaQuery
                      //         .of(context)
                      //         .size
                      //         .width,
                      //     color: Colors.green[500],
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       child: FlatButton(
                      //         onPressed: () {},
                      //       ),
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: new Image.asset(
                            'images/phone.png', width: 220, height: 200,),
                        ),
                        SizedBox(
                          height: 100,
                        ),
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
                                          //controller: controller,
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
                                                setState(() => _isLoading = true);
                                                form.save();
                                                _presenter.doLogin(id, _otpcode,token);
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
