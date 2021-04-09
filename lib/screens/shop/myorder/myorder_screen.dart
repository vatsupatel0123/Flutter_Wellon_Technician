import 'dart:async';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/myorderlist.dart';
import 'package:wellon_partner_app/screens/contactus/contactus.dart';
import 'package:wellon_partner_app/screens/more/profile/myprofile_screen.dart';
import 'package:wellon_partner_app/screens/more/refer_friend/refer_friend_screen.dart';
import 'package:wellon_partner_app/screens/more/support_and_care/support_and_care_screen.dart';
import 'package:wellon_partner_app/screens/more/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/myorder_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class MYOrderScreen extends StatefulWidget {
  @override
  _MYOrderScreenState createState() => _MYOrderScreenState();
}


class _MYOrderScreenState extends State<MYOrderScreen>{
  BuildContext _ctx;

  NetworkUtil _netUtil = new NetworkUtil();
  bool _isdataLoading = false;

  String spfullname="",provider_id="0",profilephoto="",version="3.0";

  SharedPreferences prefs;
  bool is_active = false,resendMessageVisible = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode;
  Future<List<MyorderList>> categoryproductListdata;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

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
  }
  _loadPref() async {
    setState(() {
      categoryproductListdata = _getCategoryData();
    });
  }
  Future<List<MyorderList>> _getCategoryData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.MY_ORDER,body: {
      "provider_id":prefs.getString("provider_id")
    }).then((dynamic res)
    {
      print(res);
      final items = res.cast<Map<String, dynamic>>();
      print(items);
      List<MyorderList> listofusers = items.map<MyorderList>((json) {
        return MyorderList.fromJson(json);
      }).toList();
      List<MyorderList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }
  Future<List<MyorderList>> _refresh1() async
  {
    setState(() {
      categoryproductListdata = _getCategoryData();
    });
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
          title: Text("My Orders",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey1,
          color: Colors.black,
          onRefresh: _refresh1,
          child: FutureBuilder<List<MyorderList>>(
            future: categoryproductListdata,
            builder: (context,snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                );
              }
              else if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data Available!"),
                );
              }
              return ListView(
                padding: EdgeInsets.only(top: 20),
                children: snapshot.data
                    .map((data) =>
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      elevation: 3,
                      margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child:
                              MYOrderDetailsScreen(
                                sporder_id: data.sporder_id,
                                order_date_time:data.order_date_time,
                                totalproduct:data.totalproduct,
                                totalpay:data.totalpay,
                                address1:data.address1,
                                address2:data.address2,
                                pincode:data.pincode,
                                landmark:data.landmark,
                                city:data.city,
                                state:data.state,
                                status: data.status,
                              ), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500)));
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
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${data.order_date_time}',
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(
                                                      'WELLONPO${data.sporder_id}',
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize: 16,),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Text(
                                                  '${data.status.toUpperCase()}',
                                                  style: GoogleFonts.lato(color:Colors.black,fontSize: 16,letterSpacing:1),
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Items  :',
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                                                    ),
                                                    Text(
                                                      '${data.totalproduct}',
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
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
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                ).toList(),
              );
            },
          ),
        ),
      );
    }
  }
}
