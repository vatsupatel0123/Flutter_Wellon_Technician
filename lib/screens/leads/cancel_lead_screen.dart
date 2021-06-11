import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/product_kit_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class LeadCancelScreen extends StatefulWidget {
  @override
  _LeadCancelScreenState createState() => _LeadCancelScreenState();
}

class _LeadCancelScreenState extends State<LeadCancelScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;
  bool _isdataLoading = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();

  String _cust_remark="",provider_id="";

  String order_id="0",customer_id="0",type_id="0",orderd_contact_number="0",orderd_name="",house_no="",house_name="",address1="",address2="",address3="",pincode="0",latitude ="0";
  String longitude="0",ro_product_photo="",prefer_date="",prefer_time="",order_date_time="",expire_date_time="";
  String order_status="",order_created_by="",is_complete_customer="",is_complete_sp="",order_complete_date_time="",cust_remark="";
  String created_at="",updated_at="",type_name="",who_order_for="",other_cust_name="",other_cust_contact="";
  String brandid="",modelid="",brandname="",brandimg="",modelname="",modelimg,expire_time="",customer_name="";
  String o_machine="",instance_normal="",o_category="",o_type_name="",payable_amount="0",cod_pay,cod_amount="0",paymode="0",raw_tds="",ro_capacity="",system_old_new="",old_year="";
  String is_ro="",ro_img,getamt,other_brand,other_model;


  _loadamt() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _netUtil.post(RestDatasource.GET_SP_ORDERAMT, body: {
        "order_id": order_id,
        "provider_id":prefs.getString("provider_id"),
      }).then((dynamic res) async {
        setState(() {
          //print(res);
          getamt=res["sp_get_price"].toString();
          _isdataLoading=false;
        });
      });

    });
  }

  //Net Connection
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  Future<List<ProductKitList>> newProductKitListdata;

  _loadPref() async {
    prefs  = await SharedPreferences.getInstance();
    provider_id= prefs.getString("provider_id") ?? '';
    setState(() {
      newProductKitListdata = _getProductKitData();
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
      //print(items);
      List<ProductKitList> listofusers = items.map<ProductKitList>((json) {
        return ProductKitList.fromJson(json);
      }).toList();
      List<ProductKitList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  @override
  initState() {
    _loadPref();
    _loadamt();
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        setState(() {
          order_id = arguments['order_id'].toString();
          customer_id = arguments['customer_id'].toString();
          type_id = arguments['type_id'].toString();
          orderd_contact_number = arguments['orderd_contact_number'];
          orderd_name = arguments['orderd_name'];
          house_no = arguments['house_no'];
          house_name = arguments['house_name'];
          address1 = arguments['address1'];
          address2 = arguments['address2'];
          address3 = arguments['address3'];
          pincode = arguments['pincode'];
          latitude = arguments['latitude'];
          longitude = arguments['longitude'];
          ro_product_photo = arguments['ro_product_photo'];
          prefer_date = arguments['prefer_date'];
          prefer_time = arguments['prefer_time'];
          order_date_time = arguments['order_date_time'];
          expire_date_time = arguments['expire_date_time'];
          order_status = arguments['order_status'];
          order_created_by = arguments['order_created_by'];
          is_complete_customer = arguments['is_complete_customer'];
          is_complete_sp = arguments['is_complete_sp'];
          order_complete_date_time = arguments['order_complete_date_time'];
          cust_remark = arguments['cust_remark'].toString();
          created_at = arguments['created_at'];
          updated_at = arguments['updated_at'];
          type_name = arguments['type_name'];
          brandid = arguments['brandid'].toString();
          modelid = arguments['modelid'].toString();
          brandname = arguments['brandname'];
          other_brand = arguments['other_brand'];
          other_model = arguments['other_model'];
          brandimg = arguments['brandimg'];
          modelname = arguments['modelname'];
          modelimg = arguments['modelimg'];
          customer_name = arguments['customer_name'];
          who_order_for = arguments['who_order_for'];
          other_cust_name = arguments['other_cust_name'];
          other_cust_contact = arguments['other_cust_contact'];
          o_machine = arguments['o_machine'];
          instance_normal = arguments['instance_normal'];
          o_category = arguments['o_category'];
          o_type_name = arguments['o_type_name'];
          payable_amount = arguments['payable_amount'];
          cod_amount = arguments['cod_amount'];
          cod_pay = arguments['cod_pay'];
          paymode = arguments['paymode'];
          raw_tds = arguments['raw_tds'];
          ro_capacity = arguments['ro_capacity'];
          system_old_new = arguments['system_old_new'];
          old_year = arguments['old_year'];
          is_ro = arguments['is_ro'];
          ro_img = arguments['ro_img'];

          //print(ro_img);

          _isdataLoading=false;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text("Cancel Lead",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body:ListView(
        padding: EdgeInsets.only(top: 5),
        children: <Widget>[

          (o_type_name == "ro") ?
          Container(
            child: Column(
              children: [
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: new Image.asset("images/profile_img.png", width: 90, height: 90,)
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: (who_order_for=="Self"||who_order_for=="")?Text((orderd_name!="")?orderd_name.toUpperCase():"---",style: GoogleFonts.lato(fontSize: 18)):Text((other_cust_name!="")?other_cust_name.toUpperCase():"---",style: GoogleFonts.lato(fontSize: 18)),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on, color: Colors.grey.shade600, size: 16.0,
                                          ),
                                          Container(
                                            width:MediaQuery.of(context).size.width*0.55,
                                            child: Text(
                                              ((address2!=null)?address2:"---")+((pincode!=null)?" - "+pincode:"---"),
                                              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ]
                    ),

                  ),
                ),
                Card(
                  elevation: 2.0,
                  color : Colors.green.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(

                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Complete Date - Time',
                                  style: GoogleFonts.lato(fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  (order_complete_date_time!="")?order_complete_date_time:"---",
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.grey.shade800,fontWeight: FontWeight.w700),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ((house_no!=null)?house_no:"")+
                                          ((house_name!=null)?" , "+house_name:""),
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      (address1!=null)?address1+" ,":"",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      (address3!=null)?address3+" ,":"",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      ((address2!=null)?address2:"")+
                                          ((pincode!=null)?" - "+pincode:""),
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
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
                                      (o_type_name!=null)?(o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
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
                                      (o_category!="")?o_category.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
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
                          //             (o_machine!="")?o_machine.toUpperCase():"---",
                          //             style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
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
                                      (instance_normal!="")?instance_normal.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),SizedBox(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'You Get',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Collect Cash From Customer',
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (getamt!=null)?Text(
                                      (getamt!="")?"₹"+getamt:"₹0",
                                      style: GoogleFonts.lato(fontSize: 30, color: Colors.black),
                                    ):Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      (cod_pay=="Y")?
                                      (payable_amount!="")?"₹"+payable_amount:"₹0.00"
                                          :"₹0.00",
                                      style: GoogleFonts.lato(fontSize: 30, color: Colors.black),
                                    ),
                                  ],
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
                ),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                'Useful Information',
                                style: GoogleFonts.lato(fontSize: 20,
                                    color: Colors.black,fontWeight: FontWeight.w700),
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
                                    (ro_capacity!="")?ro_capacity:"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (system_old_new!="")?system_old_new:"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (old_year!="")?old_year:"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (ro_capacity!="")?ro_capacity:"",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (brandname!="")?brandname:other_brand,
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),SizedBox(
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
                                    width:MediaQuery.of(context).size.width*0.70,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        (modelname!="")?modelname:other_model,
                                        style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    color: Colors.black,fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              (cust_remark!="")?cust_remark:"---",
                              style: GoogleFonts.lato(fontSize: 16,
                                  color: Colors.grey.shade600),
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
                        Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: (ro_product_photo!="")?Image.network(RestDatasource. BASE_URL + "custproductimages/" + ro_product_photo, width: 80, height: 80,):new Image.asset("images/noavlimage.jpeg", width: 80, height: 80,)
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'RO Image',
                              style: GoogleFonts.lato(fontSize: 18,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          ):
          Container(
            child: Column(
              children: [
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: new Image.asset("images/profile_img.png", width: 90, height: 90,)
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: (who_order_for=="Self"||who_order_for=="")?Text((orderd_name!="")?orderd_name.toUpperCase():"---",style: GoogleFonts.lato(fontSize: 18)):Text((other_cust_name!="")?other_cust_name.toUpperCase():"---",style: GoogleFonts.lato(fontSize: 18)),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on, color: Colors.grey.shade600, size: 16.0,
                                          ),
                                          Container(
                                            width:MediaQuery.of(context).size.width*0.55,
                                            child: Text(
                                              ((address2!=null)?address2:"---")+((pincode!=null)?" - "+pincode:"---"),
                                              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ]
                    ),

                  ),
                ),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(
                    color : Colors.green.shade300,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Completed Date - Time',
                                  style: GoogleFonts.lato(fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  (order_complete_date_time!="")?order_complete_date_time:"---",
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.grey.shade800,fontWeight: FontWeight.w700),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      style: GoogleFonts.lato(fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ((house_no!=null)?house_no:"")+
                                          ((house_name!=null)?" , "+house_name:""),
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      (address1!=null)?address1+" ,":"",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      (address3!=null)?address3+" ,":"",
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      ((address2!=null)?address2:"")+
                                          ((pincode!=null)?" - "+pincode:""),
                                      style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800,fontWeight: FontWeight.w700),
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
                                      (o_type_name!=null)?(o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
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
                                      (o_category!="")?o_category.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 3,
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
                          //             (o_machine!="")?o_machine.toUpperCase():"---",
                          //             style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
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
                                      (instance_normal!="")?instance_normal.toUpperCase():"---",
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Collect Cash From Customer',
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(
                                  (cod_pay=="Y")?
                                  (o_category=="installation")?
                                  (cod_amount!="")?"₹"+cod_amount:"₹0.00":(payable_amount!="")?"₹"+payable_amount:"₹0.00"
                                      :"₹0.00",
                                  style: GoogleFonts.lato(fontSize: 30, color: Colors.black),
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
                ),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 20, 5),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Useful Information',
                            style: GoogleFonts.lato(fontSize: 20,
                                color: Colors.black,fontWeight: FontWeight.w700),
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
                                    (raw_tds!="")?raw_tds:"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (ro_capacity!="")?ro_capacity:"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    'Has RO Water Purifier ?',
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    (is_ro!=null)?(is_ro=="Y")?"Yes":"NO":"---",
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    (brandname!="")?brandname:other_brand,
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    width:MediaQuery.of(context).size.width*0.70,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        (modelname!="")?modelname:other_model,
                                        style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
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
                                    color: Colors.black,fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              (cust_remark!="")?cust_remark:"---",
                              style: GoogleFonts.lato(fontSize: 16,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),new Divider(
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
                              (o_category=="installation")?"Installation Charge Amount":"Service Charge Amount",
                              style: GoogleFonts.lato(fontSize: 18,
                                  color: Colors.black,fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "You Get",
                                    style: GoogleFonts.lato(fontSize: 18,
                                        color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    (getamt!=null)?"₹"+getamt:"₹0",
                                    style: GoogleFonts.lato(fontSize: 18,
                                        color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kit Charge",
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.grey.shade700),
                                ),
                                Text(
                                  "₹0",
                                  style: GoogleFonts.lato(fontSize: 18,
                                      color: Colors.grey.shade700),
                                ),
                              ],
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
                                    padding: EdgeInsets.only(top: 5,left: 30),
                                    children: snapshot.data
                                        .map((data) =>
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.subdirectory_arrow_right, color: Colors.grey.shade700, size: 20.0,
                                                ),
                                                Text(
                                                  data.op_title,
                                                  style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
                                                ),
                                              ],
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child: (ro_product_photo!="")?Image.network(RestDatasource. BASE_URL + "custproductimages/" + ro_product_photo, width: 80, height: 80,):new Image.asset("images/noavlimage.jpeg", width: 80, height: 70,)
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'RO Image',
                                    style: GoogleFonts.lato(fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child: (ro_img!="")?Image.network(RestDatasource. BASE_URL + "custroproductimages/" + ro_img, width: 80, height: 80,):new Image.asset("images/nophoto.png", width: 80, height: 80,)
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Model Image',
                                    style: GoogleFonts.lato(fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          )
        ],

      ),
    );
  }
}
