import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/wallet_normal_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:pdf/pdf.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as material;
import 'package:wellon_partner_app/utils/pdfviewer.dart';

class WallletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WallletScreen> with SingleTickerProviderStateMixin{
  BuildContext _ctx;

  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();

  String spfullname="",provider_id="0",mobile_numbers="";
  String withdraw_id,order_id,amount,amount_type,amount_status,wallet_date_time,updated_at,created_at;
  String _amt,_remart;
//
  String total_credit,total_debit,total_balance="0";

  bool isOffline = false;
  bool _isLoading = false;
  bool _isdataLoading = false;
  final formKey = new GlobalKey<FormState>();


  Future<List<WalletNormal>> WalletNormalListdata;
  Future<List<WalletNormal>> WalletHistoryListfilterData;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadPref() async {
    setState(() {
      WalletNormalListdata = _getWalletNormalData();
    });
  }

  _loadWalletamt() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {

      provider_id= prefs.getString("provider_id") ?? '';

      _netUtil.post(RestDatasource.GET_WALLET_TOTAL_AMT, body: {
        "provider_id":provider_id,
      }).then((dynamic res) async {
        setState(() {
          print(provider_id);
          total_credit=res["total_credit_normal"].toString();
          total_debit=res["total_debit_normal"].toString();
          total_balance=res["total_balance_normal"].toString();

          _isdataLoading=false;
        });
      });

    });
  }

  Future<List<WalletNormal>> _getWalletNormalData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_WALLET_NORMAL,
        body:{
          "provider_id":prefs.getString("provider_id"),
        }).then((dynamic res)
    {
      final items = res.cast<Map<String, dynamic>>();
      print(items);
      List<WalletNormal> listofusers = items.map<WalletNormal>((json) {
        return WalletNormal.fromJson(json);
      }).toList();
      List<WalletNormal> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  //Load Data
  //On Refresh
  Future<List<WalletNormal>> _refresh1() async
  {
    setState(() {
      WalletNormalListdata = _getWalletNormalData();
      WalletHistoryListfilterData=WalletNormalListdata;
    });
  }
  Future<File> copyAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/plogo.png');
    ByteData bd = await rootBundle.load('images/pdflogo.png');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }


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
    _loadWalletamt();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
              child: Text("Wellon Wallet",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),

                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              child: new Text("Total Balance",style: GoogleFonts.lato(color:Colors.black,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700))
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(85, 0, 10, 0),
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(5)),
                          //       border: Border.all(
                          //         color: Colors.green.shade600,
                          //
                          //       ),
                          //     ),
                          //     // child: Text("Withdraw Money", style: GoogleFonts.lato(color: Colors.green.shade600,fontSize: 15.0,fontWeight: FontWeight.bold),),
                          //     child: InkWell(onTap: (){
                          //
                          //     },
                          //         child: Icon(Icons.settings_overscan,size: 40,)
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: new Text((total_balance!="null")?" ₹"+total_balance:"₹0",style: GoogleFonts.lato(fontSize: 40,letterSpacing:1,fontWeight: FontWeight.bold))
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RefreshIndicator(
            color: Colors.black,
            key: _refreshIndicatorKey1,
            onRefresh: _refresh1,
            child: FutureBuilder<List<WalletNormal>>(
              future: WalletNormalListdata,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                  );
                } else if (!snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height*1.0,
                      child: Center(
                        child: Text("No Data Available!"),
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 135),
                        child: Text("Wallet History",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w700),),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: ListView(
                        padding: EdgeInsets.only(top: 5),
                        children: snapshot.data.map((data) =>
                            Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 1.0),

                              child: Container(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset("images/launcher.png",height: 45,width: 50,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:MediaQuery.of(context).size.width*0.50,
                                                    child: Text(
                                                      (data.wallet_remark!=null)?data.wallet_remark:"",
                                                      style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 15,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    (data.amount_status!=null)?data.amount_status:"",
                                                    style: GoogleFonts.lato(color:Color(0xff616161),fontSize: 14,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    (data.wallet_date_time!=null)?data.wallet_date_time:"",
                                                    style: GoogleFonts.lato(color:Color(0xff616161),fontSize: 14,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: (data.amount_type == "credit") ? new Text((data.amount!=null)?" + "+data.amount:" + 0",style: GoogleFonts.lato(color:Colors.green,fontSize: 18,fontWeight: FontWeight.w700)):new Text((data.amount!=null)?" - "+data.amount:" - 0",style: GoogleFonts.lato(color:Colors.red,fontSize: 18,fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                        ).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}