import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/wallet_view_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class ViewWalletScreen extends StatefulWidget {
  @override
  _ViewWalletScreenState createState() => _ViewWalletScreenState();
}

class _ViewWalletScreenState extends State<ViewWalletScreen>{
  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();

  String spfullname="",provider_id="0",mobile_numbers="";

  bool isOffline = false;
  final formKey = new GlobalKey<FormState>();

  Future<List<WalletViewList>> WalletViewListdata;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadPref() async {
    setState(() {
      WalletViewListdata = _getWalletViewData();
    });
  }

  Future<List<WalletViewList>> _getWalletViewData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_WITHDRAW_MONEY,
        body:{
          "provider_id":prefs.getString("provider_id"),
        }).then((dynamic res)
    {
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<WalletViewList> listofusers = items.map<WalletViewList>((json) {
        return WalletViewList.fromJson(json);
      }).toList();
      List<WalletViewList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  //Load Data
  //On Refresh
  Future<List<WalletViewList>> _refresh1() async
  {
    setState(() {
      WalletViewListdata = _getWalletViewData();
    });
  }


  @override
  initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =connectionStatus.connectionChange.listen(connectionChanged);
    _loadPref();
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
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Request",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: Colors.black,
            key: _refreshIndicatorKey1,
            onRefresh: _refresh1,
            child: FutureBuilder<List<WalletViewList>>(
              future: WalletViewListdata,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Data Available!",style: GoogleFonts.lato(color:Colors.black,letterSpacing: 1,fontWeight: FontWeight.w700),),
                  );
                }
                return ListView(
                  padding: EdgeInsets.only(top: 15),
                  children: snapshot.data.map((data) =>
                      Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 1.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:
                          Row(
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
                                            width:MediaQuery.of(context).size.width*0.55,
                                            child: Text(
                                              (data.withdrawal_remark!=null)?data.withdrawal_remark:"",
                                              style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            (data.withdraw_status!=null)?data.withdraw_status:"",
                                            style: GoogleFonts.lato(color:Color(0xff616161),fontSize: 14,fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            (data.request_date_time!=null)?data.request_date_time:"",
                                            style: GoogleFonts.lato(color:Color(0xff616161),fontSize: 14,fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              new Text(
                                  (" ₹ "+data.withdraw_amount!=null)?"₹"+data.withdraw_amount:"",style: GoogleFonts.lato(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                  ).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}