import 'dart:async';

import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/screens/more/profile/my_custom_map.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
import 'package:location/location.dart';


class UserRegistrationThirdChangeScreen extends StatefulWidget {
  @override
  _UserRegistrationThirdChangeScreenState createState() => _UserRegistrationThirdChangeScreenState();
}

class _UserRegistrationThirdChangeScreenState extends State<UserRegistrationThirdChangeScreen> {
  BuildContext _ctx;
  bool _isLoading = false;
  bool _isdataLoading = false;
  bool _debugLocked = false;
  String result;
  String lat;
  String long,mobile_numbers;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;

  //LatLng DEFAULT_LAT_LNG=LatLng(21.2051954,72.7992865); //Madrid
  LatLng DEFAULT_LAT_LNG; //Madrid

  String mobileNo;
  String _latitude,_longitude;
  //Location location = new Location();

  TextEditingController _lat_namecontroller=new TextEditingController();
  TextEditingController _long_namecontroller=new TextEditingController();

  getLocation() async {
    var location = new Location();
    location.onLocationChanged.listen((  currentLocation) {
      setState(() {
        //print("hii");
        DEFAULT_LAT_LNG = LatLng(currentLocation.latitude,currentLocation.longitude);
      });
    });
  }

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
//    pickPlace();
  }

  void dispose(){
    super.dispose();
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
      _netUtil.post(RestDatasource.GET_REGISTER_DATA, body: {
        'mobile_numbers' : mobileNo,
      }).then((dynamic res) async {
        if(res[0]["latitude"]==null && res[0]["longitude"]==null)
          {
            getLocation();
          }else{
          setState(() {
            DEFAULT_LAT_LNG=LatLng(double.parse(res[0]["latitude"]),double.parse(res[0]["longitude"]));
          });
        }
      });
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text("Add Location",style: GoogleFonts.lato(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
          ),
          key: scaffoldKey,
          body: (DEFAULT_LAT_LNG!=null)?
          SingleChildScrollView(
            child:
              Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Pick Your Near By Location", style: GoogleFonts.lato(color: Colors.green,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.68,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green,width: 0)
                              ),
                              child:
                              PlacePickerMyScreen(
                                googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
                                initialPosition: DEFAULT_LAT_LNG,
                                mainColor: Colors.green,
                                mapStrings: MapPickerStrings.english(),
                                placeAutoCompleteLanguage: 'en',
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ):Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          ),
      );
    }
  }
}
