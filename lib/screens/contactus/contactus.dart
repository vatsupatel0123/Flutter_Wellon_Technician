import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode;

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
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
          appBar: AppBar(
            title: Text("Contact Us",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: new Image.asset(
                    'images/launcher.png', width: 100, height: 100,),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Contactus Information",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width*1.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20,left: 15),
                                  child: Row(
                                    children:[
                                          Container(
                                              width:MediaQuery.of(context).size.width*0.25,
                                            alignment:Alignment.topLeft,
                                              padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                          child: Text("HEAD OFFICE",style: TextStyle(color: Colors.black),)
                                      ),
                                      Container(
                                          width:MediaQuery.of(context).size.width*0.50,
                                        padding: EdgeInsets.only(top: 7,bottom: 7,left: 10,right: 10),
                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            color:  Colors.white.withOpacity(0.9),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("A-34/2, Ichhapore GIDC,",style: TextStyle(color: Colors.black),),
                                              Text("HAZIRA ROAD, SURAT-394510",style: TextStyle(color: Colors.black),)
                                            ],
                                          )
                                      ),
                                      InkWell(
                                        onTap: (){
                                          MapsLauncher.launchQuery("A-34/2, Ichhapore GIDC, Hazira Road, Surat, Gujarat 394270");
                                        },
                                        child: Container(
                                            width:MediaQuery.of(context).size.width*0.10,
                                            padding: EdgeInsets.only(top: 10.5,bottom: 10.5,left: 10,right: 10),
                                            margin: EdgeInsets.only(left: 0.1),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              color:  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Icon(Icons.location_on,size: 25,color: Colors.black)
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                              Container(
                                width:MediaQuery.of(context).size.width*1.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                      children:[
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.25,
                                            padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              color:  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Text("Contact",style: TextStyle(color: Colors.black),)
                                        ),
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.50,
                                            padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              color:  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Text("+91 - 9377887251",style: TextStyle(color: Colors.black),)
                                        ),
                                        InkWell(
                                          onTap: () async{
                                              var url = "tel:9377887251";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                          },
                                          child: Container(
                                              width:MediaQuery.of(context).size.width*0.10,
                                              padding: EdgeInsets.only(top: 10.5,bottom: 10.5,left: 10,right: 10),
                                              margin: EdgeInsets.only(left: 0.1),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                color:  Colors.white.withOpacity(0.9),
                                              ),
                                              child: Icon(Icons.call,size: 25,color: Colors.black)
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Container(
                                width:MediaQuery.of(context).size.width*1.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                      children:[
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.25,
                                            padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              color:  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Text("Email",style: TextStyle(color: Colors.black),)
                                        ),
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.50,
                                            padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              color:  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Text("wellonwater@gmail.com",style: TextStyle(color: Colors.black),)
                                        ),
                                        InkWell(
                                          onTap: () async{
                                            var url = "mailto:wellonwater@gmail.com";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                              width:MediaQuery.of(context).size.width*0.10,
                                              padding: EdgeInsets.only(top: 10.5,bottom: 10.5,left: 10,right: 10),
                                              margin: EdgeInsets.only(left: 0.1),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                color:  Colors.white.withOpacity(0.9),
                                              ),
                                              child: Icon(Icons.email,size: 25,color: Colors.black,)
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    )
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
                SizedBox(           height: 20,
                ),
              ],
            ),
          )
      );
    }
  }
}
