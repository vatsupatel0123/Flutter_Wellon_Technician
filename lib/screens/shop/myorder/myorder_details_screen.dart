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
import 'package:wellon_partner_app/models/myorder_details_list.dart';
import 'package:wellon_partner_app/models/myorderlist.dart';
import 'package:wellon_partner_app/screens/contactus/contactus.dart';
import 'package:wellon_partner_app/screens/more/profile/myprofile_screen.dart';
import 'package:wellon_partner_app/screens/more/refer_friend/refer_friend_screen.dart';
import 'package:wellon_partner_app/screens/more/support_and_care/support_and_care_screen.dart';
import 'package:wellon_partner_app/screens/more/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class MYOrderDetailsScreen extends StatefulWidget {
  String sporder_id,status;
  String order_date_time;
  String totalproduct;
  String totalpay;
  String address1;
  String address2;
  String pincode;
  String landmark;
  String city;
  String state;
  MYOrderDetailsScreen({this.sporder_id,this.status,this.order_date_time,this.totalproduct,this.totalpay,this.address1,this.address2,this.state,this.city,this.landmark,this.pincode,});
  @override
  _MYOrderDetailsScreenState createState() => _MYOrderDetailsScreenState();
}


class _MYOrderDetailsScreenState extends State<MYOrderDetailsScreen>{
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
  String cgst,sgst,items;
  String _otpcode;
  Future<List<MyOrderDetailsList>> categoryproductListdata;
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
    cgst=(double.parse(widget.totalpay)-9/100).toString();
    setState(() {
      categoryproductListdata = _getCategoryData();
    });
  }
  Future<List<MyOrderDetailsList>> _getCategoryData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return _netUtil.post(RestDatasource.MY_ORDER_DETAILS,body: {
      "sporder_id":widget.sporder_id
    }).then((dynamic res)
    {
      print(res);
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<MyOrderDetailsList> listofusers = items.map<MyOrderDetailsList>((json) {
        return MyOrderDetailsList.fromJson(json);
      }).toList();
      List<MyOrderDetailsList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }
  Future<List<MyOrderDetailsList>> _refresh1() async
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                margin: new EdgeInsets.fromLTRB(20, 20, 10, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Date',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                          ),
                          Text(
                            '${widget.order_date_time}',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Id',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                          ),
                          Text(
                            'WELLONPO${widget.sporder_id}',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Total',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                          ),
                          Text(
                            '₹${widget.totalpay} (${widget.totalproduct} Items)',
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RefreshIndicator(
                key: _refreshIndicatorKey1,
                color: Colors.black,
                onRefresh: _refresh1,
                child: FutureBuilder<List<MyOrderDetailsList>>(
                  future: categoryproductListdata,
                  builder: (context,snapshot) {
                    print(snapshot.error);
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
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0),
                      children: snapshot.data
                          .map((data) =>
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0,
                            margin: new EdgeInsets.fromLTRB(20, 20, 10, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1,height: 100,width: 100,),
                                      SizedBox(width: 5,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data.productname}',
                                            style: GoogleFonts.lato(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            'Qty: ${data.quantity}',
                                            style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹${data.price}',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
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
              Card(
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Container(
                  //color : Colors.green.shade200,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Address',
                                style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${widget.address1}',
                                style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${widget.landmark}",
                                style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${widget.address2}',
                                style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${widget.pincode}",
                                style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                              ),
                              Text(
                                ((widget.city!=null)?widget.city:"")+
                                    ((widget.state!=null)?" - "+widget.state:""),
                                style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              ),
              Card(
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Container(
                  //color : Colors.green.shade200,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub Total',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                                  ),
                                  Text(
                                    '${double.parse(widget.totalpay)*82/100}',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SGST(9%)',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                                  ),
                                  Text(
                                    '${double.parse(widget.totalpay)*9/100}',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'CGST(9%)',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 16),
                                  ),
                                  Text(
                                    '${double.parse(widget.totalpay)*9/100}',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Total:',
                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '₹${widget.totalpay}',
                                    style: GoogleFonts.lato(color:Colors.green,fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              ),
              widget.status=="new"||widget.status=="process"?Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                child: InkWell(
                  onTap: () async{
                    prefs=await SharedPreferences.getInstance();
                    setState(() {
                      _isLoading=true;
                    });
                    _netUtil.post(RestDatasource.MY_ORDER_CANCEL,body: {
                      "provider_id":prefs.getString("provider_id"),
                      "sporder_id":widget.sporder_id
                    }).then((dynamic res)
                    {
                      print(res);
                      setState(() {
                        _isLoading=false;
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 13,bottom: 13),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: _isLoading?Center(child: CircularProgressIndicator(),):Center(child: Text("Cancel Order",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ):Container()
            ],
          ),
        ),
      );
    }
  }
}
