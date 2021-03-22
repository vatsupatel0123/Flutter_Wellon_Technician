import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class UserRegistrationSecondScreenchange extends StatefulWidget {
  @override
  _UserRegistrationSecondScreenchangeState createState() => _UserRegistrationSecondScreenchangeState();
}

class _UserRegistrationSecondScreenchangeState extends State<UserRegistrationSecondScreenchange> {
  BuildContext _ctx;

  File _image = null,_vimage = null,_vbimage = null,_profile = null,_pancard=null,_gst=null;
  bool profile=false,aathar=false,visting=false,vistingbb=false,pancard=false,gst=false;
  NetworkUtil _netUtil = new NetworkUtil();

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String profile_photo="null",aadhar_photo="null",visit_card_front="null",visit_card_back="null",cover_photo="null",pancard_image="null",gst_certificate_photo="null";
  SharedPreferences prefs;
  String _username,_mobilenumber,_emailid,_address,_pincode;
  int _radioValue1=0;
  String mobileNo="",mobile_numbers;

  _loadphoto() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile_numbers= prefs.getString("mobile_numbers") ?? '';
      _netUtil.post(RestDatasource.GET_ALL_PHOTO, body: {
        "mobile_numbers":mobile_numbers,
      }).then((dynamic res) async {
        print(res);
        setState(() {
          profile_photo=res[0]["profile_photo"].toString();
          pancard_image=res[0]["pancard_image"].toString();
          aadhar_photo=res[0]["aadhar_photo"].toString();
          gst_certificate_photo=res[0]["gst_certificate_photo"].toString();
          visit_card_front=res[0]["visit_card_front"].toString();
          visit_card_back=res[0]["visit_card_back"].toString();
          cover_photo=res[0]["cover_photo"].toString();
          (profile_photo!="null")?profile=true:profile=false;
          (gst_certificate_photo!="null")?gst=true:gst=false;
          (aadhar_photo!="null")?aathar=true:aathar=false;
          (pancard_image!="null")?pancard=true:pancard=false;
          (visit_card_front!="null")?visting=true:visting=false;
          (visit_card_back!="null")?vistingbb=true:vistingbb=false;
        });
      });

    });
  }

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
    _loadphoto();
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


  //Profile IMG
  _imgFromCameraPro() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(
        RestDatasource.SEND_PROFILE_PHOTO, body: {
      "SPprofilepic": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web pro"+res["status"]);
      if (res["status"] == "yes") {
        profile=true;
      }
    });

    setState(() {
      _profile = image;
      profile=true;
    });
  }

  _imgFromGalleryPro() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(
        RestDatasource.SEND_PROFILE_PHOTO, body: {
      "SPprofilepic": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web pro"+res["status"]);
      if (res["status"] == "yes") {
        profile=true;
      }
    });

    setState(() {
      _profile = image;
      profile=true;
    });
  }

  void _showPickerProfile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGalleryPro();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameraPro();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //First IMG
  _imgFromCamera() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_AADHAR_PHOTO, body: {
      "aadharcardphoto": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Output"+res["status"]);
      if (res["status"] == "yes") {
        aathar=true;
      }
    });

    setState(() {
      _image = image;
      aathar=true;
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_AADHAR_PHOTO, body: {
      "aadharcardphoto": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Output"+res["status"]);
      if (res["status"] == "yes") {
        aathar=true;
      }
    });

    setState(() {
      _image = image;
      aathar=true;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  _imgFromCamerapan() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_PANCARD_PHOTO, body: {
      "pancardimage": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Pancard"+res["status"]);
      if (res["status"] == "yes") {
        pancard=true;
      }
    });

    setState(() {
      _pancard = image;
      pancard=true;
    });
  }

  _imgFromGallerypan() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_PANCARD_PHOTO, body: {
      "pancardimage": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Pancard"+res["status"]);
      if (res["status"] == "yes") {
        pancard=true;
      }
    });

    setState(() {
      _pancard = image;
      pancard=true;
    });
  }

  void _showPickerpancard(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallerypan();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamerapan();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCameragst() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_GST_PHOTO, body: {
      "gstcertificate": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web GST"+res["status"]);
      if (res["status"] == "yes") {
        gst=true;
      }
    });

    setState(() {
      _gst = image;
      gst=true;
    });
  }

  _imgFromGallerygst() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_GST_PHOTO, body: {
      "gstcertificate": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web GST"+res["status"]);
      if (res["status"] == "yes") {
        gst=true;
      }
    });

    setState(() {
      _gst = image;
      gst=true;
    });
  }

  void _showPickergst(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallerygst();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameragst();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //

  //First IMG
  _imgFromCameraVis() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_VISITING_FPHOTO, body: {
      "visitingcardfront": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web frant"+res["status"]);
      if (res["status"] == "yes") {
        visting=true;
      }
    });

    setState(() {
      _vimage = image;
      visting=true;
    });
  }

  _imgFromGalleryVis() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_VISITING_FPHOTO, body: {
      "visitingcardfront": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web frant"+res["status"]);
      if (res["status"] == "yes") {
        visting=true;
      }
    });

    setState(() {
      _vimage = image;
      visting=true;
    });
  }

  void _showPickerVIS(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGalleryVis();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameraVis();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //3RD IMG
  _imgFromCameraVB() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_VISITING_LPHOTO, body: {
      "visitingcardback": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Back"+res["status"]);
      if (res["status"] == "yes") {
        vistingbb=true;
      }
    });

    setState(() {
      _vbimage = image;
      vistingbb=true;
    });
  }

  _imgFromGalleryVB() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_VISITING_LPHOTO, body: {
      "visitingcardback": base64Image,
      'mobile_numbers' : mobileNo,
    }).then((dynamic res) async {
      print("Web Back"+res["status"]);
      if (res["status"] == "yes") {
        vistingbb=true;
      }
    });

    setState(() {
      _vbimage = image;
      vistingbb=true;
    });
  }

  void _showPickerVB(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGalleryVB();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameraVB();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      mobileNo = arguments['mobileNo'];
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text("Add Photo",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.white,
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10,10,0,0),
                                child: Text("Select Profile Photo",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            new Center(
                              child:new Padding(padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        color: Colors.green,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: SizedBox.fromSize(
                                      size: Size(150, 150), // button width and height
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.white,
                                          // button color

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              _profile != null
                                                  ? (
                                                  Image.file(
                                                    _profile,
                                                    fit: BoxFit.fitWidth,height: 150,width: 150,
                                                  ))
                                                  : (
                                                  (profile_photo!="null")?Image.network(RestDatasource. BASE_URL + "spprofile/" + profile_photo, width: 150, height: 150,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                (_profile != null || profile_photo!="null") ?
                                RaisedButton(
                                  onPressed: () {
                                    _showPickerProfile(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                  color: Colors.green.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),):
                                RaisedButton(
                                  onPressed: () {
                                    _showPickerProfile(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.camera_alt, color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                  color: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),),
                                SizedBox(
                                  width: 10,
                                ),
//                                 (profile == false) ?
//                                 RaisedButton(
//                                   onPressed: () {
//                                     final form = formKey.currentState;
//                                     if (form.validate()) {
//                                       form.save();
//
//                                     }
//                                   },
//                                   child: Row(
//                                     children: <Widget>[
//                                       Icon(Icons.file_upload, color: Colors.white),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       const Text('Upload', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                     ],
//                                   ),
//                                   color: Colors.blue.shade700,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),):
//                                 RaisedButton(
//                                   onPressed: () {
// //                                      _showPickerProfile(context);
//                                     FlashHelper.successBar(context, message: "Profile Image Already Uploaded");
//                                   },
//                                   child: Row(
//                                     children: <Widget>[
//                                       Icon(
//                                         Icons.check_circle,
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       const Text('Uploaded', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                     ],
//                                   ),
//                                   color: Colors.green.shade700,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,10,0,10),
                                  child: Text("Select Pan Card",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _pancard != null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.green
                                      ),
                                    ),
                                    child: (
                                        Image.file(
                                          _pancard,fit: BoxFit.fitWidth,height: 200,width: 360,
                                        )),
                                  )
                                      :(
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.green
                                          ),
                                        ),
                                        child: (pancard_image!="null")?Image.network(RestDatasource. BASE_URL + "pancardimages/" + pancard_image, width: 360, height: 200,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',)
                                      )
                                  ),

                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
//                                  new Image.network(RestDatasource. BASE_URL + "/Aadharcard" + aadhar_photo, width: 80, height: 80,)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_pancard != null || pancard_image!="null") ?
                                  RaisedButton(
                                    onPressed: () {
                                      _showPickerpancard(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),):RaisedButton(
                                    onPressed: () {
                                      _showPickerpancard(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,10,0,10),
                                  child: Text("Select Aadhar Card",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _image != null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.green
                                      ),
                                    ),
                                    child: (
                                        Image.file(
                                          _image,fit: BoxFit.fitWidth,height: 200,width: 360,
                                        )),
                                  )
                                      :(
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.green
                                            ),
                                          ),
                                          child: (aadhar_photo!="null")?Image.network(RestDatasource. BASE_URL + "Aadharcard/" + aadhar_photo, width: 360, height: 200,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',)
                                      )
                                  ),

                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
//                                  new Image.network(RestDatasource. BASE_URL + "/Aadharcard" + aadhar_photo, width: 80, height: 80,)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_image != null || aadhar_photo!="null") ?
                                  RaisedButton(
                                    onPressed: () {
                                      _showPicker(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),):RaisedButton(
                                    onPressed: () {
                                      _showPicker(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),),
                                  SizedBox(
                                    width: 10,
                                  ),
//                                   (aathar == false) ?
//                                   RaisedButton(
//                                     onPressed: () {
//
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(Icons.file_upload, color: Colors.white),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Upload', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.blue.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),):
//                                   RaisedButton(
//                                     onPressed: () {
// //                                      _showPickerProfile(context);
//                                       FlashHelper.successBar(context, message: "Aadhar Card Image Already Uploaded");
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Uploaded', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.green.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,10,0,10),
                                  child: Text("Select GST Certificate",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _gst != null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.green
                                      ),
                                    ),
                                    child: (
                                        Image.file(
                                          _gst,fit: BoxFit.fitWidth,height: 200,width: 360,
                                        )),
                                  )
                                      :(
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.green
                                            ),
                                          ),
                                          child: (gst_certificate_photo!="null")?Image.network(RestDatasource. BASE_URL + "gstcertificateimages/" + gst_certificate_photo, width: 360, height: 200,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',)
                                      )
                                  ),

                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
//                                  new Image.network(RestDatasource. BASE_URL + "/Aadharcard" + aadhar_photo, width: 80, height: 80,)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_gst != null || gst_certificate_photo!="null") ?
                                  RaisedButton(
                                    onPressed: () {
                                      _showPickergst(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),):RaisedButton(
                                    onPressed: () {
                                      _showPickergst(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),),
                                  SizedBox(
                                    width: 10,
                                  ),
//                                   (aathar == false) ?
//                                   RaisedButton(
//                                     onPressed: () {
//
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(Icons.file_upload, color: Colors.white),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Upload', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.blue.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),):
//                                   RaisedButton(
//                                     onPressed: () {
// //                                      _showPickerProfile(context);
//                                       FlashHelper.successBar(context, message: "Aadhar Card Image Already Uploaded");
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Uploaded', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.green.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,10,0,10),
                                  child: Text("Select Visiting Card (Front)",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _vimage != null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.green
                                      ),
                                    ),
                                    child: (
                                        Image.file(
                                          _vimage,fit: BoxFit.fitWidth,height: 200,width: 360,
                                        )),
                                  )
                                      :(
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.green
                                          ),
                                        ),
                                        child: (visit_card_front!="null")?Image.network(RestDatasource. BASE_URL + "visitingcard/" + visit_card_front, width: 360, height: 200,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',)
                                      )
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_vimage != null || visit_card_front!="null") ?
                                  RaisedButton(
                                    onPressed: () {
                                      _showPickerVIS(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),): RaisedButton(
                                    onPressed: () {
                                      _showPickerVIS(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),),
                                  SizedBox(
                                    width: 10,
                                  ),
//                                   (visting == false) ?
//                                   RaisedButton(
//                                     onPressed: () {
//                                       final form = formKey.currentState;
//                                       if (form.validate()) {
//                                         form.save();
//
//                                       }
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(Icons.file_upload, color: Colors.white),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Upload', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.blue.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),):
//                                   RaisedButton(
//                                     onPressed: () {
// //                                      _showPickerProfile(context);
//                                       FlashHelper.successBar(context, message: "Visiting Card Front Image Already Uploaded");
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Uploaded', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.green.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,10,0,10),
                                  child: Text("Select Visiting Card (Back)",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _vbimage != null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.green
                                      ),
                                    ),
                                    child: (
                                        Image.file(
                                          _vbimage,fit: BoxFit.fitWidth,height: 200,width: 360,
                                        )),
                                  )
                                      :(
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.green
                                          ),
                                        ),
                                        child: (visit_card_back!="null")?Image.network(RestDatasource. BASE_URL + "visitingcard/" + visit_card_back, width: 360, height: 200,fit: BoxFit.fitWidth,):Image.asset('images/pro.png',),
                                      )
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_vbimage != null || visit_card_back!="null") ?
                                  RaisedButton(
                                    onPressed: () {
                                      _showPickerVB(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Change', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),):RaisedButton(
                                    onPressed: () {
                                      _showPickerVB(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Camera', style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    color: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),),
                                  SizedBox(
                                    width: 10,
                                  ),
//
//                                   (vistingbb == false) ?
//                                   RaisedButton(
//                                     onPressed: () {
//                                       final form = formKey.currentState;
//                                       if (form.validate()) {
//                                         form.save();
//
//                                       }
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(Icons.file_upload, color: Colors.white),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Upload', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.blue.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),) :
//                                   RaisedButton(
//                                     onPressed: () {
// //                                      _showPickerProfile(context);
//                                       FlashHelper.successBar(context, message: "Visiting Card Back Image Already Uploaded");
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Text('Uploaded', style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold),),
//                                       ],
//                                     ),
//                                     color: Colors.green.shade700,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            FocusScopeNode currentFocus = FocusScope.of(_ctx);
                            if( profile == false){
                              FlashHelper.errorBar(context, message: "Please Upload Your Profile Images");
                            }
                            else if( aathar == false){
                              FlashHelper.errorBar(context, message: "Please Upload Your Aadharcard Images");
                            }
                            else if( pancard == false){
                              FlashHelper.errorBar(context, message: "Please Upload Your Pancard Images");
                            }
                            else{
                              Navigator.of(_ctx).pushReplacementNamed("/registrationthird",
                                  arguments: {
                                    "mobileNo" : mobileNo,
                                  });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                               border: Border.all(
                                 color: Colors.lightGreen,
                                 width: 3
                               ),
                                color: Colors.green,
                              ),
                              child: Text("Next", style: GoogleFonts.lato(color: Colors.white,fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w700),),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
      );
    }
  }

}