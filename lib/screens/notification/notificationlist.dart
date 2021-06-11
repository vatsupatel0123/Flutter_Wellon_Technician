import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/notification_list.dart';
import 'package:wellon_partner_app/models/wallet_view_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>{
  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();

  String spfullname="",provider_id="0",mobile_numbers="";

  bool isOffline = false;
  final formKey = new GlobalKey<FormState>();

  Future<List<NotificationList>> NotificationListdata;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadPref() async {
    setState(() {
      NotificationListdata = _getNotificationViewData();
    });
  }

  Future<List<NotificationList>> _getNotificationViewData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.URL_NOTIFICATION,
        body:{
          "provider_id":prefs.getString("provider_id"),
        }).then((dynamic res)
    {
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<NotificationList> listofusers = items.map<NotificationList>((json) {
        return NotificationList.fromJson(json);
      }).toList();
      List<NotificationList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  //Load Data
  //On Refresh
  Future<List<NotificationList>> _refresh1() async
  {
    setState(() {
      NotificationListdata = _getNotificationViewData();
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
        title: Text("Notification",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            RefreshIndicator(
              color: Colors.black,
              key: _refreshIndicatorKey1,
              onRefresh: _refresh1,
              child: FutureBuilder<List<NotificationList>>(
                future: NotificationListdata,
                builder: (context, snapshot) {
                  //print(snapshot.hasData);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No Data Available!",style: GoogleFonts.lato(color:Colors.black,letterSpacing: 1,fontWeight: FontWeight.w700),),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.only(top: 20),
                    children: snapshot.data.map((data) =>
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.5),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    //Image.asset("images/launcher.png",height: 45,width: 50,),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Text(
                                        //   (data.order_id!=null)?"WELLON"+data.order_id:"",
                                        //   style: GoogleFonts.lato(color:Colors.grey.shade800,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700),
                                        // ),
                                        Text(
                                          (data.noti_title!=null)?data.noti_title:"",
                                          style: GoogleFonts.lato(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        ),
                                        Container(
                                          width:MediaQuery.of(context).size.width*0.80,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:5),
                                            child: Text(
                                              (data.noti_description!=null)?data.noti_description:"",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}