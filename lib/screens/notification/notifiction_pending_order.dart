
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/new_lead_list.dart';
import 'package:wellon_partner_app/models/product_kit_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';


class NotificationLeadNewScreen extends StatefulWidget {
  @override
  _NotificationLeadNewScreenState createState() => _NotificationLeadNewScreenState();
}

class _NotificationLeadNewScreenState extends State<NotificationLeadNewScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;
  bool _isdataLoading = false;
  bool _isLoading = false;
  double latitude,longitude;

  String order_id="",prefer_date="",prefer_time="",house_no="",house_name="",address1="",address2="",address3="",pincode="0",order_date_time = "",expire_date_time="",olat ="0";
  String olong="0",slat="0",slong="0",km="0",serviceprovider_name="",service_type="",provider_id="";
  String brandid="",modelid="",brandname="",brandimg="",modelname="",modelimg="",expire_time="",customer_name="";
  String o_machine="",o_category="",o_type_name="",instance_normal="",payable_amount="0",raw_tds="",ro_capacity="",system_old_new="",old_year="",is_ro="0";
  String ro_img="",customer_remark="",otherbrand="",othermodel="",other_cust_contact="",other_cust_name="",who_order_for="";
  int count = 0;
  String getamt="0";
//  String hour = "",minute="",second="";
//  final currentime = DateTime.now();

  Future<List<ProductKitList>> newProductKitListdata;
  _loadPref() async {
    prefs  = await SharedPreferences.getInstance();
    provider_id= prefs.getString("provider_id") ?? '';
    setState(() {
      newProductKitListdata = _getProductKitData();
    });
  }
  _loadorderdetail() async {
    prefs  = await SharedPreferences.getInstance();
    provider_id= prefs.getString("provider_id") ?? '';
    setState(() {
      _netUtil.post(RestDatasource.GET_Notification_NEW_ORDER, body: {
        "order_id": order_id,
        "provider_id":provider_id,
      }).then((dynamic res) async {
        setState(() {
          ////print(res);
          prefer_date =res[0]["prefer_date"].toString();
          prefer_time =res[0]["prefer_time"].toString();
          house_no = res[0]["house_no"].toString();
          house_name = res[0]["house_name"].toString();
          address1 = res[0]["address_street"].toString();
          address2 = res[0]["address_landmark"].toString();
          address3 = res[0]["address_area"].toString();
          pincode = res[0]["pincode"].toString();
          latitude = double.parse(res[0]["latitude"].toString());
          longitude = double.parse(res[0]["longitude"].toString());
          order_date_time = res[0]["order_date_time"].toString();
          expire_date_time = res[0]["expire_date_time"].toString();
          instance_normal=res[0]["is_instance"].toString();
          brandid = res[0]["brand_id"].toString();
          modelid = res[0]["model_id"].toString();
          brandname = res[0]["brand_name"].toString();
          otherbrand = res[0]["other_brand"].toString();
          othermodel = res[0]["other_model"].toString();
          modelname = res[0]["model_name"].toString();
          ro_img = res[0]["ro_img"].toString();
          customer_name = res[0]["orderd_name"].toString();
          who_order_for = res[0]["who_order_for"].toString();
          other_cust_name = res[0]["other_cust_name"].toString();
          other_cust_contact = res[0]["other_cust_contact"].toString();
          customer_remark = res[0]["cust_remark"].toString();
          o_machine = res[0]["o_machine"].toString();
          o_category = res[0]["o_category"].toString();
          o_type_name = res[0]["o_type_name"].toString();
          payable_amount = res[0]["payable_amount"].toString();
          raw_tds = res[0]["raw_tds"].toString();
          ro_capacity = res[0]["ro_capacity"].toString();
          system_old_new = res[0]["system_type"].toString();
          old_year = res[0]["old_year"].toString();
          is_ro = res[0]["is_ro"].toString();
        });
      });

    });
  }
  Future<List<ProductKitList>> _getProductKitData() async
  {
    return _netUtil.post(RestDatasource.GET_ORDER_KIT,
        body:{
          "order_id":order_id,
        }).then((dynamic res)
    {
      final items = res.cast<Map<String, dynamic>>();
      ////print(items);
      List<ProductKitList> listofusers = items.map<ProductKitList>((json) {
        return ProductKitList.fromJson(json);
      }).toList();
      List<ProductKitList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  //Net Connection
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadamt() async {
    prefs  = await SharedPreferences.getInstance();
    provider_id= prefs.getString("provider_id") ?? '';
    setState(() {
      _netUtil.post(RestDatasource.GET_SP_ORDERAMT, body: {
        "order_id": order_id,
        "provider_id":provider_id,
      }).then((dynamic res) async {
        setState(() {
          //print(res);
          getamt=res["sp_get_price"].toString();
        });
      });

    });
  }

  @override
  initState() {
    //print("SetState Called");
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =connectionStatus.connectionChange.listen(connectionChanged);
    _loadamt();
    _loadorderdetail();
    _loadPref();
  }


  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      ////print(isOffline);
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        setState(() {
          //order_id="10";
          order_id=arguments['order_id'].toString();
        });
      }
    });
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/bottomhome', (Route<dynamic> route) => false),
        ),
        centerTitle: true,
        title: Text("Pending Leads",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
        backgroundColor: Colors.green,
      ),
      body:
      SingleChildScrollView(
        child: Stack(
          children: <Widget>[

            (order_id!=null)?
            (o_type_name == "ro") ?
            Container(
              child: Column(
                children: [
                  Container(
//                          color : Colors.green.shade100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WELLON",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  (order_id!="null")?order_id:"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (who_order_for=="Self"||who_order_for==null)?Text(
                                  (customer_name!="null")?customer_name.toUpperCase():"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ):Text(
                                  (other_cust_name!="null")?other_cust_name.toUpperCase():"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),

                          new Divider(
                            color: Colors.black,
                          ),


                          Container(
                            child: (ro_img!="null")?
                            Container(
                                alignment: Alignment.center,
                                child: new Image.network(RestDatasource. BASE_URL + "custproductimages/" + ro_img, width: 200, height: 200,)
                            ):Container(
                                child: new Image.asset("images/img.png", width: 200, height: 200,)
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (o_type_name!="null")?(o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (o_category!="null")?o_category.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'Machine',
                          //             style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                          //           ),
                          //           Text(
                          //             (o_machine!="null")?o_machine.toUpperCase():"---",
                          //             style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Installation Type',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (instance_normal!="null")?instance_normal.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Water TDS',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (raw_tds!="null")?raw_tds:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'System Type',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (system_old_new!="null")?system_old_new:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'If Customer System OLD',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (old_year!="null")?old_year:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RO Capacity',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (ro_capacity!="null")?ro_capacity:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Brand',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (brandname!="null")?brandname:(otherbrand!=null)?otherbrand:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Model',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Container(
                                      width: 280,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          (modelname!="null")?modelname:(othermodel!=null)?othermodel:"---",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Customer Note',
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                (customer_remark!="null")?customer_remark:"---",
                                style: GoogleFonts.lato(fontSize: 16,
                                    color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          new Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Address',
                                              style: GoogleFonts.lato(fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          ((house_no!="null")?house_no:"")+
                                              ((house_name!="null")?" , "+house_name:""),
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (address1!="null")?address1+" ,":"",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (address3!="null")?address3+" ,":"",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          ((address2!="null")?address2:"")+
                                              ((pincode!="null")?" - "+pincode:""),
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700,fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: (){
                                          MapsLauncher.launchCoordinates(
                                              latitude, longitude, 'Google Headquarters are here');
                                          Text('LAUNCH COORDINATES');
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: new Image.asset("images/map.png", width: 80, height: 80,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      'Service Date',
                                      style: GoogleFonts.lato(fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      (prefer_date!="null")?prefer_date:"Quick",
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Text(
                                      'Service Time',
                                      style: GoogleFonts.lato(fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      (prefer_time!="null")?prefer_time:"Quick",
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'You Get',
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                (getamt!="null")?Text(
                                  (getamt!="null")?"₹"+getamt:"₹0",
                                  style: GoogleFonts.lato(fontSize: 35, color: Colors.black),
                                ):Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),

                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text("Reject Order",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text("Are you sure you want to reject this order?",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,false);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("No",
                                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              width: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _netUtil.post(RestDatasource.REJECT_NEW_ORDER, body: {
                                                    "order_id": order_id,
                                                    "provider_id":prefs.getString("provider_id"),
                                                  }).then((dynamic res) async {
                                                    //print(res);
                                                    if (res["status"] =="Order Rejected" || res["status"] =="Final Order Rejected") {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "reject"
                                                      });
                                                      FlashHelper.successBar(context, message: "Order Rejected");
                                                    }
                                                    else {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "reject"
                                                      });
                                                      FlashHelper.errorBar(context, message: "Order Rejected.");
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("Yes",
                                                    style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                color: Colors.green,
                              ),
                              color:Colors.green,
                            ),
                            child: Text("Reject", style: GoogleFonts.lato(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text("Accept Order",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text("Are you sure you want to accept this order?",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,false);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("No",
                                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              width: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _netUtil.post(RestDatasource.ACCEPT_NEW_ORDER, body: {
                                                    "order_id": order_id,
                                                    "provider_id":prefs.getString("provider_id"),
                                                  }).then((dynamic res) async {
                                                    //print(res);
                                                    if (res["status"] =="Order Accepted") {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "accept"
                                                      });
                                                    }
                                                    else {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "rejecttimeover"
                                                      });
                                                    }
                                                  });

                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("Yes",
                                                    style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                color: Colors.green,
                              ),

                              color:Colors.green,
                            ),
                            child: Text("Accept", style: GoogleFonts.lato(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ):
            Container(
              child: Column(
                children: [
                  Container(
//                          color : Colors.green.shade100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WELLON",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green),
                                ),
                                Text(
                                  (order_id!="null")?order_id:"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (who_order_for=="Self"||who_order_for==null)?Text(
                                  (customer_name!="null")?customer_name.toUpperCase():"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ):Text(
                                  (other_cust_name!="null")?other_cust_name.toUpperCase():"",
                                  style: GoogleFonts.lato(fontSize: 22,
                                      color: Colors.green,fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),


                          new Divider(
                            color: Colors.black,
                          ),


                          Container(
                            child: (ro_img!="null")?
                            Container(
                                alignment: Alignment.center,
                                child: new Image.network(RestDatasource. BASE_URL + "custroproductimages/" + ro_img, width: 200, height: 200,)
                            ):Container(
                                child: new Image.asset("images/img.png", width: 200, height: 200,)
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (o_type_name!="null")?(o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (o_category!="null")?o_category.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'Machine',
                          //             style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                          //           ),
                          //           Text(
                          //             (o_machine!="null")?o_machine.toUpperCase():"---",
                          //             style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Installation Type',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (instance_normal!="null")?instance_normal.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Water TDS',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (raw_tds!="null")?raw_tds:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RO Capacity',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (ro_capacity!="null")?ro_capacity:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Has RO Water Purifier ?',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (is_ro!="null")?(is_ro=="Y")?"Yes":"NO":"---",
//                                              (is_ro=="Y" "Yes")?is_ro:"NO",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Brand',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      (brandname!="null")?brandname:(otherbrand!=null)?otherbrand:"---",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Model',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                    ),
                                    Container(
                                      width: 280,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          (modelname!="null")?modelname:(othermodel!=null)?othermodel:"---",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Customer Note',
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                (customer_remark!="null")?customer_remark:"---",
                                style: GoogleFonts.lato(fontSize: 16,
                                    color: Colors.grey.shade700),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address',
                                          style: GoogleFonts.lato(fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ((house_no!="null")?house_no:"")+
                                              ((house_name!="null")?" , "+house_name:""),
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (address1!="null")?address1+" ,":"",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (address3!="null")?address3+" ,":"",
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          ((address2!="null")?address2:"")+
                                              ((pincode!="null")?" - "+pincode:""),
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: (){
                                          MapsLauncher.launchCoordinates(
                                              latitude, longitude, 'Google Headquarters are here');
                                          Text('LAUNCH COORDINATES');
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: new Image.asset("images/map.png", width: 80, height: 80,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      'Service Date',
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      (prefer_date!="null")?prefer_date:"---",
                                      style: GoogleFonts.lato(fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Text(
                                      'Service Time',
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      (prefer_time!="null")?prefer_time:"---",
                                      style: GoogleFonts.lato(fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Installation Charge Amount',
                                style: GoogleFonts.lato(fontSize: 18,
                                    color: Colors.black,fontWeight: FontWeight.w700),
                              ),
                              FutureBuilder<List<ProductKitList>>(
                                  future: newProductKitListdata,
                                  builder: (context,snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                    else if (!snapshot.hasData) {
                                      return Center(
                                        child: Text("No Any Kit Choose"),
                                      );
                                    }
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(top: 5),
                                      children: snapshot.data
                                          .map((data) =>
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      data.op_title,
                                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ).toList(),
                                    );
                                  }
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20,),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'You Get',
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                (getamt!="null")?Text(
                                  (getamt!="null")?"₹"+getamt:"₹0",
                                  style: GoogleFonts.lato(fontSize: 35, color: Colors.black),
                                ):Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),

                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text("Reject Order",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text("Are you sure you want to reject this order?",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,false);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("No",
                                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              width: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _netUtil.post(RestDatasource.REJECT_NEW_ORDER, body: {
                                                    "order_id": order_id,
                                                    "provider_id":prefs.getString("provider_id"),
                                                  }).then((dynamic res) async {
                                                    //print(res);
                                                    if (res["status"] =="Order Rejected" || res["status"] =="Final Order Rejected") {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "reject"
                                                      });
                                                      FlashHelper
                                                          .successBar(
                                                          context,
                                                          message: "Order Rejected");
                                                    }
                                                    else {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "reject"
                                                      });
                                                      FlashHelper.errorBar(
                                                          context,
                                                          message: "Order Rejected.");
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("Yes",
                                                    style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Colors.green..shade400,
                                ),
                                color:Colors.green..shade400
                            ),
                            child: Text("Reject", style: GoogleFonts.lato(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text("Accept Order",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text("Are you sure you want to accept this order?",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context,false);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("No",
                                                    style: GoogleFonts.lato(color:Colors.black,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              width: 0.5,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  //print("Hii Patel Vatsal");
                                                  //print(order_id);
                                                  _netUtil.post(RestDatasource.ACCEPT_NEW_ORDER, body: {
                                                    "order_id": order_id,
                                                    "provider_id":prefs.getString("provider_id"),
                                                  }).then((dynamic res) async {
                                                    //print(res);
                                                    if (res["status"] =="Order Accepted") {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "accept"
                                                      });
                                                    }
                                                    else {
                                                      Navigator.of(context).pushNamed("/thanks",arguments: {
                                                        "status" : "rejecttimeover"
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                  alignment: Alignment.center,
                                                  child: Text("Yes",
                                                    style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Colors.green.shade400,
                                ),

                                color:Colors.green.shade400
                            ),
                            child: Text("Accept", style: GoogleFonts.lato(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ):
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
          ],

        ),
      ),
    );
  }
}