import 'dart:async';
import 'dart:ui';

import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';

class AcceptScreen extends StatefulWidget {
  @override
  _AcceptScreenState createState() => _AcceptScreenState();
}

class _AcceptScreenState extends State<AcceptScreen> with TickerProviderStateMixin{
  BuildContext _ctx;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  GifController controller;
  GifController controller1;

  String status="";

  @override
  initState() {
    controller= GifController(vsync: this);
    controller1= GifController(vsync: this);
    controller.repeat(min:0,max:75,period:Duration(seconds:5));
    controller1.repeat(min:0,max:23,period:Duration(seconds:2));
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    startTime();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.of(context).pushNamedAndRemoveUntil('/bottomhome', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        setState(() {
          status=arguments["status"];
        });
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: (status=="accept")?
        Container(
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
                child: Text("It's all about wellness...!",style: GoogleFonts.lato(fontSize: 18,color: Colors.black,),),
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
                child: Text("THANK YOU",style: GoogleFonts.lato(fontSize: 30,color: Color(0xFFFBC02D),fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Order Accepted",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        ):(status=="reject")?
        Container(
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
                child: Text("It's all about wellness...!",style: GoogleFonts.lato(fontSize: 18,color: Colors.black,),),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: GifImage(
                  controller: controller1,
                  image: AssetImage("images/success.gif"),
                  height: 180,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("THANK YOU",style: GoogleFonts.lato(fontSize: 30,color: Color(0xFFFBC02D),fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Order Rejected",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        ):Container(
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
                child: Text("It's all about wellness...!",style: GoogleFonts.lato(fontSize: 18,color: Colors.black,),),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: GifImage(
                  controller: controller1,
                  image: AssetImage("images/sorrysmiley.gif"),
                  height: 180,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("SORRY",style: GoogleFonts.lato(fontSize: 30,color: Color(0xFFFBC02D),fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Time Is Over",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Then Order Rejected Automatically.",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        ),
      );
    }
  }
}
