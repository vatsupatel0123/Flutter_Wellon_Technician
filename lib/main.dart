import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';import 'package:flutter/services.dart';import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:native_updater/native_updater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/routes.dart';
import 'package:wellon_partner_app/update_screen.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import 'data/database_helper.dart';
import 'data/loaddata.dart';

void main() => runApp(new LoginApp(),);

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Wellon Partner',
      debugShowCheckedModeBanner: false,
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  BuildContext _ctx;
  bool loadfirstscreen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final introKey = GlobalKey<IntroductionScreenState>();
  bool checkterms = false;

  NetworkUtil _netUtil = new NetworkUtil();
  String version;
  AppUpdateInfo _updateInfo;

  SharedPreferences prefs;
  @override


  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPref();
    notification();
    //checkForUpdate();
    //checkFirstSeen();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if(_updateInfo.updateAvailable)
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateScreen()));
          }
        print("'_updateInfo'");
        print(_updateInfo);
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void notification(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
        //onFirebaseMessage(message);
        //print("Page : " + message['data']['order_id']);
        Navigator.of(context).popAndPushNamed("/notificationorderpending",arguments: {
          "order_id": message['data']['order_id']
        });
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     content: ListTile(
        //       title: Text(message['notification']['title']),
        //       subtitle: Text(message['notification']['body']),
        //     ),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Ok'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
        //  FlashHelper.errorBar(context, message: "sds");
        // Alert(
        //   context: _ctx,
        //   type: AlertType.info,
        //   title: message["notification"]["title"],
        //   desc: message["notification"]["body"],
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Close",
        //         style: GoogleFonts.lato(
        //             color: Colors.white,
        //             fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.of(_ctx).pop(),
        //       color: Color.fromRGBO(
        //           0, 179, 134, 1.0),
        //     ),
        //   ],
        // ).show();
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
        Navigator.of(context).popAndPushNamed("/notificationorderpending",arguments: {
          "order_id": message['data']['order_id']
        });
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
        Navigator.of(context).popAndPushNamed("/notificationorderpending",arguments: {
          "order_id": message['data']['order_id']
        });
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print("Push Messaging token: $token");
      });
    });
  }
  @override
  void dispose() {
   super.dispose();
   }

  // Future checkFirstSeen() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     loadfirstscreen = (prefs.getBool('firstscreen') ?? false);
  //     if (loadfirstscreen) {
  //       startTime();
  //     }
  //   });
  // }
  //
  // void _onIntroEnd(context) {
  //   if (checkterms) {
  //     setState(() {
  //       loadfirstscreen = true;
  //       prefs.setBool('firstscreen', true);
  //       startTime();
  //     });
  //   } else {
  //     FlashHelper.errorBar(context, message: "Accept Terms & Conditions..");
  //   }
  // }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  _loadPref() async {
    var db = new DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    (isLoggedIn)?
    LoadData.loadpref():{};
    setState(() {
      _netUtil.post(RestDatasource.VERSION_CHECK, body: {}).then(
          (dynamic res) async {
        //print(res);
        setState(() {
          version = res["version"].toString();
          //version = "2.0";
          startTime();
        });
      });
    });
  }

  void navigationPage() async {
    var db = new DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn) {
      (version!=null)?
      (version == "3.0")
          ? Navigator.of(context).pushNamedAndRemoveUntil(
              '/bottomhome', (Route<dynamic> route) => false)
          : Navigator.of(context).pushNamed("/updateapp"):Center(
            child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
      );
      //Navigator.of(context).pushNamedAndRemoveUntil('/bottomhome', (Route<dynamic> route) => false);
    } else {
      (version!=null)?
      (version == "3.0")
          ? Navigator.of(context).pushNamedAndRemoveUntil(
              '/loginfirst', (Route<dynamic> route) => false)
          : Navigator.of(context).pushNamed("/updateapp"):Center(
              child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
      );
      //Navigator.of(context).pushNamedAndRemoveUntil('/loginfirst', (Route<dynamic> route) => false);
    }
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/logo.png', height: 250, width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light
    ));
    _ctx = context;
    // var bodyStyle = GoogleFonts.lato(fontSize: 19.0);
    // var pageDecoration = PageDecoration(
    //   titleTextStyle: GoogleFonts.lato(fontSize: 28.0, fontWeight: FontWeight.w700),
    //   bodyTextStyle: bodyStyle,
    //   descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    //   pageColor: Colors.white,
    //   imagePadding: EdgeInsets.zero,
    // );
    // if (loadfirstscreen == false) {
    //   return IntroductionScreen(
    //     key: introKey,
    //     pages: [
    //       PageViewModel(
    //         title: "",
    //         body:
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam consequat sapien eget orci lacinia, et interdum orci elementum. Fusce blandit ex eget urna malesuada euismod. Proin in diam in odio finibus fringilla in in tortor.",
    //         image: _buildImage('img1'),
    //         decoration: pageDecoration,
    //       ),
    //       PageViewModel(
    //         title: "",
    //         body:
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam consequat sapien eget orci lacinia, et interdum orci elementum. Fusce blandit ex eget urna malesuada euismod. Proin in diam in odio finibus fringilla in in tortor.",
    //         image: _buildImage('img2'),
    //         decoration: pageDecoration,
    //       ),
    //       PageViewModel(
    //         title: "",
    //         body:
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam consequat sapien eget orci lacinia, et interdum orci elementum. Fusce blandit ex eget urna malesuada euismod.",
    //         image: _buildImage('img1'),
    //         decoration: pageDecoration,
    //         footer: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Checkbox(
    //               activeColor: Colors.blue,
    //               value: checkterms,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   checkterms = value;
    //                 });
    //               },
    //             ),
    //             InkWell(
    //                 onTap: () {
    //                   Navigator.of(_ctx).pushNamed("/termsandcondition");
    //                 },
    //                 child: Text(
    //                   "I accept terms & conditions",
    //                   style: GoogleFonts.lato(color: Colors.blue),
    //                 )),
    //           ],
    //         ),
    //       ),
    //     ],
    //     onDone: () => _onIntroEnd(context),
    //     //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
    //     showSkipButton: false,
    //     skipFlex: 0,
    //     nextFlex: 0,
    //     skip: const Text('Skip'),
    //     next: const Icon(
    //       Icons.arrow_forward,
    //       color: Colors.green,
    //     ),
    //     done: Text('DONE',
    //         style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.green)),
    //     dotsDecorator: const DotsDecorator(
    //       size: Size(10.0, 10.0),
    //       color: Color(0xFFBDBDBD),
    //       activeSize: Size(22.0, 10.0),
    //       activeColor: Colors.green,
    //       activeShape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(25.0)),
    //       ),
    //     ),
    //   );
    // } else {
    //   _ctx=context;
      return new Scaffold(
        backgroundColor: Colors.green,
        body:
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SizedBox.fromSize(
                    size: Size(220, 220), // but // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.white,// button color
                        child: InkWell(
                          splashColor: Colors.white,// splash color
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Image.asset('images/logo.png',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                ),
              ],
            ),
          ),
        ),
      );
   // }
  }
}
