import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  BuildContext _ctx;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  GifController controller;

  @override
  initState() {
    super.initState();
    print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
//    startTime();
  }
  PackageInfo _packageInfo1 = PackageInfo(
    appName: 'Wellon Technician',
    packageName: 'com.karoninfotech.wellon_technician',
    version: '1.0',
    buildNumber: '585027354',
  );

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
                child: Text("It's all about wellness...!",style: GoogleFonts.lato(fontSize: 18,color: Colors.black,),),
              ),
              SizedBox(
                height: 200,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                        child: Text("Exit", style: GoogleFonts.lato(color: Colors.deepOrange.shade600,fontSize: 15.0,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        StoreRedirect.redirect(androidAppId: _packageInfo1.packageName, iOSAppId: _packageInfo1.buildNumber);
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
                        child: Text("Update", style: GoogleFonts.lato(color: Colors.green.shade600,fontSize: 15.0,fontWeight: FontWeight.bold),),
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
}
