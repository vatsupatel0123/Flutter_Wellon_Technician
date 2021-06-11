import 'dart:async';
import 'dart:ui';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/screens/bottom_navigation/navigation_bar_controller.dart';
import 'package:wellon_partner_app/screens/leads/lead_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  BuildContext _ctx;
  int counter=0;
  int _current = 0;
  bool _isdataLoading = false;

  String provider_id="0",spfullname="",mobile_numbers="",_result="";
  String total_debit_ledger="0",total_credit_ledger="0",total_balance_ledger="0",total_credit_normal="0",total_debit_normal="0",total_balance_normal="0",profile_photo="",total_pending="0",total_process="0",total_complete="0",total_cancel="0";

  DateTime initial;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();

//   Future<Null> _refresh() {
//   _loadWalletamt() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       spfullname = prefs.getString("spfullname") ?? '';
//       provider_id = prefs.getString("provider_id") ?? '';
//
//       _netUtil.post(RestDatasource.HOME_COUNT_ORDER, body: {
//         "provider_id": provider_id,
//       }).then((dynamic res) async {
//         setState(() {
//           print(res["total_cancel"]);
//           total_credit_ledger = res["total_credit_ledger"].toString();
//           total_debit_ledger = res["total_debit_ledger"].toString();
//           total_balance_ledger = res["total_balance_ledger"].toString();
//           total_credit_normal = res["total_credit_normal"].toString();
//           total_debit_normal = res["total_debit_normal"].toString();
//           total_balance_normal = res["total_balance_normal"].toString();
//           total_pending = res["total_pending"].toString();
//           total_process = res["total_process"].toString();
//           total_complete = res["total_complete"].toString();
//           total_cancel = res["total_cancel"].toString();
//           _isdataLoading = false;
//         });
//       });
//     });
//   }
// }
  void _loadWalletamt() async {
      await LoadData.loadWalletamt();
      setState((){
      });
  }
  // Future<void>_loadphoto() async {
  //   print(LoadData.total_cancel);
  //   print(LoadData.total_complete);
  //   print(LoadData.total_process);
  //   print(LoadData.total_balance_ledger);
  //   print(LoadData.total_balance_normal);
  //   setState(() {
  //     LoadData.refreshhomescreen();
  //   });
  // }
  Future openscanner() async{
    //_result=await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.DEFAULT);
    _result=await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.BARCODE);
    _netUtil.post(RestDatasource.SCANNER_REWARD, body: {
      "provider_id":provider_id,
      "scanner_code":_result,
    }).then((dynamic res) async {
      setState(() {
        if(res["status"]=="QR Code Use Successfully"){
          Navigator.of(context).pushNamed("/qrthanks");
        }else if(res["status"]=="QR Code Already Use"){
          FlashHelper.errorBar(context, message: "QR Code Is Already Used.");
        }else{
          FlashHelper.errorBar(context, message: "QR Code Is Invalid!");
        }
      });
    });
  }
  
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
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _loadWalletamt();
    //_loadphoto();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx=context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/logo.png",height: 140,width: 175,),
              //Text("Wellon",style: GoogleFonts.lato(fontSize: 28,color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
              //Text("®",style: GoogleFonts.lato(fontSize: 18,color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w600),),
            ],
          ),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/notificationcheck");
              },
            )
          ],
        ),
        body: LoadData.total_process.toString()!="null"?RefreshIndicator(
          key: _refreshIndicatorKey1,
          onRefresh: () async{
            await LoadData.loadWalletamt();
            setState((){
            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height*1.0,
              child: Column(
                children: <Widget>[
              Stack(
                children: [
                  Arc(
                    arcType: ArcType.CONVEX,
                    edge: Edge.BOTTOM,
                    height: 60.0,
                    child: new Container(
                      height: 180,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      color: Colors.green.shade200,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 15,top: 20),
                          child: Text("India's Leading App",
                            style: GoogleFonts.lato(fontSize: 25,fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 15,top: 10),
                          child: Text("For Water Purifiers And Ionizers Installation Repair & Maintenance Service.",
                            style: GoogleFonts.lato(color: Color(0xff555555),fontSize: 20,fontWeight: FontWeight.w700)),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 20,right: 15,top: 5),
                        //   child: Text("Installation of Water purifier/ RO system/ Alkaline Ionizer (Kangen Water System) on your finger tips.",
                        //     style: GoogleFonts.lato(fontSize: 15,color:Colors.grey.shade800,fontWeight: FontWeight.w700)),
                        // ),
                      ]
                  ),
                ],
              ),

                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeadScreen(
                                        currentindex: 0,
                                      ),
                                    ));
                              },
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerRight,
                                              margin: EdgeInsets.only(right: 10),
//                                      child: SvgPicture.asset("images/setting.svg",color: Colors.red.shade300, width: 100.0,fit: BoxFit.contain,)
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "PENDING LEADS",
                                                  style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            subtitle: Container(
                                              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Icon(Icons.person_outline, color: Colors.green, size: 30.0,),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                    child: Text(
                                                      LoadData.total_pending,
                                                      style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeadScreen(
                                        currentindex: 1,
                                      ),
                                    ));
                              },
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(right: 10),
//                                      child: SvgPicture.asset("images/process.svg",color: Colors.blue.shade300, width: 100.0,fit: BoxFit.contain,)
                                          ),
                                          ListTile(

                                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "LEADS IN PROCESS",
                                                  style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                                ),
                                                // Icon(
                                                //   Icons.arrow_forward,
                                                //   color: Colors.grey,
                                                //   size: 15.0,
                                                // ),
                                              ],
                                            ),
                                            subtitle: Container(
                                              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Icon(Icons.person_outline, color: Colors.green, size: 30.0,),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                    child: Text(
                                                      LoadData.total_process,
                                                      style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeadScreen(
                                    currentindex: 2,
                                  ),
                                ));
                          },
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 10, 40, 0),
//                                        child: SvgPicture.asset("images/check.svg",color: Colors.orangeAccent.shade100, width: 100.0,fit: BoxFit.contain,),
                                          )
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "COMPLETED LEADS",
                                                style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.arrow_forward,
                                            //   color: Colors.grey,
                                            //   size: 15.0,
                                            // ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Icon(Icons.person_outline, color: Colors.green, size: 30.0,),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Text(
                                                  LoadData.total_complete,
                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeadScreen(
                                    currentindex: 3,
                                  ),
                                ));
                          },
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(right: 10),
//                                      child: SvgPicture.asset("images/setting.svg",color: Colors.red.shade300, width: 100.0,fit: BoxFit.contain,)
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "CANCEL",
                                              style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Icon(Icons.person_outline, color: Colors.green, size: 30.0,),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Text(
                                                  LoadData.total_cancel,
                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavigationBarController(
                                    selectedindex: 3,
                                  ),
                                ));
                          },
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 0),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                          )
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "LEDGER",
                                              style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                            ),
                                            // Icon(
                                            //   Icons.arrow_forward,
                                            //   color: Colors.grey,
                                            //   size: 15.0,
                                            // ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Icon(Icons.credit_card, color: Colors.green, size: 30.0,),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Text(
                                                  (LoadData.total_balance_ledger.toString()!="null")?"₹"+LoadData.total_balance_ledger:"₹0",
                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavigationBarController(
                                    selectedindex: 4,
                                  ),
                                ));
                          },
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 0),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                          )
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                              child: Text(
                                                "WALLET",
                                                style: GoogleFonts.lato(fontSize: 14,color:Colors.green,letterSpacing: 0.5,fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.arrow_forward,
                                            //   color: Colors.grey,
                                            //   size: 15.0,
                                            // ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Icon(Icons.account_balance_wallet, color: Colors.green, size: 30.0,),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text(
                                                  (LoadData.total_balance_normal=="null")?"₹0":"₹"+LoadData.total_balance_normal,
                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 35.0,fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: InkWell(
                            onTap: () {
                              openscanner();
                            },
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              color: Colors.green.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: new BorderSide(color: Colors.lightGreen, width: 2.0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                                        title: Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "SPARE SCANNER",
                                                style: GoogleFonts.lato(fontSize: 18,color:Colors.white,fontWeight: FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Icon(Icons.settings_overscan, color: Colors.white, size: 30.0,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ),
                          ),
                      ),

                    ],
                  ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ):Center(child: CircularProgressIndicator(backgroundColor: Colors.green,),),
      );
    }
  }
}
