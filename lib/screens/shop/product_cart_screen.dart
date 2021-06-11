import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellon_partner_app/data/database_helper.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/cart_list.dart';
import 'package:wellon_partner_app/models/category_list.dart';
import 'package:wellon_partner_app/models/categoryproduct_list.dart';
import 'package:wellon_partner_app/models/pass_product_data.dart';
import 'package:wellon_partner_app/models/product_cart_list.dart';
import 'package:wellon_partner_app/screens/shop/place_order_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_list_screen.dart';
import 'package:wellon_partner_app/screens/shop/shop_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import '../../sizeconfig.dart';

class ProductCartScreen extends StatefulWidget {
  final double size;
  ProductCartScreen({this.size});
  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> with TickerProviderStateMixin{
  BuildContext _ctx;
  int counter = 0,cartproductcount=0;
  double total=0,gst=0,gstcount=0.0;
  double width,height=80,imagesizeheight=100,imagesizewidth=100;
  AlignmentGeometry _alignment = Alignment.centerLeft;
  bool _isLoading = false,_isexpanded = false,_iscollaps = true,_movetext=false,visiblebottomsheet=true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  NetworkUtil _netUtil = new NetworkUtil();
  String _otpcode;
  SharedPreferences prefs;
  Future<List<CartList>> productcartListdata;
  Future<List<CartList>> productcartListfilterData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  final CarouselController _controller = CarouselController();
  var db = new DatabaseHelper();
  List<ItemData> selectedlistData=new List<ItemData>();

  bool isOffline = false;
  final rows = <Widget>[];
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
    _gstsummery();
    width=widget.size;
  }

  startTime() async {
    var _duration = new Duration(microseconds: 100);
    return new Timer(_duration, increase);
  }
  void increase(){
    setState(() {
      height=350;
      width=MediaQuery.of(context).size.width/100*100;
    });
  }
  startTime1() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, increase1);
  }
  void increase1(){
    setState(() {
      //height=350;
    });
  }
  _loadPref() async {
    prefs= await SharedPreferences.getInstance();
    setState(() {
      productcartListdata = _getCategoryData();
      productcartListfilterData=productcartListdata;
    });
  }
  Future<List<CartList>> _getCategoryData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_CART_LIST,body: {
      "provider_id":prefs.getString("provider_id")
    }).then((dynamic res)
    {
      if(res["cartlist"].toString()=="[]")
      {
        return null;
      }
      _loadCartData();
      for(var data in res["cartlist"])
      {
        cartproductcount+=1;
      }
      final items = res["cartlist"].cast<Map<String, dynamic>>();
      //print(items);
      List<CartList> listofusers = items.map<CartList>((json) {
        return CartList.fromJson(json);
      }).toList();
      List<CartList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }
  _gstsummery() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("hii");
    return _netUtil.post(RestDatasource.GET_CART_LIST,body: {
      "provider_id":prefs.getString("provider_id")
    }).then((dynamic res)
    {
      print(res);
      if(res["cartlist"].toString()=="[]")
      {
        return null;
      }
      rows.clear();
      rows.add(Center(child: Text("Details Summary",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)));
      rows.add(Divider());
      for(var data in res["cartlist"])
      {
        int gst=int.parse(data["gstrate"]);
        double gsthalf=int.parse(data["gstrate"])/2;
        var cgst=(double.parse(data["gst_price"])/2).toString();
        var sgst=(double.parse(data["gst_price"])/2).toString();
        var igst=data["gst_price"].toString();
        double totalgst=(double.parse(data["gst_price"])*int.parse(data["quantity"]));
        var maintotal=(double.parse(data["invoice_price"])*int.parse(data["quantity"])).toString();

        rows.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Text("ProductName",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,color:Colors.green,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("Product Price",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("CGST ($gsthalf%)",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("SGST ($gsthalf%)",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  //Text("IGST ($gst%)",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  Text("Actual Price",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("Total GST",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text("Total Amount",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                ],),
                SizedBox(width: 20,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Text(StringUtils.capitalize(data["productname"]),textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Text("₹"+data["product_price"],textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      Text("₹"+cgst,textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      Text("₹"+sgst,textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      //Text(igst,textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      Text("₹${data["invoice_price"]}",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      Text("$cgst + $sgst * ${data["quantity"]} = ₹${totalgst.toStringAsFixed(2)}",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      Text("₹${data["invoice_price"]} * ${data["quantity"]} = ₹$maintotal",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
            Divider()
          ],
        ));
      }
    });
  }
  _popgstsummary(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter setState) {
              return Dialog(
                backgroundColor: Colors.white,
                child:SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: rows,
                  ),
                )
              );
            },
          );
        }

    );
  }
  Future<List<CartList>> _refresh1() async
  {
    int count = await db.getCountCart();
    setState(() {
      cartproductcount=count;
      productcartListdata = _getCategoryData();
      productcartListfilterData=productcartListdata;
    });
  }
  _loadCartData() {
    setState(() {
      selectedlistData.clear();
      total=0;
      gst=0;
      if(productcartListdata.toString().length != 0) {
        productcartListdata.then((value) {
          value.forEach((element) {
            ItemData item = new ItemData();
            item.cproduct_id = element.cproduct_id;
            item.quantity = element.qty.toString();
            item.price = (double.parse(element.invoice_price=="null"?"0.00":element.invoice_price)*element.qty).toString();
            selectedlistData.add(item);
          });
        });
      }
    });
    productcartListdata.then((value) => {
      value.forEach((element) {
        total=total+double.parse(element.invoice_price=="null"?"0.00":element.invoice_price)*element.qty;
        gst=gst+double.parse(element.gst_price=="null"?"0.00":element.gst_price)*element.qty;
        gstcount=total-gst;
        //print(total);
        setState(() {
        });
      })
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }
  // Future<List<CategoryProductList>> _getCategoryData() async
  // {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   return _netUtil.post(RestDatasource.GET_CATEGORY_PRODUCT,body: {
  //     "category_id":"1"
  //   }).then((dynamic res)
  //   {
  //     print(res);
  //     if(res.toString()=="[]")
  //     {
  //       return null;
  //     }
  //     final items = res.cast<Map<String, dynamic>>();
  //     print(items);
  //     List<CategoryProductList> listofusers = items.map<CategoryProductList>((json) {
  //       return CategoryProductList.fromJson(json);
  //     }).toList();
  //     List<CategoryProductList> revdata = listofusers.reversed.toList();
  //     return revdata;
  //   });
  // }
  // Future<List<CategoryProductList>> _refresh1() async
  // {
  //   setState(() {
  //     productcartListdata=db.getcart();
  //   });
  // }
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
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "https://www.waterpurifieronline.com/", androidToolbarColor: Colors.lightGreenAccent);
  }

  @override
  Widget build(BuildContext context) {
    startTime();
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            body:
            Stack(
              children: [
                AnimatedSize(duration:Duration(milliseconds: 1000),vsync:this,curve: Curves.easeIn,child: Container(width:width,child: Image.asset("images/shoppingbg.png",height: double.infinity,fit: BoxFit.fill,))),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text("Shopping Cart",style: TextStyle(fontSize: 22,color: Color(0xfffafafa),fontWeight: FontWeight.w600),),
                    )
                ),
                RefreshIndicator(
                  key: _refreshIndicatorKey1,
                  color: Colors.black,
                  onRefresh: _refresh1,
                  child: FutureBuilder<List<CartList>>(
                    future: productcartListdata,
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
                          child: Text("No Data Available!",style: TextStyle(color: Colors.white),),
                        );
                      }
                      return ListView(
                        padding: EdgeInsets.only(top: 60,bottom: 150),
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
                                  padding: const EdgeInsets.only(left: 20,top: 0,bottom: 20),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10,top: 10),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: ()async{
                                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                                              _netUtil.post(RestDatasource.ADD_TO_CARTLIST_DELETE,body: {
                                                "provider_id":prefs.getString("provider_id"),
                                                "cproduct_id":data.cproduct_id,
                                              }).then((dynamic res)
                                              {
                                                //print(res);
                                                if(res["status"]=="Deleted")
                                                {
                                                  setState(() {
                                                    _isLoading=false;
                                                  });
                                                  _refresh1();
                                                  _gstsummery();
                                                  Fluttertoast.showToast(msg: "Successfull Deleted",textColor: Colors.green,backgroundColor: Colors.white);
                                                }
                                                else
                                                {
                                                  setState(() {
                                                    _isLoading=false;
                                                  });
                                                  Fluttertoast.showToast(msg: "Try Again",textColor: Colors.red,backgroundColor: Colors.white);
                                                }
                                              });
                                              //db.deleteCartSingle(data.TableId);
                                            },
                                            child: SizedBox.fromSize(
                                              size: Size(30, 30),// button width and height
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [//background color of box
                                                    BoxShadow(
                                                      color: Color(0xffcccccc),
                                                      blurRadius: 15.0, // soften the shadow
                                                      spreadRadius: 0.0, //extend the shadow
                                                    )
                                                  ],
                                                ),
                                                child: ClipOval(
                                                  child: Material(
                                                    color: Colors.redAccent,
                                                    // button color
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 3),
                                                          child: Container(child: Icon(Icons.close,size: 25,color: Color(0xfffafafa))),
                                                        )
                                                        // (data.productimage!=null)?Image.network(RestDatasource. BASE_URL + "spprofile/" + data.productimage, width: 90, height: 90,fit: BoxFit.fitWidth,):
                                                        // Image.asset("images/profile_img.png", width: 90, height: 90,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 10,top: 10),
                                      //   child: Align(alignment: Alignment.topRight,child: Image.asset("images/close.png",fit: BoxFit.fill,height: 50,width: 50,)),
                                      // ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Image.network(RestDatasource.BASE_URL+"pimg1/"+data.image1??"16110442553409.png",width: 100,)
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 110,top: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data.productname!=null?data.productname:"",maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Text("500.00",style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                //SizedBox(width: 10,),
                                                Text(data.invoice_price??"",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                SizedBox(width: 15,),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text("₹${data.gst_price.toString()}(${data.gstrate.toString()}%)",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                    Text("${data.incl_excl_gst.toString()} GST",style: TextStyle(fontSize: 16,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                                //SizedBox(width: 10,),
                                                //Text("(10% off)",style: TextStyle(fontSize: 16,color: Color(0xff4cb050),fontWeight: FontWeight.w600),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 35,width: 120,
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
                                                    child: InkWell(onTap:() async{
                                                      setState(() {
                                                        if(data.qty.toString()!=data.minmum_qua)
                                                        {
                                                          data.qty=data.qty-int.parse(data.minmum_qua);
                                                          setState(() {
                                                            total=total-double.parse(data.price)*int.parse(data.minmum_qua);
                                                            gst=gst-double.parse(data.gst_price=="null"?"0.00":data.gst_price)*int.parse(data.minmum_qua);
                                                          });
                                                          _netUtil.post(RestDatasource.UPDATE_CART,body: {
                                                            "provider_id":prefs.getString("provider_id"),
                                                            "cproduct_id":data.cproduct_id,
                                                            "quantity":data.qty.toString(),
                                                          }).then((dynamic res)
                                                          {
                                                            if(res["status"]=="Quantity Updated")
                                                            {
                                                              _gstsummery();
                                                            }
                                                          });
                                                        }
                                                      });
                                                    },child: Image.asset("images/minus.png",fit: BoxFit.fill,height: 30,width: 30,)),
                                                  ),
                                                  Text(data.qty.toString(),style: TextStyle(fontSize: 18,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: InkWell(onTap:(){
                                                      setState(() {
                                                        data.qty=data.qty+int.parse(data.minmum_qua);
                                                        setState(() {
                                                          total=total+double.parse(data.price)*int.parse(data.minmum_qua);
                                                          gst=gst+double.parse(data.gst_price=="null"?"0.00":data.gst_price)*int.parse(data.minmum_qua);
                                                        });
                                                        _netUtil.post(RestDatasource.UPDATE_CART,body: {
                                                          "provider_id":prefs.getString("provider_id"),
                                                          "cproduct_id":data.cproduct_id,
                                                          "quantity":data.qty.toString()
                                                        }).then((dynamic res)
                                                        {
                                                          if(res["status"]=="Quantity Updated")
                                                          {
                                                            _gstsummery();
                                                          }
                                                        });
                                                      });
                                                    },child: Image.asset("images/plus.png",fit: BoxFit.fill,height: 30,width: 30,)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                          ],
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: (){
                      total!=0.0?
                      showModalBottomSheet(
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              ),
                              height: 360,
                              //color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Shoping Cart Summary",style: TextStyle(color: Color(0xff333333),fontSize: 20)),
                                          Icon(Icons.keyboard_arrow_down,size: 30,color: Colors.green,)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Numbers of items",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                        Text("$cartproductcount",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Sub Total",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                        Text((total-gst).toString(),style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("GST",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                        Row(
                                          children: [
                                            IconButton(icon: Icon(Icons.info_outline,), onPressed: () { _popgstsummary(context); },),
                                            SizedBox(width: 10,),
                                            Text("+ ₹${gstcount.toStringAsFixed(2)}",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child: Divider(height: 1,color: Colors.black,thickness: 1.5,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                        Text("₹$total",style: TextStyle(color: Color(0xff4cb050),fontSize: 20,fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("",style: TextStyle(color: Color(0xff333333),fontSize: 18)),
                                        InkWell(
                                          onTap: (){
                                            var jsonData;
                                            jsonData = jsonEncode(selectedlistData.map((e) => e.toMap()).toList());
                                            selectedlistData.isNotEmpty?
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                childCurrent: ProductCartScreen(),
                                                duration: Duration(milliseconds: 500),
                                                reverseDuration: Duration(milliseconds: 500),
                                                type: PageTransitionType.bottomToTop,
                                                child: PlaceOrderScreen(total:total,data: jsonData),
                                              ),
                                            ):{};
                                          },
                                          child: Container(
                                            height: 50,width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Color(0xff4cb050),
                                              boxShadow: [//background color of box
                                                BoxShadow(
                                                  color: Color(0xffcccccc),
                                                  blurRadius: 10.0, // soften the shadow
                                                  spreadRadius: 0.0, //extend the shadow
                                                )
                                              ],
                                            ),
                                            child: Center(child: Text("Check Out",style: TextStyle(fontSize: 18,color: Color(0xfffafafa),fontWeight: FontWeight.w600),)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }):{};
                      startTime1();
                    },
                    child: Container(
                      height:110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Shoping Cart Summary",style: TextStyle(color: Color(0xff333333),fontSize: 20)),
                                Icon(Icons.keyboard_arrow_up,size: 30,color: Colors.green,)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0,right: 0,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total : $total",style: TextStyle(color: Color(0xff333333),fontSize: 20)),
                                  InkWell(
                                    onTap: (){
                                      var jsonData;
                                      jsonData = jsonEncode(selectedlistData.map((e) => e.toMap()).toList());
                                      selectedlistData.isNotEmpty?
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          childCurrent: ProductCartScreen(),
                                          duration: Duration(milliseconds: 500),
                                          reverseDuration: Duration(milliseconds: 500),
                                          type: PageTransitionType.bottomToTop,
                                          child: PlaceOrderScreen(total:total,data: jsonData,),
                                        ),
                                      ):{
                                        Fluttertoast.showToast(msg: "Add product in cart",backgroundColor: Colors.red,gravity: ToastGravity.CENTER)
                                      };
                                    },
                                    child: Container(
                                      height: 50,width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xff4cb050),
                                        boxShadow: [//background color of box
                                          BoxShadow(
                                            color: Color(0xffcccccc),
                                            blurRadius: 10.0, // soften the shadow
                                            spreadRadius: 0.0, //extend the shadow
                                          )
                                        ],
                                      ),
                                      child: Center(child: Text("Check Out",style: TextStyle(fontSize: 18,color: Color(0xfffafafa),fontWeight: FontWeight.w600),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                // Stack(
                //     children:[
                //       Padding(
                //         padding: const EdgeInsets.only(right: 15,top: 15),
                //         child: Align(alignment: Alignment.topRight,child: Image.asset("images/interest.png",height: 35,width: 35,color: Colors.white,)),
                //       ),
                //       Padding(
                //           padding: const EdgeInsets.only(top: 31,right: 24),
                //           child: Align(
                //             alignment: Alignment.topRight,
                //             child: Text("3",style: TextStyle(fontSize: 14,color: Color(0xff333333),fontWeight: FontWeight.w600),),
                //           )
                //       ),
                //     ]
                // ),
              ],
            )
        ),
      ),
    );
  }
}