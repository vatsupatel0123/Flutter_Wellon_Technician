import 'dart:async';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State <LoginScreen> with TickerProviderStateMixin {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mobile_numbers;

  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  FocusNode myFocusNode;

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
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
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Image.asset("images/login_top.png",)
                      ]
                  )
              ),
              SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height:MediaQuery.of(context).size.height*0.09,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(78.0),
                            ),
                            elevation: 10,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 40,bottom: 40),
                                  height: 160,
                                  child: new Image.asset('images/logo.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: new EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                              child: Container(
                                child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Form(
                                        key: formKey,
                                        child :Container(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                            child: TextFormField(
                                                obscureText: false,
                                                style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontSize: 14,fontWeight: FontWeight.w700),
                                                keyboardType: TextInputType.number,
                                                maxLength: 10,
                                                onSaved: (val) {
                                                  setState(() {
                                                    _mobile_numbers = val;
                                                  });
                                                },
                                                validator: validateMobile,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                  labelStyle: GoogleFonts.lato(color: Colors.green,letterSpacing: 1,fontSize: 14,fontWeight: FontWeight.w700),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.lightGreen.shade500,width: 2,
                                                      )
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      borderSide: BorderSide(
                                                        width: 2, color: Colors.lightGreen.shade500,
                                                      )
                                                  ),
                                                  border: OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      borderSide: BorderSide(color: Colors.white24)
                                                    //borderSide: const BorderSide(),
                                                  ),
                                                  labelText: 'Enter Your Mobile Number'
                                              ),)
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
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
                                                    NetworkUtil _netUtil = new NetworkUtil();
                                                    _netUtil.post(RestDatasource.URL_LOGIN, body: {
                                                      "mobile_numbers": _mobile_numbers,
                                                    }).then((dynamic res) async {
                                                      //print(res["status"]);
                                                      if(res["status"] == "newregistration" || res["status"] == "halfregistration")
                                                      {
                                                        setState(() => _isLoading = false);
                                                        Navigator.of(context).pushNamed("/loginsecond",
                                                            arguments: {
                                                              "mobileNo" : _mobile_numbers,
                                                              "id" : res["id"].toString(),
                                                              "otp" : res["otp"].toString(),
                                                              "status" : res["status"],
                                                            });
                                                      }
                                                      else if(res["status"] == "successlogin")
                                                      {
                                                        setState(() => _isLoading = false);
                                                        Navigator.of(context).pushNamed("/loginsecond",
                                                            arguments: {
                                                              "mobileNo" : _mobile_numbers,
                                                              "id" : res["id"].toString(),
                                                              "otp" : res["otp"].toString(),
                                                              "status" : res["status"],
                                                            });
                                                      }
                                                      else if(res["status"] == "blockbyadmin")
                                                      {
                                                        setState(() => _isLoading = false);
                                                        FlashHelper.errorBar(context, message: "Sorry! Your Account is Block by Admin");
                                                      }
                                                      else if(res["status"] == "notverify")
                                                      {
                                                        setState(() => _isLoading = false);
                                                        FlashHelper.errorBar(context, message: "Phone number is already registered But Admin Not Verify Your Account so wait for it.");
                                                      }

                                                      else {
                                                        setState(() => _isLoading = false);
                                                        FlashHelper.errorBar(context, message: "Login fail try again later!");
                                                      }
                                                    });
                                                  }
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    color: Colors.lightGreenAccent.shade700,
                                                  ),
                                                  child: _isLoading ? CircularProgressIndicator() : Text("SEND OTP", style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontSize: 18,fontWeight: FontWeight.w700),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10,top: 40,right: 0,),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("For continuing, you agree to wellon's ", style: GoogleFonts.lato(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                CommonHelper().getWebSiteUrl(RestDatasource.URL_GET_WEBSITE_TERM_AND_CONDITIONS);
                                              },
                                              child: Text("Terms & Conditions.", style: GoogleFonts.lato(color: Colors.green,fontSize: 15,fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ],
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
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              ),
            ],
          )
      );
    }
  }

  // @override
  // void onLoginError(String errorTxt) {
  //   FlashHelper.errorBar(context, message: errorTxt);
  //   setState(() => _isLoading = false);
  // }
  //
  // @override
  // void onLoginSuccess(User user) async {
  //   //_showSnackBar(user.toString());
  //   setState(() => _isLoading = false);
  //   var db = new DatabaseHelper();
  //   await db.saveUser(user);
  //   var authStateProvider = new AuthStateProvider();
  //   authStateProvider.notify(AuthState.LOGGED_IN);
  // }
  //

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else if (!regExp.hasMatch(value))
      return 'Please enter valid mobile number';
    else
      return null;
  }
  //
  // setUpButtonChild() {
  //   if (_state == 0) {
  //     return Text(
  //       "Click Here",
  //       style: GoogleFonts.lato(
  //         color: Colors.white,
  //         fontSize: 16,
  //       ),
  //     );
  //   } else if (_state == 1) {
  //     return SizedBox(
  //       height: 36,
  //       width: 36,
  //       child: CircularProgressIndicator(
  //         value: null,
  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //       ),
  //     );
  //   } else {
  //     return Icon(Icons.check, color: Colors.white);
  //   }
  // }

  // void animateButton() {
  //   double initialWidth = _globalKey.currentContext.size.width;
  //
  //   _controller =
  //       AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  //
  //   _animation = Tween(begin: 0.0, end: 1).animate(_controller)
  //     ..addListener(() {
  //       setState(() {
  //         _width = initialWidth - ((initialWidth - 48) * _animation.value);
  //       });
  //     });
  //   _controller.forward();
  //
  //   setState(() {
  //     _state = 1;
  //   });
  //
  //   Timer(Duration(milliseconds: 3300), () {
  //     setState(() {
  //       _state = 2;
  //     });
  //   });
  // }

}
