import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';

class OrderThankYou extends StatefulWidget {
  String status;
  OrderThankYou({this.status});
  @override
  _OrderThankYouState createState() => _OrderThankYouState();
}

class _OrderThankYouState extends State<OrderThankYou> with TickerProviderStateMixin{
  BuildContext _ctx;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  GifController controller;

  String status="",timeover="";

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
    startTime();
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

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.of(context).pushReplacementNamed('/bottomhome');
  }

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body:widget.status=="thankyou"?
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
                  child: Text("Thank You",style: GoogleFonts.lato(fontSize: 30,color: Color(0xFFFBC02D),fontWeight: FontWeight.bold),),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Order Is Submitted Successfully.",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Thank you for buying WELLON original product.",style: GoogleFonts.lato(fontSize: 20,color: Color(0xff33691E),fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ):
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
                    child: Image.asset("images/sorrysmiley.gif",height: 180,)
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Sorry",style: GoogleFonts.lato(fontSize: 30,color: Colors.red,fontWeight: FontWeight.bold),),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Order Payment Is failed.",style: GoogleFonts.lato(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w600),),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("That For Reasons Order has cancelled.",style: GoogleFonts.lato(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          )
      );
    }
  }
}
