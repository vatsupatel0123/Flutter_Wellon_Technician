import 'dart:async';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/services.dart';
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
import 'package:wellon_partner_app/screens/bottom_navigation/navigation_bar_controller.dart';
import 'package:wellon_partner_app/screens/contactus/contactus.dart';
import 'package:wellon_partner_app/screens/more/profile/myprofile_screen.dart';
import 'package:wellon_partner_app/screens/more/refer_friend/refer_friend_screen.dart';
import 'package:wellon_partner_app/screens/more/support_and_care/support_and_care_screen.dart';
import 'package:wellon_partner_app/screens/more/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/bank_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/myorder/myorder_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class MYReasonsScreen extends StatefulWidget {
  final String sporder_id,screen,productdata;
  MYReasonsScreen({this.sporder_id,this.screen,this.productdata});
  @override
  _MYReasonsScreenState createState() => _MYReasonsScreenState();
}


class _MYReasonsScreenState extends State<MYReasonsScreen>{
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
  int _radioValue1=1;
  Future<List<MyorderList>> categoryproductListdata;
  String cancelreasons1="Oreder Created by Mistake.",
  cancelreasons2="Product is being delivered to a wrong address(Customer’s mistake)",
  cancelreasons3="Product is not required anymore.",
  cancelreasons4="Expected delivery date has changed and the product is arriving at a later date.",
  cancelreasons5="Bad review from friends/relatives after ordering the product.",
  returnreasons1="Incorrect Product or Size Ordered",
  returnreasons2="Product Does Not Match Description on Website or in Catalog",
  returnreasons3="Product Did Not Meet Customers Expectations",
  returnreasons4="Company Shipped Wrong Product or Size",
  returnreasons5="The product was damaged or defective";

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
          title: widget.screen=="Cancel"?Text("Cancel Order",style: TextStyle(color: Colors.white),):Text("Return Order",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
        ),
        body: widget.screen=="Cancel"?SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 40,bottom: 10),
                  child: Text('Choose Cancel Reasons', style: GoogleFonts.lato(color: Colors.green,fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 0,bottom: 10),
                  child: Divider(color: Colors.black,height: 2,),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        child: Text(cancelreasons1, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),)),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(cancelreasons2, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 3,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(cancelreasons3, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 4,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(cancelreasons4, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 5,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(cancelreasons5, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 7,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          //print(_radioValue1);
                          _othertextbox=true;
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text('Others', style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                Visibility(
                  visible: _othertextbox,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      onSaved: (val) {
                        setState(() {
                          _other = val;
                        });
                      },
                      validator: (val){
                        if(_othertextbox) {
                          if (val.length >= 3) {
                            return null;
                          }
                          else {
                            return "Please Enter Other Reason.";
                          }
                        }
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.green),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 2, color: Colors.lightGreen.shade500
                            )
                        ),
                        border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.white)
                          //borderSide: const BorderSide(),
                        ),
                        hintText: 'Enter Other Reason.',
                      ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: InkWell(
                    onTap: () async{
                      final form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        var remark;
                        remark=_radioValue1==6?_other:_radioValue1==5?cancelreasons5:_radioValue1==4?cancelreasons4:_radioValue1==3?cancelreasons3:
                        _radioValue1==2?cancelreasons2:_radioValue1==1?cancelreasons1:"";
                        prefs = await SharedPreferences.getInstance();
                        setState(() {
                          _isLoading = true;
                        });
                        _netUtil.post(RestDatasource.MY_ORDER_CANCEL, body: {
                          "provider_id": prefs.getString("provider_id"),
                          "sporder_id": widget.sporder_id,
                          "remark":remark,
                        }).then((dynamic res) {
                          //print(res);
                          setState(() {
                            _isLoading = false;
                            Navigator.pushReplacement(context, PageTransition(child: BottomNavigationBarController(), type: PageTransitionType.bottomToTop));
                          });
                        });
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
          ),
        ):
        SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 40,bottom: 10),
                  child: Text('Choose Return Reasons', style: GoogleFonts.lato(color: Colors.green,fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 0,bottom: 10),
                  child: Divider(color: Colors.black,height: 2,),
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        child: Text(returnreasons1, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),)),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(returnreasons2, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 3,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(returnreasons3, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 4,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(returnreasons4, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 5,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          _othertextbox=false;
                          //print(_radioValue1);
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text(returnreasons5, style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Radio(
                      value: 6,
                      activeColor: Colors.green,
                      groupValue: _radioValue1,
                      onChanged: (value) {
                        setState(() {
                          _radioValue1 = value;
                          //print(_radioValue1);
                          _othertextbox=true;
                        }
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child :Text('Others', style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),)
                  ],
                ),
                Visibility(
                  visible: _othertextbox,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      onSaved: (val) {
                        setState(() {
                          _other = val;
                        });
                      },
                      validator: (val){
                        if(_othertextbox) {
                          if (val.length >= 3) {
                            return null;
                          }
                          else {
                            return "Please Enter Other Reason.";
                          }
                        }
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.green),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 2, color: Colors.lightGreen.shade500
                            )
                        ),
                        border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.white)
                          //borderSide: const BorderSide(),
                        ),
                        hintText: 'Enter Other Reason.',
                      ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: InkWell(
                    onTap: () async{
                      Navigator.push(context, PageTransition(child: BankDetailsScreen(), type: PageTransitionType.bottomToTop));
                      // final form = formKey.currentState;
                      // if (form.validate()) {
                      //   form.save();
                      //   prefs = await SharedPreferences.getInstance();
                      //   setState(() {
                      //     _isLoading = true;
                      //   });
                      //   _netUtil.post(RestDatasource.MY_ORDER_CANCEL, body: {
                      //     "provider_id": prefs.getString("provider_id"),
                      //     "sporder_id": widget.sporder_id
                      //   }).then((dynamic res) {
                      //     print(res);
                      //     setState(() {
                      //       _isLoading = false;
                      //     });
                      //   });
                      // }
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
          ),
        )
      );
    }
  }
}
