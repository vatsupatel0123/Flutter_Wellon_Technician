import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class ReferFriendScreen extends StatefulWidget {
  @override
  _ReferFriendScreenState createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  BuildContext _ctx;
  String ref_code,mobileNo,ref_amount;
  NetworkUtil _netUtil = new NetworkUtil();
  bool isOffline = false;
  SharedPreferences prefs;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    mobileNo= prefs.getString("mobile_numbers") ?? '';
    _netUtil.post(RestDatasource.GET_REFCODE, body: {
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      setState(() {
        ref_code=res["ref_code"];
        ref_amount=res["ref_amount"];
      });
    });
  }
  @override
  initState() {
    _loadPref();
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
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text("Refer & Earn",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
          iconTheme: IconThemeData(
            color: Colors.white
          ),
        ),
        body:
        SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: new Image.asset(
                        'images/refer-and-win.png',height: 200,fit: BoxFit.fill,),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0,145,0,0),
                        child: Text("1 Refferal = ₹$ref_amount",style: GoogleFonts.lato(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w700),))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DottedBorder(
                          color: Colors.black,
                          strokeWidth: 1,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(5),
                          dashPattern: [8, 3],
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (ref_code!=null)?Text(ref_code,style: GoogleFonts.lato(color:Colors.black,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.bold),)
                                :Text("Your Reffer Code is Not Genrated",style: GoogleFonts.lato(color:Colors.black,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.bold),),
                                InkWell(
                                    onTap: (){
                                      (ref_code!=null)?
                                      FlutterClipboard.copy(ref_code).then(( value ) => Fluttertoast.showToast(
                                          msg:"Copied To Clipboard",gravity: ToastGravity.BOTTOM,backgroundColor: Colors.green
                                      )):Fluttertoast.showToast(
                                          msg:"Refer Code is Not Genrated",gravity: ToastGravity.BOTTOM,backgroundColor: Colors.black
                                      );
                                    },
                                    child: Icon(Icons.content_copy, color: Colors.green.shade600, size: 30.0,)
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () async {
                    (ref_code!=null)?Share.share('Download Wellon Technition app and Register to win Rewards https://example.com/$ref_code', subject: 'Look what I made!'):
                    Fluttertoast.showToast(
                        msg:"Refer Code is Not Genrated",gravity: ToastGravity.BOTTOM,backgroundColor: Colors.black
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(
                          color: Colors.green,
                          width: 3
                        ),
                        color: Colors.green.shade600,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Share ", style: GoogleFonts.lato(color:Colors.white,fontSize: 20,letterSpacing: 2,fontWeight: FontWeight.w700),),
                          Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                        child: Row(
                          children: [
                            Text("How It Works ",style: GoogleFonts.lato(color:Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                            Icon(Icons.info_outline, color: Colors.green, size: 25.0,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: new Image.asset(
                          'images/refer-and-earn-image.png',height: 220,fit: BoxFit.contain,width: 450,),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                      //   child: Text("Follow this Step proper and Earn Money",style: GoogleFonts.lato(color: Colors.black,fontSize: 14),),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }
  }
}
