import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/category_list.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_list_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import '../../sizeconfig.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  BuildContext _ctx;
  int counter = 0;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();
  String _otpcode;
  var db = new DatabaseHelper();
  String cartproductcount;
  Future<List<CategoryList>> categoryListdata;
  Future<List<CategoryList>> categoryListdata1;
  Future<List<CategoryList>> categoryListfilterData;
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

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }
  _loadPref() async {
    var count=await LoadData.totalcartitems();
    prefs = await SharedPreferences.getInstance();
    _netUtil.post(RestDatasource.GET_CART_LIST, body: {
      "provider_id": prefs.getString("provider_id")
    }).then((dynamic res) {
      setState(() {
        cartproductcount=res["totalcartitem"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Shopping",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
        //   iconTheme: IconThemeData(
        //     color: Colors.white, //change your color here
        //   ),
        //   backgroundColor: Colors.green,
        // ),
        body:
          Stack(
            children: [
              Container(width:MediaQuery.of(context).size.width/100*35,child: Image.asset("images/shoppingbg.png",height: double.infinity,fit: BoxFit.fill,)),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width/100*65,
                    child: Divider(),
                  ),
                ),
              ),
              RefreshIndicator(
                key: _refreshIndicatorKey1,
                color: Colors.black,
                onRefresh: ()async{
                  _loadPref();
                  await LoadData.refreshcategory();
                  await LoadData.totalcartitems();
                  setState((){});
                },
                child: FutureBuilder<List<CategoryList>>(
                  future:LoadData.categoryListdata,
                  builder: (context,snapshot) {
                    //print(snapshot.error);
                    //print(snapshot.hasData);
                    if (snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    else if (!snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height*1.0,
                          child: Center(
                            child: Text("No Data Available!"),
                          ),
                        ),
                      );
                    }
                    return ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 80),
                      children: snapshot.data
                          .map((data) =>
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      childCurrent: ShopScreen(),
                                      duration: Duration(milliseconds: 500),
                                      reverseDuration: Duration(milliseconds: 500),
                                      type: PageTransitionType.leftToRight,
                                      child: ShopProductListScreen(
                                        categoryid: data.category_id,
                                        categoryname: data.category_name,
                                        size:MediaQuery.of(context).size.width/100*35
                                      ),
                                    ),
                                  );
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => ShopProductListScreen(
                                  //         categoryid: data.category_id,
                                  //       ),
                                  //     ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(children:[
                                      Container(height:150,width: 150,child: ClipRRect(child: Image.asset("images/category-icn-bg.png"),)),
                                      data.cat_image.toString()!=""?Padding(
                                        padding: const EdgeInsets.only(left: 30,top: 25),
                                        child: Container(height:90,width: 90,child: ClipRRect(child: Image.network(RestDatasource.BASE_URL+"categoryimages/"+data.cat_image,errorBuilder: (context, url, error) => new Image.asset("images/nophoto.png"),),)),
                                      ):Container(height:90,width: 90,child: ClipRRect(child: Image.asset("images/nophoto.png"),)),
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 60),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.category_name!=null?data.category_name:"",style: TextStyle(fontSize: 22,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                          Text("${data.productcount!=null?data.productcount:""} Items",style: TextStyle(fontSize: 16,color: Color(0xff333333).withOpacity(0.8),fontWeight: FontWeight.w600),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Image.asset("images/next.png",height: 35,width: 35,),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width:MediaQuery.of(context).size.width/100*65,
                                  child: Divider(),
                                ),
                              ),
                            ],
                          )
                      ).toList(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 15),
                child: Align(alignment: Alignment.topLeft,child: Image.asset("images/left-arrow.png",height: 35,width: 35,)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Shopping",style: TextStyle(fontSize: 22,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                  )
              ),
              Stack(
                  children:[
                    Padding(
                      padding: const EdgeInsets.only(right: 15,top: 15),
                      child: Align(alignment: Alignment.topRight,child: InkWell(onTap:(){
                        Navigator.push(
                          context,
                          PageTransition(
                            childCurrent: ShopScreen(),
                            duration: Duration(milliseconds: 500),
                            reverseDuration: Duration(milliseconds: 500),
                            type: PageTransitionType.leftToRight,
                            child: ProductCartScreen(
                                size:MediaQuery.of(context).size.width/100*100
                            ),
                          ),
                        );
                      },child: Image.asset("images/interest.png",height: 35,width: 35,))),
                    ),
                    cartproductcount==null?Container():Padding(
                        padding: const EdgeInsets.only(top: 32,right: 24),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(cartproductcount??"0",style: TextStyle(fontSize: 14,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                        )
                    ),
                  ]
              ),
            ],
          )
      ),
    );
  }
}