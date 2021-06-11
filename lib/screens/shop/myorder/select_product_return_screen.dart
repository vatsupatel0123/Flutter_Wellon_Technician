import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:wellon_partner_app/screens/shop/myorder/bank_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/myorder_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/reasons_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class SelectReturnProductScreen extends StatefulWidget {
  final String sporder_id;
  SelectReturnProductScreen({this.sporder_id});
  @override
  _SelectReturnProductScreenState createState() => _SelectReturnProductScreenState();
}


class _SelectReturnProductScreenState extends State<SelectReturnProductScreen>{
  BuildContext _ctx;

  NetworkUtil _netUtil = new NetworkUtil();
  bool _isdataLoading = false,_othertextbox=false;

  String spfullname="",provider_id="0",profilephoto="",version="3.0";

  SharedPreferences prefs;
  bool is_active = false,resendMessageVisible = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode,_other;
  TextEditingController _other_namecontroller=new TextEditingController();
  int _radioValue1=0;
  Future<List<MyOrderDetailsList>> categoryproductListdata;
  List<MyOrderDetailsList> selectedproducts = new List<MyOrderDetailsList>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    //print("setstate called");
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
  Future<List<MyOrderDetailsList>> _getCategoryData() async
  {
    return _netUtil.post(RestDatasource.MY_ORDER_DETAILS,body: {
      "sporder_id":widget.sporder_id
    }).then((dynamic res)
    {
      //print(res);
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<MyOrderDetailsList> listofusers = items.map<MyOrderDetailsList>((json) {
        return MyOrderDetailsList.fromJson(json);
      }).toList();
      List<MyOrderDetailsList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }
  void selectproduct(){
    setState(() {
      selectedproducts.clear();
      if(categoryproductListdata.toString().length != 0) {
        categoryproductListdata.then((value) {
          value.forEach((element) {
            if(element.chkproduct)
              {
                MyOrderDetailsList item = new MyOrderDetailsList();
                item.product_id = element.product_id;
                item.productname = element.productname;
                item.price = element.price;
                item.quantity = element.quantity;
                selectedproducts.add(item);
              }
          });
        });
      }
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
            title: Text("Return Order",style: TextStyle(color: Colors.white),),
            centerTitle: true,
            backgroundColor: Colors.green,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<MyOrderDetailsList>>(
                  future: categoryproductListdata,
                  builder: (context,snapshot) {
                    //print(snapshot.error);
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
                      physics: NeverScrollableScrollPhysics(),
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
                              padding: const EdgeInsets.only(left: 0,right: 20,top: 10,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: data.chkproduct,
                                            activeColor: Colors.green,
                                            onChanged: (bool val){
                                              setState(() {
                                                  data.chkproduct=val;
                                                  selectproduct();
                                              });
                                            },
                                          ),
                                          Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1,height: 100,width: 100,),
                                        ],
                                      ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
                  child: InkWell(
                    onTap: () async{
                      if(selectedproducts.isEmpty)
                        {
                          Fluttertoast.showToast(msg: "Select Product",backgroundColor: Colors.red,gravity: ToastGravity.CENTER);
                        }
                      else
                        {
                          var jsonData;
                          jsonData = jsonEncode(selectedproducts.map((e) => e.toMap()).toList());
                          //print(jsonData);
                          Navigator.push(context, PageTransition(child: MYReasonsScreen(screen: "Return",sporder_id: widget.sporder_id,productdata: jsonData,), type: PageTransitionType.bottomToTop));
                        }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 13,bottom: 13),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: _isLoading?Center(child: CircularProgressIndicator(),):Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20,letterSpacing:1,fontWeight: FontWeight.w600),)),
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }
  }
}
