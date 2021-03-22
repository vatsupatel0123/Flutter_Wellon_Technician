import 'dart:async';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/screens/contactus/contactus.dart';
import 'package:wellon_partner_app/screens/more/profile/myprofile_screen.dart';
import 'package:wellon_partner_app/screens/more/refer_friend/refer_friend_screen.dart';
import 'package:wellon_partner_app/screens/more/support_and_care/support_and_care_screen.dart';
import 'package:wellon_partner_app/screens/more/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/myorder_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import '../../auth.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}


class _MoreScreenState extends State<MoreScreen> implements AuthStateListener{
  BuildContext _ctx;

  NetworkUtil _netUtil = new NetworkUtil();
  bool _isdataLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String spfullname="",provider_id="0",profilephoto="",version="3.0";

  SharedPreferences prefs;
  bool is_active = false,resendMessageVisible = false;

  _loadPref() async {
     prefs = await SharedPreferences.getInstance();
     profilephoto=prefs.getString("profile_photo") ?? '';
    _loadProfileData();
  }

  _loadProfileData() async {
    provider_id= prefs.getString("provider_id") ?? '';
    spfullname= prefs.getString("spfullname") ?? '';
    _netUtil.post(RestDatasource.URL_PROFILE_DATA, body: {
      "provider_id":prefs.getString("provider_id"),
      "spfullname":prefs.getString("spfullname"),
//      "provider_id":"3",
    }).then((dynamic res) async {
      setState(() {
        if(res["is_active"]=="Y")
          {
            is_active = true;
          }else {
          is_active = false;
        }
      });
    });
  }
  _loadVersion() async {
    setState(() {
      _netUtil.post(RestDatasource.VERSION_CHECK, body: {}).then(
              (dynamic res) async {
            print(res);
            setState(() {
              version = res["version"].toString();
              //version = "2.0";

            });
          });
    });
  }
  PackageInfo _packageInfo1 = PackageInfo(
    appName: 'Wellon Technician',
    packageName: 'com.karoninfotech.wellon_technician',
    version: '3.0',
    buildNumber: '585027354',
  );

  // Future<void> _initPackageInfo() async {
  //   setState(() {
  //     _packageInfo1 = info;
  //   });
  // }

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
    _loadPref();
    _loadVersion();
    // _initPackageInfo();
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
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              margin: new EdgeInsets.only(bottom: 10),
              child:Padding(
                padding: EdgeInsets.only(top: 25),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: MyProfileScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                             // Navigator.of(context).pushNamed("/myprofile");
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Hi",
                                          style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 18,fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          spfullname,
                                          style: GoogleFonts.lato(color:Colors.black,fontSize: 20,letterSpacing:1,fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          'Edit Profile',
                                          style: GoogleFonts.lato(color:Color(0xFF757575),fontSize: 11,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: Colors.green,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: SizedBox.fromSize(
                                            size: Size(75, 75), // button width and height
                                            child: ClipOval(
                                              child: Material(
                                                color: Colors.white,
                                                // button color
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                        (profilephoto!=null)?Image.network(RestDatasource. BASE_URL + "spprofile/" + profilephoto, width: 75, height: 75,fit: BoxFit.fitWidth,):
                                                        Center(
                                                          child: CircularProgressIndicator(
                                                            backgroundColor: Colors.green,
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF303030),
                                        size: 13.0,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Active Account",
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w600),
                                  ),
                                ),

                                Switch(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: is_active,
                                  onChanged: (value) {
                                    setState(() {
                                      is_active = value;
                                      _netUtil.post(
                                          RestDatasource.URL_CHANGE_ACTIVE, body: {
                                        "provider_id":prefs.getString("provider_id"),
                                        "is_active": (is_active)
                                            ? "Y"
                                            : "N",
                                      }).then((dynamic res) async {
                                        if (res["status"] == "Service Provder Active") {
                                          FlashHelper.successBar(context, message: "Service Provider Active");
                                          setState(() => _isLoading = false);
                                        }
                                        else {
                                          FlashHelper.errorBar(context, message: "Service Provider InActive");
                                          setState(() => _isLoading = false);
                                        }
                                      });
                                    });
                                  },
                                  activeTrackColor: Colors.green,
                                  activeColor: Colors.green.shade900,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      elevation: 3,
                      margin: new EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: MYOrderScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset("images/myorder.png",color: Colors.green,height: 30,width: 30,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'My Order',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Order You have to Submited',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: ProductCartScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.shopping_cart_outlined, color: Colors.green.shade600, size: 25.0,),
                                            //Image.asset("images/interest.png",height: 25,width: 25,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Your Cart',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Your cart product',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: ReferFriendScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.group_add, color: Colors.green.shade600, size: 25.0,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Refer & Earn',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Your Referral Code Share and Get CashBack',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: ContactUsScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.contact_phone_outlined, color: Colors.green.shade600, size: 25.0,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Contact Us',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Have any problem need support.',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: SupportAndCareScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.headset_mic, color: Colors.green.shade600, size: 25.0,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Support/Customer Care',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Helping to resolve any issues with service.',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: TermsAndConditionScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SvgPicture.asset("images/document.svg",color: Colors.green.shade600, width: 25.0,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Terms & Conditions',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Our App Terms & Conditions.',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              rateApp();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 15),
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.star_border, color: Colors.green.shade600, size: 25.0,),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Rate App',
                                                  style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w800),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'To Give rating to our app.',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, color: Color(0xff9E9E9E), size: 13.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        logout();
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
                        child: Text("LOGOUT", style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 15,letterSpacing:1,fontWeight: FontWeight.w700),),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Center(
                            child: new Text(version!=null?"Version "+version:"3.0",style: GoogleFonts.lato(color:Colors.red,fontSize: 13,fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(" Design by", style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                              InkWell(
                                onTap: () async {
                                  CommonHelper().getWebSiteUrl(RestDatasource.KARON);
                                },
                                child: Text(" Karon Infotech", style: GoogleFonts.lato(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  void shareApp() async
  {
        final RenderBox box = context.findRenderObject();
        Share.share("text",
        subject: "Wellon Partner",
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size);
  }

  void rateApp() async
  {
    StoreRedirect.redirect(
        androidAppId: _packageInfo1.packageName,
        iOSAppId: _packageInfo1.buildNumber);
  }

  void logout() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    var db = new DatabaseHelper();
    await db.deleteUsers();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.pushNamedAndRemoveUntil(context, '/loginfirst', (Route<dynamic>route) => false);
  }

  @override
  void onAuthStateChanged(AuthState state) {
    // TODO: implement onAuthStateChanged
  }
}
