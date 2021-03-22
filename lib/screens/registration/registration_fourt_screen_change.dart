import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class UserRegistrationFourtScreenChange extends StatefulWidget {
  @override
  _UserRegistrationFourtScreenChangeState createState() => _UserRegistrationFourtScreenChangeState();
}

class _UserRegistrationFourtScreenChangeState extends State<UserRegistrationFourtScreenChange> {
  BuildContext _ctx;
  bool _isLoading = false;
  bool _isdataLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool monVal = false,monVal1 = false,monVal2 = false;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;

  TextEditingController _inst_ro_do_normal_namecontroller=new TextEditingController();
  TextEditingController _inst_alkaline_normal_namecontroller=new TextEditingController();
  TextEditingController _service_ro_do_normal_namecontroller=new TextEditingController();
  TextEditingController _service_alkaline_normal_namecontroller=new TextEditingController();
  TextEditingController _about_namecontroller=new TextEditingController();

  String mobileNo;
  String _inst_ro_do_instance,_inst_ro_do_normal;
  String _inst_ro_co_instance,_inst_ro_co_normal;
  String _inst_alkaline_instance,_inst_alkaline_normal;
  String _service_ro_do_instance,_service_ro_do_normal;
  String _service_ro_co_instance,_service_ro_co_normal;
  String _service_alkaline_instance,_service_alkaline_normal;
  String _about;

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    mobileNo= prefs.getString("mobile_numbers") ?? '';
    _netUtil.post(RestDatasource.GET_REGISTER_DATA, body: {
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print(res);
      setState(() {
        _inst_ro_do_normal=res[0]["inst_ro_do_normal"]=="0.00"?null:res[0]["inst_ro_do_normal"];
        _inst_alkaline_normal=res[0]["inst_alkaline_normal"]=="0.00"?null:res[0]["inst_alkaline_normal"];
        _service_ro_do_normal=res[0]["service_ro_do_normal"]=="0.00"?null:res[0]["service_ro_do_normal"];
        _service_alkaline_normal=res[0]["service_alkaline_normal"]=="0.00"?null:res[0]["service_alkaline_normal"];
        _about=res[0]["about"];
        _isdataLoading=false;

        _inst_ro_do_normal_namecontroller.text=_inst_ro_do_normal;
        _inst_alkaline_normal_namecontroller.text=_inst_alkaline_normal;
        _service_ro_do_normal_namecontroller.text=_service_ro_do_normal;
        _service_alkaline_normal_namecontroller.text=_service_alkaline_normal;
        _about_namecontroller.text=_about;
      });
    });
  }
//  String _amc,_water_purifier,_alkaline_wp,_about;


//  bool sp_type_instance = false;
//  bool sp_type_normal = false;
//  bool sp_type_amc = false;
//  bool sp_type_water_purifier = false;
//  bool sp_type_alkaline_water_purifier = false;

//  TextEditingController _instance_namecontroller=new TextEditingController();
//  TextEditingController _normal_namecontroller=new TextEditingController();
//  TextEditingController _amc_namecontroller=new TextEditingController();
//  TextEditingController _water_purifier_namecontroller=new TextEditingController();
//  TextEditingController _alkaline_wp_namecontroller=new TextEditingController();
//  TextEditingController _about_namecontroller=new TextEditingController();

//  _loadPref() async {
//    setState(() {
//
//      _netUtil.post(RestDatasource.GET_SP_SERVICE, body: {
//        'mobile_numbers' : mobileNo,
//
//      }).then((dynamic res) async {
//        setState(() {
////          print(res[0]["tech_price_instance"]);
//          _instance_namecontroller.text=res[0]["tech_price_instance"];
//          _normal_namecontroller.text=res[0]["tech_price_normal"];
//          _amc_namecontroller.text=res[0]["tech_price_amc"];
//          _water_purifier_namecontroller.text=res[0]["tech_price_water_purifier"];
//          _alkaline_wp_namecontroller.text=res[0]["tech_price_alkaline_wp"];
//          _about_namecontroller.text=res[0]["about"];
//
//          _isdataLoading=false;
//
//          sp_type_instance=(res[0]["sp_type_instance"]=="Y")?true:false;
//          sp_type_normal=(res[0]["sp_type_instance"]=="Y")?true:false;
//          sp_type_amc=(res[0]["sp_type_instance"]=="Y")?true:false;
//          sp_type_water_purifier=(res[0]["sp_type_instance"]=="Y")?true:false;
//          sp_type_alkaline_water_purifier=(res[0]["sp_type_instance"]=="Y")?true:false;
//
//
//
//        });
//      });
//
//    });
//  }



  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
    _loadPref();
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


  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      mobileNo = arguments['mobileNo'];
      //mobileNo = "8460273125";
      print(mobileNo);
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text("Work Infomation",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
          ),
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: new Form(
            key: formKey,
              child: new Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,20,0,0),
                    child: Text("About Your Self",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextFormField(
                    controller: _about_namecontroller,
                    maxLines: 8,
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w600),
                    onSaved: (val) => _about = val,
//                    validator: (val){
//                      if(val.length == 0)
//                        return "Name must be greater than 3";
//                      else
//                        return null;
//                    },
                  validator: (val){
                        if(val.length == 0)
                        return "Enter About";
                        else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.lato(color: Colors.lightGreen.shade500),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              width: 2, color: Colors.lightGreen.shade500
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide()
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,15,0,15),
                    child: Text("Select Work type.",style: GoogleFonts.lato(color: Colors.green,fontSize: 26,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Card(
                    elevation: 3.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    child: Container(
                      child: ListTile(

                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height: 10
                            ),
                            Text(
                              "Installation",
                              style: GoogleFonts.lato(color: Colors.green,fontSize: 22,letterSpacing: 1,fontWeight: FontWeight.w700),
                            ),
                            _divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 12,top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Water Purifier",
                                  style: GoogleFonts.lato(color: Colors.black,fontSize: 16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        subtitle: Container(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[

                                      // Flexible(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                      //     child: TextFormField(
                                      //       obscureText: false,
                                      //       keyboardType: TextInputType.number,
                                      //       style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //       onSaved: (val) => _inst_ro_do_instance = val,
                                      //       decoration: InputDecoration(
                                      //         labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //         filled: true,
                                      //         focusedBorder: OutlineInputBorder(
                                      //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //             borderSide: BorderSide(
                                      //                 width: 2, color: Colors.lightGreen.shade500
                                      //             )
                                      //         ),
                                      //         border: OutlineInputBorder(
                                      //           // width: 0.0 produces a thin "hairline" border
                                      //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //             borderSide: BorderSide(color: Colors.white24)
                                      //           //borderSide: const BorderSide(),
                                      //         ),
                                      //           labelText: 'Instant Price'
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                          child: TextFormField(
                                            controller: _inst_ro_do_normal_namecontroller,
                                            obscureText: false,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                            onSaved: (val) => _inst_ro_do_normal = val,
                                            validator: (val){
                                              if(val.length == 0)
                                                return "Enter Regular Price";
                                              else
                                                return null;
                                            },
                                            decoration: InputDecoration(
                                              labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  borderSide: BorderSide(
                                                    width: 2, color: Colors.lightGreen.shade500,
                                                  )
                                              ),
                                              border: OutlineInputBorder(
                                                // width: 0.0 produces a thin "hairline" border
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  borderSide: BorderSide(color: Colors.white24)
                                                //borderSide: const BorderSide(),
                                              ),
                                                labelText: 'Regular Price'
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 5
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Alkine Water Ionizers",
                                    style: GoogleFonts.lato(color: Colors.black,fontSize: 16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 5
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      // Flexible(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                      //     child: TextFormField(
                                      //       obscureText: false,
                                      //       keyboardType: TextInputType.number,
                                      //       onSaved: (val) => _inst_alkaline_instance = val,
                                      //       style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //       decoration: InputDecoration(
                                      //           labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //           filled: true,
                                      //           focusedBorder: OutlineInputBorder(
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(
                                      //                   width: 2, color: Colors.lightGreen.shade500
                                      //               )
                                      //           ),
                                      //           border: OutlineInputBorder(
                                      //             // width: 0.0 produces a thin "hairline" border
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(color: Colors.white24)
                                      //             //borderSide: const BorderSide(),
                                      //           ),
                                      //           labelText: 'Instant Price'
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                          child: TextFormField(
                                            controller: _inst_alkaline_normal_namecontroller,
                                            obscureText: false,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                            onSaved: (val) => _inst_alkaline_normal = val,
                                            validator: (val){
                                              if(val.length == 0)
                                                return "Enter Regular Price";
                                              else
                                                return null;
                                            },
                                            decoration: InputDecoration(
                                                labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                filled: true,
                                                fillColor: Color(0xfff3f3f4),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                      width: 2, color: Colors.lightGreen.shade500,
                                                    )
                                                ),
                                                border: OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(color: Colors.white24)
                                                  //borderSide: const BorderSide(),
                                                ),
                                                labelText: 'Regular Price'
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 15
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Card(
                    elevation: 3.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    child: Container(
                      child: ListTile(

                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text(
                              "Service",
                              style: GoogleFonts.lato(color: Colors.green,fontSize: 22,letterSpacing: 1,fontWeight: FontWeight.w700),
                            ),
                            _divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 12,top: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Water Purifier",
                                  style: GoogleFonts.lato(color: Colors.black,fontSize: 16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 5
                            ),
                          ],
                        ),
                        subtitle: Container(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      // Flexible(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                      //     child: TextFormField(
                                      //       obscureText: false,
                                      //       keyboardType: TextInputType.number,
                                      //       style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //       onSaved: (val) => _service_ro_do_instance = val,
                                      //       decoration: InputDecoration(
                                      //           labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //           filled: true,
                                      //           focusedBorder: OutlineInputBorder(
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(
                                      //                   width: 2, color: Colors.lightGreen.shade500
                                      //               )
                                      //           ),
                                      //           border: OutlineInputBorder(
                                      //             // width: 0.0 produces a thin "hairline" border
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(color: Colors.white24)
                                      //             //borderSide: const BorderSide(),
                                      //           ),
                                      //           labelText: 'Instant Price'
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                          child: TextFormField(
                                            controller: _service_ro_do_normal_namecontroller,
                                            obscureText: false,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                            onSaved: (val) => _service_ro_do_normal = val,
                                            validator: (val){
                                              if(val.length == 0)
                                                return "Enter Regular Price";
                                              else
                                                return null;
                                            },
                                            decoration: InputDecoration(
                                                labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                filled: true,
                                                fillColor: Color(0xfff3f3f4),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                      width: 2, color: Colors.lightGreen.shade500,
                                                    )
                                                ),
                                                border: OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(color: Colors.white24)
                                                  //borderSide: const BorderSide(),
                                                ),
                                                labelText: 'Regular Price'
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 5
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Alkine Water Ionizers",
                                    style: GoogleFonts.lato(color: Colors.black,fontSize: 16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      // Flexible(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                      //     child: TextFormField(
                                      //       obscureText: false,
                                      //       keyboardType: TextInputType.number,
                                      //       style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //       onSaved: (val) => _service_alkaline_instance = val,
                                      //       validator: (val){
                                      //         if(val.length == 0)
                                      //           return "Enter Regular Price";
                                      //         else
                                      //           return null;
                                      //       },
                                      //       decoration: InputDecoration(
                                      //           labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                      //           filled: true,
                                      //           focusedBorder: OutlineInputBorder(
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(
                                      //                   width: 2, color: Colors.lightGreen.shade500
                                      //               )
                                      //           ),
                                      //           border: OutlineInputBorder(
                                      //             // width: 0.0 produces a thin "hairline" border
                                      //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //               borderSide: BorderSide(color: Colors.white24)
                                      //             //borderSide: const BorderSide(),
                                      //           ),
                                      //           labelText: 'Instant Price'
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                          child: TextFormField(
                                            controller: _service_alkaline_normal_namecontroller,
                                            obscureText: false,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                            onSaved: (val) => _service_alkaline_normal = val,
                                            validator: (val){
                                              if(val.length == 0)
                                                return "Enter Regular Price";
                                              else
                                                return null;
                                            },
                                            decoration: InputDecoration(
                                                labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                filled: true,
                                                fillColor: Color(0xfff3f3f4),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                      width: 2, color: Colors.lightGreen.shade500,
                                                    )
                                                ),
                                                border: OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(color: Colors.white24)
                                                  //borderSide: const BorderSide(),
                                                ),
                                                labelText: 'Regular Price'
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 15
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
//
                          final form = formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            NetworkUtil _netUtil = new NetworkUtil();
                            _netUtil.post(
                                RestDatasource.UPDATE_SP_SERVICE, body: {
                              'mobile_numbers' : mobileNo,
                              "inst_ro_do_instance": "0",
                              "inst_ro_do_normal": _inst_ro_do_normal,
                              "inst_ro_co_instance": "0",
                              "inst_ro_co_normal": "0",
                              "inst_alkaline_instance": "0",
                              "inst_alkaline_normal": _inst_alkaline_normal,
                              "service_ro_do_instance": "0",
                              "service_ro_do_normal": _service_ro_do_normal,
                              "service_ro_co_instance": "0",
                              "service_ro_co_normal": "0",
                              "service_alkaline_instance": "0",
                              "service_alkaline_normal": _service_alkaline_normal,
                              "about": _about,
                            }).then((dynamic res) async {
                                if (res["status"] == "yes") {
                                  formKey.currentState.reset();
                                  //FlashHelper.successBar(context, message: "Successfull Registration");
                                  setState(() => _isLoading = false);
                                  Navigator.of(_ctx).pushReplacementNamed("/thankyou");
                                }
                                else {
                                  FlashHelper.errorBar(context, message: "Error");
                                  setState(() => _isLoading = false);
                                }
                            });
                          }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                            border: Border.all(
//                              color: Colors.black,
//                            ),
                            color: Colors.green,
                          ),
                          child: Text("Next", style: GoogleFonts.lato(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    ),
          )
      );
    }
  }
}