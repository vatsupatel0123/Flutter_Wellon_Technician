import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/category_list.dart';
import 'package:wellon_partner_app/models/categoryproduct_list.dart';
import 'package:wellon_partner_app/models/pass_product_data.dart';
import 'package:wellon_partner_app/models/product_cart_list.dart';
import 'package:wellon_partner_app/screens/shop/place_order_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_list_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';


import '../../sizeconfig.dart';

class ShopProductListScreen extends StatefulWidget {
  final String categoryid;
  final String categoryname;
  final double size;
  ShopProductListScreen({this.categoryid,this.size,this.categoryname});
  @override
  _ShopProductListScreenState createState() => _ShopProductListScreenState();
}

class _ShopProductListScreenState extends State<ShopProductListScreen> with TickerProviderStateMixin{
  BuildContext _ctx;
  int counter = 0;
  double width,height=150,imagesizeheight=100,imagesizewidth=100;
  AlignmentGeometry _alignment = Alignment.centerLeft;
  bool _isLoading = false,_isexpanded = false,_iscollaps = true,_movetext=false,imageview=false,zoomstart=false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  int cartproductcount;
  NetworkUtil _netUtil = new NetworkUtil();
  var db = new DatabaseHelper();
  ItemData item = new ItemData();
  String _otpcode,imagepath="";
  Future<List<CategoryProductList>> categoryproductListdata;
  Future<List<CategoryProductList>> categoryproductListfilterData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  final CarouselController _controller = CarouselController();
  List<ItemData> selectedlistData=new List<ItemData>();

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
    _loadcartitems();
    width=widget.size;
  }

  startTime() async {
    var _duration = new Duration(microseconds: 100);
    return new Timer(_duration, increase);
  }
  void increase(){
    setState(() {
      width=MediaQuery.of(context).size.width/100*50;
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      ////print(isOffline);
    });
  }
  _loadPref() async {
    int count=await db.getCountCart();
    setState(() {
      cartproductcount=count;
      categoryproductListdata = _getCategoryData();
      categoryproductListfilterData=categoryproductListdata;
    });
  }
  Future<List<CategoryProductList>> _getCategoryData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_CATEGORY_PRODUCT,body: {
      "category_id":widget.categoryid
    }).then((dynamic res)
    {
      //print(res);
      if(res.toString()=="[]")
      {
        return null;
      }
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<CategoryProductList> listofusers = items.map<CategoryProductList>((json) {
        return CategoryProductList.fromJson(json);
      }).toList();
      List<CategoryProductList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }
  Future<List<CategoryProductList>> _refresh1() async
  {
    await LoadData.totalcartitems();
    setState(() {
      categoryproductListdata = _getCategoryData();
      categoryproductListfilterData=categoryproductListdata;
    });
  }
  void _loadcartitems() async {
    await LoadData.totalcartitems();
    setState((){
    });
  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    startTime();
    return SafeArea(
      child: Scaffold(
          body:
          Stack(
            children: [

              AnimatedSize(duration:Duration(milliseconds: 700),vsync:this,curve: Curves.easeIn,child: Container(width:width,child: Image.asset("images/shoppingbg.png",height: double.infinity,fit: BoxFit.fill,))),
              Padding(
                  padding: const EdgeInsets.only(top: 100,left: 40),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.categoryname,style: TextStyle(fontSize: 35,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                  )
              ),
              RefreshIndicator(
                key: _refreshIndicatorKey1,
                color: Colors.black,
                onRefresh: _refresh1,
                child: FutureBuilder<List<CategoryProductList>>(
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
                      padding: EdgeInsets.only(top: 160,bottom: 40),
                      children: snapshot.data
                          .map((data) =>
                          Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin: EdgeInsets.only(left: 20,right: 20,top: 40),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    (data.image1.toString()!="null"&&data.image2.toString()!="null"&&data.image3.toString()!="null"?
                                      AnimatedSize(
                                        duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,
                                        child: Container(
                                          height:data.isexpanded?180:100,
                                          width: data.isexpanded?double.infinity:100,
                                          child: CarouselSlider(
                                            carouselController: _controller,
                                            options: CarouselOptions(
                                              height: data.isexpanded?180:100,
                                              aspectRatio: 16/9,
                                              viewportFraction: 1.0,
                                              initialPage: 0,
                                              enableInfiniteScroll: false,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval: Duration(seconds: 3),
                                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            items: [1,2,3].map((i) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return
                                                    (i==1)?
                                                    InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg1/"+data.image1;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: PinchZoomImage(image: Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),),))))):(i==2)?
                                                    InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg2/"+data.image2;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child:PinchZoomImage(image: Image.network(RestDatasource.BASE_URL+"pimg2/"+data.image2),zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0))))))):InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg3/"+data.image3;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: PinchZoomImage(image: Image.network(RestDatasource.BASE_URL+"pimg3/"+data.image3),zoomedBackgroundColor: Color.fromRGBO(500 ,500, 500, 1.0)),)))));
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ):
                                      data.image1.toString()!="null"&&data.image2.toString()!="null"&&data.image3.toString()=="null"?
                                      AnimatedSize(
                                        duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,
                                        child: Container(
                                          height:data.isexpanded?180:100,
                                          width: data.isexpanded?double.infinity:100,
                                          child: CarouselSlider(
                                            carouselController: _controller,
                                            options: CarouselOptions(
                                              height: data.isexpanded?180:100,
                                              aspectRatio: 16/9,
                                              viewportFraction: 1.0,
                                              initialPage: 0,
                                              enableInfiniteScroll: false,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval: Duration(seconds: 3),
                                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            items: [1,2].map((i) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return (i==1)?
                                                  InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg1/"+data.image1;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child:Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),))))):InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg2/"+data.image2;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: Image.network(RestDatasource.BASE_URL+"pimg2/"+data.image2),)))));
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ):
                                      data.image1.toString()!="null"&&data.image2.toString()=="null"&&data.image3.toString()!="null"?
                                      AnimatedSize(
                                        duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,
                                        child: Container(
                                          height:data.isexpanded?180:100,
                                          width: data.isexpanded?double.infinity:100,
                                          child: CarouselSlider(
                                            carouselController: _controller,
                                            options: CarouselOptions(
                                              height: data.isexpanded?180:100,
                                              aspectRatio: 16/9,
                                              viewportFraction: 1.0,
                                              initialPage: 0,
                                              enableInfiniteScroll: false,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval: Duration(seconds: 3),
                                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            items: [1,2].map((i) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return (i==1)?
                                                  InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg1/"+data.image1;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child:Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),))))):
                                                  InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg3/"+data.image3;});},child: AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height: data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg3/"+data.image3;});},child: Image.network(RestDatasource.BASE_URL+"pimg3/"+data.image3)),)))));
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ):
                                      data.image1.toString()!="null"&&data.image2.toString()=="null"&&data.image3.toString()=="null"?
                                      AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height:data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg1/"+data.image1;});},child: PinchZoomImage(image:  Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0))),)))):AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height:data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: InkWell(onTap: (){setState(() {imageview=true;imagepath=RestDatasource.BASE_URL+"pimg1/"+data.image1;});},child: PinchZoomImage(image:  Image.asset("images/nophoto.png"),zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0))),))))),
                                    /*data.image1.toString()!=""?
                                    AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height:data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),)))):
                                    data.image2.toString()!=""?
                                    AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height:data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),)))):
                                    AnimatedSize(duration:Duration(milliseconds: 800),reverseDuration:Duration(milliseconds: 800),vsync:this,curve: Curves.easeIn,child: AnimatedAlign(alignment:data.alignment,duration:Duration(milliseconds: 800),child: Container(height:data.imagesizeheight,width: data.imagesizewidth,child: ClipRRect(child: Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1),)))),*/
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 800),
                                      left: data.isexpanded?20:130,
                                      top: data.isexpanded?200:0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: data.isexpanded? MediaQuery.of(context).size.width/100*80: MediaQuery.of(context).size.width/100*60,child: Text(data.productname!=null?data.productname:"",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,color: Color(0xff333333),fontWeight: FontWeight.w600),)),
                                          SizedBox(height: 5,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("₹${data.invoice_price.toString()}",style: TextStyle(fontSize: 20,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Text("₹${data.gst_price.toString()} (${data.gstrate.toString()}%)",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                  SizedBox(width: 5,),
                                                  Text("${data.incl_excl_gst.toString()} GST",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Container(
                                                  height: 30,width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Color(0xffffffff),
                                                    boxShadow: [//background color of box
                                                      BoxShadow(
                                                        color: Color(0xffcccccc),
                                                        blurRadius: 10.0, // soften the shadow
                                                        spreadRadius: 0.0, //extend the shadow
                                                      )
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5),
                                                        child: InkWell(onTap:(){
                                                          setState(() {
                                                            if(data.minmum_qua!=data.original_minmum_qua)
                                                            {
                                                              data.minmum_qua=data.minmum_qua-data.original_minmum_qua;
                                                            }
                                                          });
                                                        },child: Image.asset("images/minus.png",fit: BoxFit.fill,height: 20,width: 20,)),
                                                      ),
                                                      Text(data.minmum_qua.toString(),style: TextStyle(fontSize: 20,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 5),
                                                        child: InkWell(onTap:(){
                                                          setState(() {
                                                            data.minmum_qua=data.minmum_qua+data.original_minmum_qua;
                                                          });
                                                        },child: Image.asset("images/plus.png",fit: BoxFit.fill,height: 20,width: 20,)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: data.iscollapsage,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20,top: 125),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async{
                                                      setState(() {
                                                        data.isLoading=true;
                                                      });
                                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      //print("data.minmum_qua.toString()");
                                                      //print(data.minmum_qua.toString());
                                                      _netUtil.post(RestDatasource.ADD_TO_CART,body: {
                                                        "provider_id":prefs.getString("provider_id"),
                                                        "cproduct_id":data.cproduct_id,
                                                        "quantity":data.minmum_qua.toString(),
                                                      }).then((dynamic res)
                                                      {
                                                        if(res["status"]=="insert")
                                                          {
                                                            setState(() {
                                                              _loadcartitems();
                                                              data.isLoading=false;
                                                            });
                                                            EasyLoading.showSuccess('Added To Cart',duration: Duration(seconds: 1),dismissOnTap: true,);
                                                          }
                                                        else
                                                          {
                                                            setState(() {
                                                              data.isLoading=false;
                                                            });
                                                            Fluttertoast.showToast(msg: "Already Added In Cart",textColor: Colors.red,backgroundColor: Colors.white);
                                                          }
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xffffd30d)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                        child: data.isLoading?CircularProgressIndicator(backgroundColor: Colors.green,):Text("Add to Cart",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      String price=(double.parse(data.invoice_price)*data.minmum_qua).toString();
                                                      selectedlistData.clear();
                                                      ItemData item = new ItemData();
                                                      item.cproduct_id = data.cproduct_id;
                                                      item.quantity = data.minmum_qua.toString();
                                                      item.price = price;
                                                      selectedlistData.add(item);
                                                      var jsonData;
                                                      jsonData = jsonEncode(selectedlistData.map((e) => e.toMap()).toList());
                                                      //print(jsonData);
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          childCurrent: ProductCartScreen(),
                                                          duration: Duration(milliseconds: 500),
                                                          reverseDuration: Duration(milliseconds: 500),
                                                          type: PageTransitionType.bottomToTop,
                                                          child: PlaceOrderScreen(total:double.parse(price),data: jsonData),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xff4cb050)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                        child: Text("Buy Now",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ),
                                                  //SizedBox(width: 10,),
                                                  // InkWell(
                                                  //   onTap: (){
                                                  //     setState(() {
                                                  //       data.alignment=Alignment.topCenter;
                                                  //       Timer(Duration(milliseconds: 800),(){
                                                  //         data.image_expand=true;
                                                  //       });
                                                  //       data.isexpanded=true;
                                                  //       data.iscollapsage=false;
                                                  //       data.imagesizeheight=180;
                                                  //       data.imagesizewidth=180;
                                                  //     });
                                                  //   },
                                                  //   child: Container(
                                                  //     decoration: BoxDecoration(
                                                  //         borderRadius: BorderRadius.circular(20),
                                                  //         color: Color(0xffcccccc)
                                                  //     ),
                                                  //     child: Padding(
                                                  //       padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                  //       child: Text("View More",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: data.isexpanded,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 340),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(left: 0),
                                            //   child: Center(child: Container(height:180,width: 180,child: ClipRRect(child: Image.asset("images/category-icn.png"),))),
                                            // ),
                                            // Text("Wellon 30 LPH Stainless Steel RO+Alkaline With HOT Water Dispenser",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                            // SizedBox(height: 5,),
                                            // RatingBarIndicator(
                                            //   rating: 4,
                                            //   itemBuilder: (context, index) => Icon(
                                            //     Icons.star,
                                            //     color: Color(0xffffd30d),
                                            //   ),
                                            //   itemCount: 5,
                                            //   itemSize: 30.0,
                                            //   unratedColor: Color(0xffcccccc),
                                            // ),
                                            // SizedBox(height: 5,),
                                            // Row(
                                            //   children: [
                                            //     Text("50,000",style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                            //     SizedBox(width: 10,),
                                            //     Text("40,000",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                            //     SizedBox(width: 10,),
                                            //     Text("(10% off)",style: TextStyle(fontSize: 16,color: Color(0xff4cb050),fontWeight: FontWeight.w600),),
                                            //   ],
                                            // ),
                                            // SizedBox(height: 10,),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.start,
                                            //   crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     Text("•",style: TextStyle(fontSize: 18,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                            //     SizedBox(width: 10,),
                                            //     Flexible(child: Text("30 LPH Stainless Steel RO+Alkaline With HOT Water Dispenser 30 Litrs/ HR RO + ALKALINE Hot water 1.5 storage / Normal 8 LitersAnti Bacterial SS Tank (304 Grade)Seprate Switch For Instant HOT Water",maxLines:5,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),)),
                                            //   ],
                                            // ),
                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 0,top: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap:()async{
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xffffd30d)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                        child: Text("Add to Cart",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      String price=(double.parse(data.invoice_price)*data.minmum_qua).toString();
                                                      selectedlistData.clear();
                                                      ItemData item = new ItemData();
                                                      item.cproduct_id = data.cproduct_id;
                                                      item.quantity = data.minmum_qua.toString();
                                                      item.price = price;
                                                      selectedlistData.add(item);
                                                      var jsonData;
                                                      jsonData = jsonEncode(selectedlistData.map((e) => e.toMap()).toList());
                                                      //print(jsonData);
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          childCurrent: ProductCartScreen(),
                                                          duration: Duration(milliseconds: 500),
                                                          reverseDuration: Duration(milliseconds: 500),
                                                          type: PageTransitionType.bottomToTop,
                                                          child: PlaceOrderScreen(total:double.parse(price),data: jsonData),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xff4cb050)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                        child: Text("Buy Now",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        data.alignment=Alignment.topLeft;
                                                        data.iscollapsage=true;
                                                        Timer(Duration(milliseconds: 800),(){
                                                          data.image_expand=false;
                                                        });
                                                        data.isexpanded=false;
                                                        data.imagesizeheight=100;
                                                        data.imagesizewidth=100;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xffcccccc)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                                                        child: Text("View Less",style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                      ).toList(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 15),
                child: Align(alignment: Alignment.topLeft,child: InkWell(onTap:(){Navigator.pop(context);},child: Image.asset("images/left-arrow.png",height: 35,width: 35,))),
              ),
              Stack(
                  children:[
                    Padding(
                      padding: const EdgeInsets.only(right: 15,top: 15),
                      child: Align(alignment: Alignment.topRight,child: InkWell(onTap:(){
                        Navigator.push(
                          context,
                          PageTransition(
                            childCurrent: ShopProductListScreen(),
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
                    Padding(
                        padding: const EdgeInsets.only(top: 32,right: 24),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(LoadData.total_cart_items??"",style: TextStyle(fontSize: 14,color: Color(0xffffffff),fontWeight: FontWeight.w600),),
                        )
                    ),
                  ]
              ),
              Visibility(
                visible: imageview,
                child: InkWell(
                  onTap: (){
                    setState(() {
                      imageview=false;
                      imagepath="";
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    child: PinchZoomImage(
                      image:Center(
                        child: Image.network(
                            imagepath
                        ),
                      ),
                      //zoomedBackgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}