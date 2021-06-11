import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/auth.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import '../../auth.dart';

class ThankYouScreen extends StatefulWidget {
  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> with TickerProviderStateMixin,AuthStateListener{
  BuildContext _ctx;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  GifController controller;

  @override
  initState() {
    controller= GifController(vsync: this);
    controller.repeat(min:0,max:75,period:Duration(seconds:5));
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
//    startTime();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

//  startTime() async {
//    var _duration = new Duration(seconds: 5);
//    return new Timer(_duration, navigationPage);
//  }
//
//  void navigationPage() async {
//    Navigator.of(context).pushNamedAndRemoveUntil('/bottomhome', (Route<dynamic> route) => false);
//  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Align(
                alignment: Alignment.center,
                child: new Image.asset(
                  'images/launcher.png', width: 90, height: 90,),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 160.0,
                  height: 50.0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Wellon"),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("It's all about wellness...!",style: GoogleFonts.lato(color: Colors.black,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700),),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: GifImage(
                  controller: controller,
                  image: AssetImage("images/success.gif"),
                  height: 180,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("THANK YOU",style: GoogleFonts.lato(fontSize: 30,letterSpacing: 1,color: Color(0xFFFBC02D),fontWeight: FontWeight.w700),),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("FOR YOUR REGISTRATION",style: GoogleFonts.lato(fontSize: 20,letterSpacing: 1,color: Color(0xff33691E),fontWeight: FontWeight.w700),),
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("We Get Your Details",style: GoogleFonts.lato(fontSize: 18,letterSpacing: 1,color: Colors.black,fontWeight: FontWeight.w700),),
              ),
              SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        //Navigator.of(context).pushNamedAndRemoveUntil('/loginfirst', (Route<dynamic> route) => false);
                        //Navigator.of(context).pushNamedAndRemoveUntil('/loginfirst', (Route<dynamic> route) => false);
                        Navigator.of(context).pushReplacementNamed("/loginfirst");
                        //logout();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Colors.green.shade600,
                          ),
                        ),
                        child: Text("Login", style: GoogleFonts.lato(fontSize: 15,letterSpacing: 1,color: Colors.green.shade600,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        exit(0);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Colors.deepOrange.shade600,
                          ),
                        ),
                        child: Text("Exit", style: GoogleFonts.lato(fontSize: 15,letterSpacing: 1,color: Colors.deepOrange.shade600,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  void logout() async
  {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    var db = new DatabaseHelper();
    await db.deleteUsers();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(context).pushReplacementNamed("/loginfirst");
  }
  @override
  void onAuthStateChanged(AuthState state) {
    // TODO: implement onAuthStateChanged
  }
}
