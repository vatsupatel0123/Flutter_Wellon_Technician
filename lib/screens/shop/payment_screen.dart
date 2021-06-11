import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/screens/shop/order_thankyou.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class PaymentScreen extends StatefulWidget {
  String orderid,amount;
  PaymentScreen(this.orderid,this.amount);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  String res;
  SharedPreferences prefs;

  WebViewController _webController;
  bool _loadingPayment = true,popup=false;
  @override

  initState() {
    super.initState();
    //print("setstate called");
    _loadprefs();
  }
  _loadprefs()async{
    prefs= await SharedPreferences.getInstance();
    setState(() {

    });
  }
  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }
  void _displayDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter setState) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10,bottom: 5),
                              child: Container(
                                child: Text("Transaction in process",
                                  style: GoogleFonts.lato(color:Colors.black,fontSize:20,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Text("Are you sure you want to cancel this Transaction?",
                                  style: GoogleFonts.lato(color:Colors.black,fontSize:14,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 500),
                                    type: PageTransitionType.bottomToTop,
                                    child: OrderThankYou(status: "failed",),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                alignment: Alignment.center,
                                child: Text("Cancel Transaction",
                                  style: GoogleFonts.lato(color:Colors.green,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
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
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                alignment: Alignment.center,
                                child: Text("Continue Payment",
                                  style: GoogleFonts.lato(color:Colors.blue,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: res==null?WillPopScope(
            onWillPop: (){
              _displayDialog(context);
            },
            child: Stack(
        children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webController = controller;
                  _webController.loadUrl(
                      "${RestDatasource.BASE_URL}paymentgatewaytest/${widget.orderid}/${widget.amount}");
                },
                onPageFinished: (page) {
                  if (page.contains("/webviewpaymentfailed")) {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 500),
                        type: PageTransitionType.bottomToTop,
                        child: OrderThankYou(status: "failed",),
                      ),
                    );
                  }
                  if (page.contains("/webviewThanksForOrder")) {
                    setState(() {
                      _netUtil.post(RestDatasource.CART_LIST_DELETE, body: {
                        "provider_id":prefs.getString("provider_id"),
                      }).then((dynamic res) async {
                        print(res);
                      });
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 500),
                          type: PageTransitionType.bottomToTop,
                          child: OrderThankYou(status: "thankyou",),
                        ),
                      );
                    });
                  }
                },
              ),
            ),
            Visibility(visible:popup,child: Center(child: Text("Pls Conformation"),)),
        ],
      ),
          ):Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "OOPS!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Payment was not successful, Please try again Later!",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                        color: Colors.black,
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
