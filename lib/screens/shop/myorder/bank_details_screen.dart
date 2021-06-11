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
import 'package:wellon_partner_app/screens/shop/myorder/myorder_details_screen.dart';
import 'package:wellon_partner_app/screens/shop/product_cart_screen.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class BankDetailsScreen extends StatefulWidget {
  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}


class _BankDetailsScreenState extends State<BankDetailsScreen>{
  BuildContext _ctx;

  NetworkUtil _netUtil = new NetworkUtil();
  bool _isdataLoading = false,_othertextbox=false;

  String spfullname="",provider_id="0",profilephoto="",version="3.0",bankname;

  SharedPreferences prefs;
  bool is_active = false,resendMessageVisible = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode,_accountno,_reaccountno,_accountname,_ifsc;
  TextEditingController _accountno_controller=new TextEditingController();
  TextEditingController _reaccountno_controller=new TextEditingController();
  TextEditingController _accountname_controller=new TextEditingController();
  TextEditingController _ifsc_codecontroller=new TextEditingController();
  int _radioValue1=0;
  Future<List<MyorderList>> categoryproductListdata;
  List bankdata = List();
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
      prefs=await SharedPreferences.getInstance();
      _netUtil.post(RestDatasource.GET_BANK_NAME).then((dynamic res) {
        setState(() {
          bankdata=res;
        });
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
          body:
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40,left: 10,right: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        width: 1.5, color: Colors.green
                                    )
                                ),
                                border: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.white)
                                  //borderSide: const BorderSide(),
                                ),
                                labelStyle: GoogleFonts.lato(color: Colors.black,fontSize:18,fontWeight: FontWeight.bold),
                                labelText: 'Bankname'
                            ),
                            dropdownColor: Color(0xfff3f3f4),
                            items: bankdata.map((item) {
                              return new DropdownMenuItem(
                                child: Text(item['BankName'],style: TextStyle(fontWeight: FontWeight.bold),),
                                value: item['BankId'].toString(),
                              );
                            }).toList(),
                            // validator: (value){
                            //   if (value.length == 0)
                            //     return 'ગામ દાખલ કરો';
                            //   else
                            //     return null;
                            // },
                            onChanged: (newVal) {
                              setState(() {
                                bankname = newVal;
                              });
                            },
                            isExpanded: true,
                            value: bankname,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: TextFormField(
                      controller: _accountno_controller,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          _accountno = val;
                        });
                      },
                      validator: (val){
                        if(val.length!=0)
                        {
                          return null;
                        }
                        else
                        {
                          return "Please Enter Bank Account Number";
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold),
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
                        labelText: 'Enter Bank Account No.',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: TextFormField(
                      controller: _reaccountno_controller,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          _reaccountno = val;
                        });
                      },
                      validator: (val){
                        if(val.length!=0)
                        {
                          if(_accountno!=_reaccountno)
                          {
                            return "Account No and ReAccount No not match";
                          }
                          else
                          {
                            return null;
                          }
                        }
                        else
                        {
                          return "Please Enter Bank ReAccount Number";
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold),
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
                        labelText: 'Enter Bank ReAccount No.',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: TextFormField(
                      controller: _accountname_controller,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          _accountname = val;
                        });
                      },
                      validator: (val){
                        if(val.length>=3)
                        {
                          return null;
                        }
                        else
                        {
                          return "Please Enter Account Person Name";
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold),
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
                        labelText: 'Enter Account Person Name',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: TextFormField(
                      controller: _ifsc_codecontroller,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          _ifsc = val;
                        });
                      },
                      validator: (val){
                        Pattern pattern ="[A-Z]{4}0[A-Z0-9]{6}";
                        RegExp regex = new RegExp(pattern);
                        if(val.length<=0) {
                          if (!regex.hasMatch(val))
                            return 'Enter Valid IFSC Code';
                          else
                            return null;
                        }else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold),
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
                        labelText: 'Enter IFSC Code',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
                    child: InkWell(
                      onTap: () async{
                        // final form = formKey.currentState;
                        // form.save();
                        // if (form.validate()) {
                        // }
                        Navigator.pushReplacement(context, PageTransition(child: BottomNavigationBarController(), type: PageTransitionType.bottomToTop));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 13,bottom: 13),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)
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
