import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/screens/more/profile/map_display.dart';
import 'package:flutter_map_picker/src/map_place_picker.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';


class MyProfileScreen extends StatefulWidget {
@override
_MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with SingleTickerProviderStateMixin{

  // Future<List<ReviewList>> ReviewListdata;
  // Future<List<ReviewList>> ReviewListListfilterData;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  LatLng DEFAULT_LAT_LNG;
  //Madrid

//  String result = '';
//  String result1 = '';

  BuildContext _ctx;
  File profilephoto=null;
  TabController _tabController;
  int _currentIndex = 0;

  //GLOBLE DECLARE SHAREPRE
  SharedPreferences prefs;
  bool _isdataLoading = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final formKey1 = new GlobalKey<FormState>();
  final formKey2 = new GlobalKey<FormState>();

  String spfullname="",provider_id="0",mobile_numbers="";
  String service_provider_lat,service_provider_long,about,short_description,shop_code;
  String _about;
  String newlat,newlog,newabout;
  bool IsActive;
  String rating_id,order_id,review_text,rating_date_time,is_display,created_at,updated_at,username,trymy;
  String latLng;
  double rating=0;
  IconData _selectedIcon;

  String mobileNo;
  String _instance,_normal,_amc,_water_purifier,_alkaline_wp;
  bool sp_type_instance = false;
  bool sp_type_normal = false;
  bool sp_type_amc = false;
  bool edit = true;
  bool update = false;
  bool sp_type_water_purifier = false;
  bool sp_type_alkaline_water_purifier = false;

  String inst_ro_do_instance;
  String inst_ro_do_normal;
  String inst_ro_co_instance;
  String inst_ro_co_normal;
  String inst_alkaline_instance;
  String inst_alkaline_normal;
  String service_ro_do_instance;
  String service_ro_do_normal;
  String service_ro_co_instance;
  String service_ro_co_normal;
  String service_alkaline_instance;
  String service_alkaline_normal;

  _loadService() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile_numbers= prefs.getString("mobile_numbers") ?? '';
      _netUtil.post(RestDatasource.GET_SP_SERVICE, body: {
        "mobile_numbers":mobile_numbers,
      }).then((dynamic res) async {
        //print(res);
        setState(() {
          inst_ro_do_instance=res[0]["inst_ro_do_instance"];
          inst_ro_do_normal=res[0]["inst_ro_do_normal"];
          inst_ro_co_instance=res[0]["inst_ro_co_instance"];
          inst_ro_co_normal=res[0]["inst_ro_co_normal"];
          inst_alkaline_instance=res[0]["inst_alkaline_instance"];
          inst_alkaline_normal=res[0]["inst_alkaline_normal"];
          service_ro_do_instance=res[0]["service_ro_do_instance"];
          service_ro_do_normal=res[0]["service_ro_do_normal"];
          service_ro_co_instance=res[0]["service_ro_co_instance"];
          service_ro_co_normal=res[0]["service_ro_co_normal"];
          service_alkaline_instance=res[0]["service_alkaline_instance"];
          service_alkaline_normal=res[0]["service_alkaline_normal"];

          _isdataLoading=false;
        });
      });

    });
  }

  NetworkUtil _netUtil = new NetworkUtil();
  String firstname,middlename,lastname,mobilenumber,emailid,address,pincode,gender,profile_photo,street,area,landmark,house_no,house_name;
  String _houseno,_housename,_street,_area,_landmark,_pincode;

  TextEditingController _latcontroller=new TextEditingController();
  TextEditingController _logcontroller=new TextEditingController();
  TextEditingController _houseno_namecontroller=new TextEditingController();
  TextEditingController _housename_namecontroller=new TextEditingController();
  TextEditingController _street_namecontroller=new TextEditingController();
  TextEditingController _area_namecontroller=new TextEditingController();
  TextEditingController _landmark_namecontroller=new TextEditingController();
  TextEditingController _pincode_namecontroller=new TextEditingController();
  TextEditingController _about_namecontroller=new TextEditingController();


  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {

      provider_id= prefs.getString("provider_id") ?? '';
      spfullname= prefs.getString("spfullname") ?? '';
      mobile_numbers= prefs.getString("mobile_numbers") ?? '';

        _netUtil.post(RestDatasource.URL_PROFILE_DATA, body: {
          "provider_id":provider_id,
          "spfullname":spfullname,
          "mobile_numbers":mobile_numbers,
//          "provider_id":prefs.getString("provider_id"),
//          "provider_id":"3",
        }).then((dynamic res1) async {
          setState(() {
            _latcontroller.text=res1["service_provider_lat"].toString();
            _logcontroller.text=res1["service_provider_long"].toString();
            short_description=res1["short_description"].toString();
            shop_code=res1["shop_code"].toString();
            _about_namecontroller.text=res1["about"].toString();

            DEFAULT_LAT_LNG=LatLng(double.parse(res1["service_provider_lat"]),double.parse(res1["service_provider_long"]));

            _latcontroller.text=service_provider_lat;
            _logcontroller.text=service_provider_long;
            _about_namecontroller.text=about;

            newlat=service_provider_lat;
            newlog=service_provider_long;
            newabout=about;


            _isdataLoading=false;
          });
        });

    });
  }
  _loadprofile() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _netUtil.post(RestDatasource.GET_REGISTER_DATA, body: {
        "mobile_numbers":mobile_numbers,
      }).then((dynamic res) async {
        setState(() {
          firstname=res[0]["first_name"];
          middlename=res[0]["middle_name"];
          lastname=res[0]["last_name"];
          emailid=res[0]["email_id"];
          gender=res[0]["gender"];
          house_no=res[0]["house_no"];
          house_name=res[0]["house_name"];
          street=res[0]["address1"];
          area=res[0]["address2"];
          landmark=res[0]["address3"];
          pincode=res[0]["pincode"];
          profile_photo=res[0]["profile_photo"];
          _houseno_namecontroller.text=house_no;
          _housename_namecontroller.text=house_name;
          _street_namecontroller.text=street;
          _area_namecontroller.text=area;
          _landmark_namecontroller.text=landmark;
          _pincode_namecontroller.text=pincode;
        });
      });

    });
  }

  //Load Data
//
//   Future<List<ReviewList>> _getReviewData() async
//   {
//     return _netUtil.post(RestDatasource.GET_CUS_ORDER_RATING,
//         body:{
//           "provider_id":prefs.getString("provider_id"),
//         }
//     ).then((dynamic res)
//     {
//       final items = res.cast<Map<String, dynamic>>();
//       List<ReviewList> listofusers = items.map<ReviewList>((json) {
//         return ReviewList.fromJson(json);
//       }).toList();
//       List<ReviewList> revdata = listofusers.reversed.toList();
//       return revdata;
//     });
//   }
// //Load Data
//   //On Refresh
//   Future<List<ReviewList>> _refresh1() async
//   {
//     setState(() {
//       ReviewListdata = _getReviewData();
//       ReviewListListfilterData=ReviewListdata;
//     });
//   }
 _loadReview() async {
   prefs = await SharedPreferences.getInstance();
   setState(() {

     provider_id= prefs.getString("provider_id") ?? '';

     _netUtil.post(RestDatasource.GET_CUS_ORDER_RATING, body: {
       "provider_id":provider_id,
     }).then((dynamic res) async {
       setState(() {
         rating=double.parse(res["sp_rating"].toString());

         _isdataLoading=false;
       });
     });

   });
 }
  _imgFromCameraPro() async {
    var  image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_PROFILE_PHOTO, body: {
      "SPprofilepic": base64Image,
      'mobile_numbers' : mobile_numbers,
    }).then((dynamic res) async {
      //print("Web pro"+res["status"]);
      if (res["status"] == "yes") {
      }
    });
    setState(() {
      profilephoto = image;
    });
  }

  _imgFromGalleryPro() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String base64Image = base64Encode(image.readAsBytesSync());
    _netUtil.post(RestDatasource.SEND_PROFILE_PHOTO, body: {
      "SPprofilepic": base64Image,
      'mobile_numbers' : mobile_numbers,
    }).then((dynamic res) async {
      //print("Web pro"+res["status"]);
      if (res["status"] == "yes") {
      }
    });
    setState(() {
      profilephoto = image;
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

  //Load Data
  //On Refresh


  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;


  @override
  initState() {
    super.initState();
    //print("setstate called");
    _loadPref();
    _loadService();
    _loadReview();
    _loadprofile();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode;

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
      _currentIndex = _tabController.index;
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
    pickPlace() async {
      PlacePickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  PlacePickerScreen(
        googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Colors.green,
        mapStrings: MapPickerStrings.english(),
        placeAutoCompleteLanguage: 'en',
      )));
      setState(() async {
        newlat = pickerResult.latLng.latitude.toString();
        _latcontroller.text=newlat;
        final coordinates = new Coordinates(
            pickerResult.latLng.latitude, pickerResult.latLng.longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(
            coordinates);
        newlog = pickerResult.latLng.longitude.toString();
        _logcontroller.text=newlog;
        if (_isLoading == false) {
          final form = formKey.currentState;
          if (form.validate()) {
            setState(() => _isLoading = true);
            form.save();
            _netUtil.post(RestDatasource.UPDATE_LAT_LONG, body: {
              "mobile_numbers":prefs.getString("mobile_numbers"),
              "latitude": newlat,
              "longitude": newlog,
              "state_name":addresses.first.adminArea.toString(),
              "city_name":addresses.first.subAdminArea.toString(),
              "google_landmark":pickerResult.address
            }).then((dynamic res) async {
              if (res["error"] == true) {
                FlashHelper.errorBar(context, message: "Something is Wrong");
                setState(() => _isLoading = false);
              }
              else {
                formKey.currentState.reset();
                FlashHelper.successBar(context, message: "Successfull Update");
                setState(() {
                  _loadPref();
                  _isLoading = false;
                });
                Navigator.of(context).pushReplacementNamed('/myprofile');
              }
            });
          }
        }

        //Navigator.of(context).pushNamed("/myprofile");
      });
    }
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
     return DefaultTabController(
       length: 4,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("MY PROFILE",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            centerTitle: true,
            backgroundColor: Colors.green,
            bottom: TabBar(
              indicatorColor: Colors.white,
              controller: _tabController,
              tabs: <Tab>[
                new Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Profile",style: GoogleFonts.lato(color:_tabController.index == 0 ? Colors.white : Colors.white70,letterSpacing: _tabController.index == 0 ?1:0,fontSize: 15,fontWeight: FontWeight.w600),),
                  ),
                ),
                new Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Location",style: GoogleFonts.lato(color:_tabController.index == 1 ? Colors.white : Colors.white70,letterSpacing: _tabController.index == 1 ?1:0,fontSize: 15,fontWeight: FontWeight.w600),),
                  ),
                ),
                new Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("About",style: GoogleFonts.lato(color:_tabController.index == 2 ? Colors.white : Colors.white70,letterSpacing: _tabController.index == 2 ?1:0,fontSize: 15,fontWeight: FontWeight.w600),),
                  ),
                ),
                new Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Work Type",style: GoogleFonts.lato(color:_tabController.index == 3 ? Colors.white : Colors.white70,letterSpacing: _tabController.index == 3 ?1:0,fontSize: _tabController.index == 3 ?13:15,fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          ),
            body:
             new TabBarView(
              controller: _tabController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container (
                          alignment:Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.green,
                              width: 3.0,
                            ),
                          ),
                          child: SizedBox.fromSize(
                            size: Size(170, 170), // button width and height
                            child: ClipOval(
                              child: Material(
                                color: Colors.white,
                                // button color
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    profilephoto != null
                                        ? (
                                        Image.file(
                                          profilephoto,
                                          fit: BoxFit.fitWidth,height: 170,width: 170,
                                        ))
                                        : (
                                        (profile_photo!=null)?Image.network(RestDatasource. BASE_URL + "spprofile/" + profile_photo, width: 170, height: 170,fit: BoxFit.fitWidth,):
                                        Center(
                                          child: CircularProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 95,top: 155),
                        child: InkWell(
                          onTap: (){
                            _showPickerProfile(context);
                          },
                          child: Center(
                            child: Container(
                              alignment:Alignment.center,
                              width: 50,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child:  Icon(Icons.camera_alt, color: Colors.white, size: 30.0,),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                        child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Icon(Icons.person_outline, color: Colors.green.shade600, size: 30.0,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Full Name",
                                          style: GoogleFonts.lato(color:Colors.grey.shade700,letterSpacing: 1,fontSize: 18,fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          (spfullname!=null)?spfullname:"",
                                          style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Icon(Icons.email, color: Colors.green.shade600, size: 30.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: GoogleFonts.lato(color:Colors.grey.shade700,fontSize: 18,fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            (emailid!=null)?emailid:"",
                                            style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Icon(Icons.call, color: Colors.green.shade600, size: 30.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Contact Number",
                                              style: GoogleFonts.lato(color:Colors.grey.shade700,fontSize: 18,fontWeight: FontWeight.w700),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.pushNamed(context, "/changemobilenumber",arguments: {
                                                    "mobilenumber":mobile_numbers
                                                  });
                                                },
                                                child: Text(
                                                  "Edit",
                                                  style: GoogleFonts.lato(color:Colors.blueAccent,fontSize: 18,fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          (mobile_numbers!=null)?mobile_numbers:"",
                                          style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                        ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Icon(Icons.radio_button_checked, color: Colors.green.shade600, size: 30.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text(
                                          "Gender",
                                          style: GoogleFonts.lato(color:Colors.grey.shade700,fontSize: 18,fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          (gender!=null)?gender:"",
                                          style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                        ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: edit,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30),
                                        child: Icon(Icons.person_pin_circle, color: Colors.green.shade600, size: 40.0,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Address",
                                                  style: GoogleFonts.lato(color:Colors.grey.shade700,fontSize: 18,fontWeight: FontWeight.w700),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 50),
                                                  child: InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        edit=false;
                                                        update=true;
                                                      });
                                                    },
                                                    child: Text(
                                                      "Edit",
                                                      style: GoogleFonts.lato(color:Colors.blueAccent,fontSize: 18,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              ((house_no!=null)?house_no:"")+
                                                  ((house_name!=null)?" , "+house_name:""),
                                              style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              (street!=null)?street+" ,":"",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              (landmark!=null)?landmark+" ,":"",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              ((area!=null)?area:"")+
                                                  ((pincode!=null)?" - "+pincode:""),
                                              style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Icon(Icons.star, color: Colors.green.shade600, size: 30.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rating $rating",
                                            style: GoogleFonts.lato(color:Colors.grey.shade700,fontSize: 18,fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 5,),
                                          RatingBarIndicator(
                                            rating: rating,
                                            itemBuilder: (context, index) => Icon(
                                              _selectedIcon ?? Icons.star,
                                              color: Colors.lightGreenAccent.shade700,
                                            ),
                                            itemCount: 5,
                                            itemSize: 50.0,
                                            unratedColor: Colors.lightGreenAccent.shade700.withAlpha(50),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Visibility(
                                  visible: update,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30,right: 20),
                                      child: Column(
                                        children: [
                                          Form(
                                            key: formKey2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text("House / Unit No", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                    Container(
                                                      child: Text("House / Unit Name", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 10),
                                                        child: Container(
                                                            child: TextFormField(
                                                              textCapitalization: TextCapitalization.characters,
                                                              initialValue: null,
                                                              controller: _houseno_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.text,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _houseno = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _houseno = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length == 0)
                                                                  return "Enter House No";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'House / Unit No'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Container(
                                                            child: TextFormField(
                                                              textCapitalization: TextCapitalization.sentences,
                                                              initialValue: null,
                                                              controller: _housename_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.text,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _housename = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _housename = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length == 0)
                                                                  return "Enter House Name";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'House / Unit Name'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text("Street", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                    Container(
                                                      child: Text("Area", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 10),
                                                        child: Container(
                                                            child: TextFormField(
                                                              textCapitalization: TextCapitalization.sentences,
                                                              initialValue: null,
                                                              controller: _street_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.text,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _street = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _street = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length == 0)
                                                                  return "Enter Street";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'Street'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Container(
                                                            width:MediaQuery.of(context).size.width*0.40,
                                                            child: TextFormField(
                                                              textCapitalization: TextCapitalization.sentences,
                                                              initialValue: null,
                                                              controller: _area_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.text,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _area = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _area = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length == 0)
                                                                  return "Enter Area";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'Area'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text("Landmark", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                    Container(
                                                      child: Text("Pincode", style: GoogleFonts.lato(color: Colors.grey.shade700,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 10),
                                                        child: Container(
                                                            child: TextFormField(
                                                              textCapitalization: TextCapitalization.sentences,
                                                              initialValue: null,
                                                              controller: _landmark_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.text,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _landmark = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _landmark = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length == 0)
                                                                  return "Enter Landmark";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'Landmark'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Container(
                                                            width:MediaQuery.of(context).size.width*0.40,
                                                            child: TextFormField(
                                                              initialValue: null,
                                                              controller: _pincode_namecontroller,
                                                              obscureText: false,
                                                              style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                                              keyboardType: TextInputType.number,
                                                              onSaved: (val) {
                                                                setState(() {
                                                                  _pincode = val;
                                                                });
                                                              },
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _pincode = val;
                                                                });
                                                              },
                                                              validator: (val){
                                                                if (val.length != 6)
                                                                  return "Valid Pincode digit";
                                                                else
                                                                  return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelStyle: GoogleFonts.lato(color: Colors.black),
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
                                                                      borderSide: BorderSide(color: Colors.white24)
                                                                    //borderSide: const BorderSide(),
                                                                  ),
                                                                  hintText: 'Pin Code'
                                                              ),)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: update,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  child: InkWell(
                                    onTap: () {
                                      final form = formKey2.currentState;
                                      if (form.validate()) {
                                        form.save();
                                        NetworkUtil _netUtil = new NetworkUtil();
                                        _netUtil.post(RestDatasource.UPDATE_ADDRESS, body: {
//                                        "provider_id":"141",
                                          "house_no": _houseno,
                                          "house_name": _housename,
                                          "address1": _street,
                                          "address2": _area,
                                          "address3": _landmark,
                                          "pincode":_pincode,
                                          "mobile_numbers": mobile_numbers,
                                        }).then((dynamic res) async {
                                          if (res["statusupdate"] == "yes") {
                                            formKey2.currentState.reset();
                                            FlashHelper.successBar(context, message: "successfully updated");
                                            setState(() {
                                              update=false;
                                              edit=true;
                                              _loadprofile();
                                            });
                                          }
                                          else {
                                            FlashHelper.errorBar(context, message: "Something is Wrong");
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        color: Colors.green.shade600,
                                      ),
                                      child: Text("Update", style: GoogleFonts.lato(color:Colors.white,fontSize:15,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                (DEFAULT_LAT_LNG!=null)?new Form(
                  key: formKey,
                  child: Stack(

                  children: <Widget>[
                    Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    height: 300,
                                      width: 400,
                                      child: MapScreen(
                                        googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
                                        initialPosition: (DEFAULT_LAT_LNG!=null)?DEFAULT_LAT_LNG:"",
                                        mainColor: Colors.green,
                                        mapStrings: MapPickerStrings.english(),
                                        placeAutoCompleteLanguage: 'en',
                                      )
//                                        child: new Image.asset("images/googlemap.png", width: 500, height: 307,)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
//                                  Padding(
//                                    padding: EdgeInsets.all(16),
//                                    child: Text(
//                                        (newlat!=null)?newlat:"",
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.all(16),
//                                    child: Text(
//                                      (newlog!=null)?newlog:"",
//                                    ),
//                                  ),
                                ],
                              ),
//                              Container(
//                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                                  child: TextFormField(
//                                      enabled: false,
//                                      initialValue: null,
//                                      controller: _latcontroller,
//                                      obscureText: false,
//                                      keyboardType: TextInputType.text,
//                                      onSaved: (val) {
//                                        setState(() {
//                                          newlat= val;
//                                        });
//                                      },
//                                      validator: validateName,
//                                      decoration: InputDecoration(
//                                          focusedBorder: OutlineInputBorder(
//                                              borderSide: BorderSide(
//                                                  width: 2, color: Color(0xff33691E)
//                                              )
//                                          ),
//                                          border: OutlineInputBorder(
//                                              borderSide: BorderSide()
//                                          ),
//                                          fillColor: Color(0xfff3f3f4),
//                                          filled: true))
//                              ),
//                              Container(
//                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                                  child: TextFormField(
//                                      enabled: false,
//                                      initialValue: null,
//                                      controller: _logcontroller,
//                                      obscureText: false,
//                                      keyboardType: TextInputType.text,
//                                      onSaved: (val) {
//                                        setState(() {
//                                          newlog = val;
//                                        });
//                                      },
//                                      validator: validateName,
//                                      decoration: InputDecoration(
//                                          focusedBorder: OutlineInputBorder(
//                                              borderSide: BorderSide(
//                                                  width: 2, color: Color(0xff33691E)
//                                              )
//                                          ),
//                                          border: OutlineInputBorder(
//                                              borderSide: BorderSide()
//                                          ),
//                                          fillColor: Color(0xfff3f3f4),
//                                          filled: true))
//                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (pickPlace),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          border: Border.all(
                                            color: Colors.green.shade600,
                                          ),
                                        ),
                                        child: Text("Update Location", style: GoogleFonts.lato(color:Colors.green.shade600,letterSpacing: 1,fontSize: 15,fontWeight: FontWeight.w700),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                  ):Center(
                child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
              ),

                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[

                          SizedBox(
                            height: 10,
                          ),
                      new Form(
                        key: formKey1,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                            child: TextFormField(
                                maxLines: 20,
                                initialValue: null,
                                controller: _about_namecontroller,
                                obscureText: false,
                                style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w700),
                                keyboardType: TextInputType.text,
                                onSaved: (val) {
                                  setState(() {
                                    newabout = val;
                                  });
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xff33691E)
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide()
                                    ),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true))

                        ),
                      ),

                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 50),
                              child: InkWell(
                                onTap: () {
                                    final form = formKey1.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      NetworkUtil _netUtil = new NetworkUtil();
                                      _netUtil.post(
                                          RestDatasource.URL_CHANGE_REVIEW, body: {
//                                        "provider_id":"141",
                                        "provider_id":prefs.getString("provider_id"),
                                        "about": newabout,
                                      }).then((dynamic res) async {
                                        if (res["status"] == "true") {
                                          formKey1.currentState.reset();
                                          FlashHelper.successBar(context, message: "successfully updated");
                                        }
                                        else {
                                          FlashHelper.errorBar(context, message: "Something is Wrong");
                                        }
                                      });
                                    }
                                },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      color: Colors.green.shade600,
                                    ),
                                    child: Text("Update", style: GoogleFonts.lato(color:Colors.white,fontSize:15,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
//                          Align(
//                            alignment: Alignment.centerLeft,
//                            child: Padding(
//                              padding: const EdgeInsets.fromLTRB(20,20,0,20),
//                              child: Text("Select Work type.",style: GoogleFonts.lato(color:Color(0xff33691E),fontSize: 16),
//                              ),
//                            ),
//                          ),
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
                                        style: GoogleFonts.lato(color:Colors.green,fontSize:22,letterSpacing: 1,fontWeight: FontWeight.w700),
                                      ),
                                      _divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Water Purifiers",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize:16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                                height: 5
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
//                                                 Flexible(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
//                                                     child: TextFormField(
//                                                       initialValue: (inst_ro_do_instance!=null)?"₹"+inst_ro_do_instance:"₹0",
//                                                       obscureText: false,
//                                                       enabled: false,
//                                                       style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
//                                                       keyboardType: TextInputType.number,
// //                                                      onSaved: (val) => inst_ro_do_instance.text = val,
//                                                       decoration: InputDecoration(
//                                                           labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
//                                                           filled: true,
//                                                           labelText: "Instant Price",
//                                                           focusedBorder: OutlineInputBorder(
//                                                               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                                                               borderSide: BorderSide(
//                                                                   width: 2, color: Colors.green
//                                                               )
//                                                           ),
//                                                           border: OutlineInputBorder(
//                                                             // width: 0.0 produces a thin "hairline" border
//                                                               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                                                               borderSide: BorderSide(color: Colors.white24),
//                                                             //borderSide: const BorderSide(),
//                                                           ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                    child: TextFormField(
                                                      initialValue: (inst_ro_do_normal!=null)?"₹"+inst_ro_do_normal:"₹0",
                                                      obscureText: false,
                                                      enabled: false,
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                      keyboardType: TextInputType.number,
                                                      onSaved: (val) => _instance = val,
                                                      decoration: InputDecoration(
                                                          labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                          filled: true,
                                                          labelText: "Regular Price",
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(
                                                                width: 2, color: Colors.green,
                                                              )
                                                          ),
                                                          border: OutlineInputBorder(
                                                            // width: 0.0 produces a thin "hairline" border
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(color: Colors.white24)
                                                            //borderSide: const BorderSide(),
                                                          ),
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
                                              "Alkaline Water Ionizers",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize:16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                                height:10
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                // Flexible(
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                //     child: TextFormField(
                                                //       initialValue: (inst_alkaline_instance!=null)?"₹"+inst_alkaline_instance:"₹0",
                                                //       obscureText: false,
                                                //       enabled: false,
                                                //       style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                //       keyboardType: TextInputType.number,
                                                //       onSaved: (val) => _instance = val,
                                                //       decoration: InputDecoration(
                                                //           labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                //           filled: true,
                                                //           labelText: "Instant Price",
                                                //           focusedBorder: OutlineInputBorder(
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(
                                                //                   width: 2, color: Colors.green
                                                //               )
                                                //           ),
                                                //           border: OutlineInputBorder(
                                                //             // width: 0.0 produces a thin "hairline" border
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(color: Colors.white24)
                                                //             //borderSide: const BorderSide(),
                                                //           ),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                    child: TextFormField(
                                                      initialValue: (inst_alkaline_normal!=null)?"₹"+inst_alkaline_normal:"₹0",
                                                      obscureText: false,
                                                      enabled: false,
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                      keyboardType: TextInputType.number,
                                                      onSaved: (val) => _instance = val,
                                                      decoration: InputDecoration(
                                                          labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                          filled: true,
                                                          labelText: "Regular Price",
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(
                                                                width: 2, color: Colors.green,
                                                              )
                                                          ),
                                                          border: OutlineInputBorder(
                                                            // width: 0.0 produces a thin "hairline" border
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(color: Colors.white24)
                                                            //borderSide: const BorderSide(),
                                                          ),
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
                                      SizedBox(
                                          height: 10
                                      ),
                                      Text(
                                        "Service",
                                        style: GoogleFonts.lato(color:Colors.green,fontSize:22,letterSpacing: 1,fontWeight: FontWeight.w700),
                                      ),
                                      _divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Water Purifier",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize:16,letterSpacing: 0.5,fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[

                                            SizedBox(
                                                height: 5
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                // Flexible(
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                //     child: TextFormField(
                                                //       initialValue: (service_ro_do_instance!=null)?"₹"+service_ro_do_instance:"₹0",
                                                //       obscureText: false,
                                                //       enabled: false,
                                                //       style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                //       keyboardType: TextInputType.number,
                                                //       onSaved: (val) => _instance = val,
                                                //       decoration: InputDecoration(
                                                //           labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                //           filled: true,
                                                //           labelText: "Instant Price",
                                                //           focusedBorder: OutlineInputBorder(
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(
                                                //                   width: 2, color: Colors.green
                                                //               )
                                                //           ),
                                                //           border: OutlineInputBorder(
                                                //             // width: 0.0 produces a thin "hairline" border
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(color: Colors.white24)
                                                //             //borderSide: const BorderSide(),
                                                //           ),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                    child: TextFormField(
                                                      initialValue: (service_ro_do_normal!=null)?"₹"+service_ro_do_normal:"₹0",
                                                      obscureText: false,
                                                      enabled: false,
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                      keyboardType: TextInputType.number,
                                                      onSaved: (val) => _instance = val,
                                                      decoration: InputDecoration(
                                                          labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                          filled: true,
                                                          labelText: "Regular Price",
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(
                                                                width: 2, color: Colors.green,
                                                              )
                                                          ),
                                                          border: OutlineInputBorder(
                                                            // width: 0.0 produces a thin "hairline" border
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(color: Colors.white24)
                                                            //borderSide: const BorderSide(),
                                                          ),
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
                                              "Alkaline Water Ionizers",
                                              style: GoogleFonts.lato(color:Colors.black,fontSize:16,letterSpacing: 0.5,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                                height: 10
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[

                                                // Flexible(
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                //     child: TextFormField(
                                                //       initialValue: (service_alkaline_instance!=null)?"₹"+service_alkaline_instance:"₹0",
                                                //       obscureText: false,
                                                //       enabled: false,
                                                //       style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                //       keyboardType: TextInputType.number,
                                                //       onSaved: (val) => _instance = val,
                                                //       decoration: InputDecoration(
                                                //           labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                //           filled: true,
                                                //           labelText: "Instant Price",
                                                //           focusedBorder: OutlineInputBorder(
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(
                                                //                   width: 2, color: Colors.green
                                                //               )
                                                //           ),
                                                //           border: OutlineInputBorder(
                                                //             // width: 0.0 produces a thin "hairline" border
                                                //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                //               borderSide: BorderSide(color: Colors.white24)
                                                //             //borderSide: const BorderSide(),
                                                //           ),
                                                //           hintText: 'Instance Price'
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                    child: TextFormField(
                                                      initialValue: (service_alkaline_normal!=null)?"₹"+service_alkaline_normal:"₹0",
                                                      obscureText: false,
                                                      enabled: false,
                                                      style: GoogleFonts.lato(color:Colors.black,fontSize:15,fontWeight: FontWeight.w600),
                                                      keyboardType: TextInputType.number,
                                                      onSaved: (val) => _instance = val,
                                                      decoration: InputDecoration(
                                                          labelStyle: GoogleFonts.lato(color:Colors.green,fontSize:16,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                          filled: true,
                                                          labelText: "Regular Price",
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(
                                                                width: 2, color: Colors.green,
                                                              )
                                                          ),
                                                          border: OutlineInputBorder(
                                                            // width: 0.0 produces a thin "hairline" border
                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              borderSide: BorderSide(color: Colors.white24)
                                                            //borderSide: const BorderSide(),
                                                          ),
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

                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
        ),
      );
    }
  }
}
