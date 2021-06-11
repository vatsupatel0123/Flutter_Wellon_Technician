import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/notification_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth.dart';


class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>  implements AuthStateListener{

  NetworkUtil _netUtil = new NetworkUtil();
  String loggedinname = "",loggedinid="";
  Future<List<NotificationList>> notificationdata;
  SharedPreferences prefs;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;
  Future<List<NotificationList>> NotificationListData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();


  _loadPref() async {
    setState(() {
      NotificationListData = _getNotificationData();
    });
  }

  Future<List<NotificationList>> _getNotificationData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _netUtil.post(RestDatasource.URL_NOTIFICATION,body:{
          "provider_id":"1",
        }).then((dynamic res) {
          final items = res.cast<Map<String, dynamic>>();
          //print(items);
          List<NotificationList> listofusers = items.map<NotificationList>((json) {
            return NotificationList.fromJson(json);
          }).toList();
          List<NotificationList> revdata = listofusers.reversed.toList();
          return revdata;
        });
  }

  Future<List<NotificationList>> _refresh1() async
  {
    setState(() {
      NotificationListData = _getNotificationData();
    });
  }

  @override
  void initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
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
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Colors.green,
          title: Text("Notifications",style: GoogleFonts.lato(color: Colors.white),)
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh1,
          child: FutureBuilder<List<NotificationList>>(
            future: NotificationListData,
            builder: (context, snapshot) {
              //print(snapshot.data);
              //print(snapshot.hasData);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data Available!"),
                );
              }
              return ListView(
                padding: EdgeInsets.only(top: 10),
                children: snapshot.data
                    .map((data) =>
                    InkWell(
                      onTap: () {
                        //  Navigator.of(context).pushNamed("/notificationusers", arguments: {"notificationid": data.NotificationId});
                      },
                      child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: Container(
                            child: ListTile(
                                title:new Text(data.noti_title, style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w100,
                                    letterSpacing:0.5,
                                    fontSize: 15.0,
                                    color: Colors.black)),
                                subtitle:
                                new Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Align(
                                        alignment: Alignment.centerLeft,
                                        child: new Text(data.noti_description, style: GoogleFonts.lato(
                                            letterSpacing: 0.5,
                                            fontSize: 12.0,
                                            color: Colors.blueGrey))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // new Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: new Text("Wellon ",
                                    //       style: GoogleFonts.lato(
                                    //           fontWeight: FontWeight.w200,
                                    //           letterSpacing: 0.5,
                                    //           fontSize: 10.0,
                                    //           color: Colors.grey
                                    //               .shade700)),
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                  ],
                                )

                            ),
                          )),
                    ),
                ).toList(),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  void onAuthStateChanged(AuthState state) {
    // TODO: implement onAuthStateChanged
  }
}
