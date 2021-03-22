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

class ChangeMobileNumberScreen extends StatefulWidget {
  @override
  _ChangeMobileNumberScreenState createState() => _ChangeMobileNumberScreenState();
}

class _ChangeMobileNumberScreenState extends State<ChangeMobileNumberScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;
  bool _isLoading = false,_isResendLoading = false,resendMessageVisible = false,timervisible=false,fonsize=false;
  String _otp="",order_id="0",provider_id="0",_newph,_oldnumber;
  Duration _duration;
  Timer _timer;
  final formKey = new GlobalKey<FormState>();
  FocusNode _focus = new FocusNode();

  TextEditingController _oldnumber_namecontroller=new TextEditingController();
  TextEditingController _newnumber_namecontroller=new TextEditingController();

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
    _focus.addListener(_onFocusChange);
  }
  void _onFocusChange(){
    debugPrint("Focus: "+_focus.hasFocus.toString());
    if(_focus.hasFocus)
    {
      setState(() {
        fonsize=true;
      });
    }else{
      setState(() {
        fonsize=false;
      });
    }
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
        _oldnumber = arguments['mobilenumber'].toString();
        _oldnumber_namecontroller.text=_oldnumber;
      });
    }else{
      print("argument are Null");
    }
    return new Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Change Mobile Number",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w600),),
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
          Column(
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                  child: Column(
                    children: [
                      TextFormField(
                          enableInteractiveSelection: false,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _oldnumber_namecontroller,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Current Mobile Number",
                              labelStyle: TextStyle(color: Colors.black,fontSize: 20),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide(
                                  color: Color(0xff006c9b),
                                  width: 1.0,
                                ),
                              ),
                              fillColor: Color(0xffffffff),
                              filled: true)),
                      SizedBox(height: 20,),
                      TextFormField(
                          enableInteractiveSelection: false,
                          focusNode: _focus,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _newnumber_namecontroller,
                          obscureText: false,
                          onSaved: (val) {
                            setState(() {
                              _newph = val;
                            });
                          },
                          onChanged: (val) {
                            setState(() {
                              _newph = val;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "New Mobile Number",
                              labelStyle: TextStyle(color: Colors.black,fontSize: (fonsize)?20:16),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide(
                                  color: Color(0xff006c9b),
                                  width: 1.0,
                                ),
                              ),
                              fillColor: Color(0xffffffff),
                              filled: true)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading=true;
                      });
                      final form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        _netUtil.post(RestDatasource.CONTACT_UPDATE, body: {
                          "mobile_numbers":_oldnumber,
                          "new_mobile_number": _newph,
                        }).then((dynamic res) async {
                          print(res);
                          if (res["contact"] == "Contact Number Update After Otp Confirmation") {
                            formKey.currentState.reset();
                            setState(() {
                              _isLoading=false;
                            });
                            Navigator.of(context).pushNamed("/completeotpmobilechange",arguments: {
                              "mobile_numbers":_oldnumber,
                              "new_mobile_number": _newph,
                            });
                          }
                          else if(res["contact"] == "Contact Number Already Exists"){
                            FlashHelper.errorBar(context, message: "Contact Number Already Exists");
                            setState(() {
                              _isLoading=false;
                            });
                          }
                          else{
                            FlashHelper.errorBar(context, message: "Contact Number Already Exists");
                            setState(() {
                              _isLoading=false;
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Colors.lightGreen,
                            width: 3
                        ),
                        color: Colors.green.shade500,
                      ),
                      child: _isLoading?Center(child: CircularProgressIndicator(backgroundColor: Colors.black,),):Text("Change", style: GoogleFonts.lato(color: Colors.white,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w800),),
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
}
