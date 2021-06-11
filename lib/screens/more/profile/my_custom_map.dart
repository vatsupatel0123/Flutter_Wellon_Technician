import 'dart:async';

import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as $;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class PlacePickerResult {
  LatLng latLng;
  String address;

  PlacePickerResult(this.latLng, this.address);

  @override
  String toString() {
    return 'PlacePickerResult{latLng: $latLng, address: $address}';
  }
}

class PlacePickerMyScreen extends StatefulWidget {
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  final MapPickerStrings mapStrings;
  final String placeAutoCompleteLanguage;

  const PlacePickerMyScreen(
      {Key key,
        @required this.googlePlacesApiKey,
        @required this.initialPosition,
        @required this.mainColor,
        this.mapStrings,
        this.placeAutoCompleteLanguage})
      : super(key: key);

  @override
  State<PlacePickerMyScreen> createState() => PlacePickerScreenState(
      googlePlacesApiKey: googlePlacesApiKey,
      initialPosition: initialPosition,
      mainColor: mainColor,
      mapStrings: mapStrings,
      placeAutoCompleteLanguage: placeAutoCompleteLanguage);
}

class PlacePickerScreenState extends State<PlacePickerMyScreen> {
  BuildContext _ctx;
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  NetworkUtil _netUtil = new NetworkUtil();

  MapPickerStrings strings;
  String placeAutoCompleteLanguage;

  PlacePickerScreenState(
      {@required this.googlePlacesApiKey,
        @required this.initialPosition,
        @required this.mainColor,
        @required mapStrings,
        @required placeAutoCompleteLanguage}) {
    centerCamera = LatLng(initialPosition.latitude, initialPosition.longitude);
    zoomCamera = 16;
    selectedLatLng =
        LatLng(initialPosition.latitude, initialPosition.longitude);

    _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);

    this.strings = mapStrings ?? MapPickerStrings.english();
    this.placeAutoCompleteLanguage = 'en';
  }

  GoogleMapsPlaces _places;
  GoogleMapController googleMapController;

  //Camera
  LatLng centerCamera;
  double zoomCamera;

  //My Location
  LatLng myLocation;
  String mobileNo;
  SharedPreferences prefs;

  //Selected
  LatLng selectedLatLng;
  String selectedAddress;

  bool loadingAddress = false;
  bool movingCamera = false;

  bool ignoreGeocoding = false;

  static double _defaultZoom = 16;

  ///BASIC
  _moveCamera(LatLng latLng, double zoom) async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom)));
  }

  Future<$.LocationData> _getLocation() async {
    var location = new $.Location();
    $.LocationData locationData;
    try {
      locationData = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        //print('Permission denied');
      }
      locationData = null;
    }

    if (locationData != null)
      myLocation = LatLng(locationData.latitude, locationData.longitude);

    return locationData;
  }

  Future<Address> _reverseGeocoding(double lat, double lng) async {
    final coordinates = new Coordinates(lat, lng);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    //print("${first.featureName} : ${first.addressLine}");
    return first;
  }

  @override
  Widget build(BuildContext context) {
    _setSelectedAddress(LatLng latLng, String address) async {
      setState(() {
        selectedAddress = address;
        selectedLatLng = LatLng(latLng.latitude, latLng.longitude);
      });
    }


    ///GO TO
    _searchPlace() async {
      var location;
      if (myLocation != null) {
        location = Location(myLocation.latitude, myLocation.longitude);
      } else {
        location =
            Location(initialPosition.latitude, initialPosition.longitude);
      }
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googlePlacesApiKey,
        mode: Mode.fullscreen,
        // Mode.fullscreen
        language: placeAutoCompleteLanguage,
        location: location,
      );

      if (p != null) {
        // get detail (lat/lng)
        PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId);
        final lat = detail.result.geometry.location.lat;
        final lng = detail.result.geometry.location.lng;

        var latLng = LatLng(lat, lng);
        var address = p.description;

        CameraPosition newPosition =
        CameraPosition(target: latLng, zoom: _defaultZoom);

        ignoreGeocoding = true;
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(newPosition));

        _setSelectedAddress(latLng, address);
      }
    }

    _goToMyLocation() async {
      await _getLocation();
      if (myLocation != null) {
        _moveCamera(myLocation, _defaultZoom);
      }
    }

    ///WIDGETS
    Widget _mapButtons() {
      return Padding(
        padding: EdgeInsets.only(top: 10, left: 0, right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  _searchPlace();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.only(right: 10,left: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      color: Colors.white,
                    ),
                    child: Text("Search Your Near By Location", style: GoogleFonts.lato(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w700),),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: FloatingActionButton(
            //     heroTag: "FAB_SEARCH_PLACE",
            //     backgroundColor: Colors.white,
            //     child: Icon(
            //       Icons.search,
            //       color: Colors.black,
            //     ),
            //     onPressed: () {
            //       _searchPlace();
            //     },
            //   ),
            // ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: FloatingActionButton(
                  heroTag: "FAB_LOCATION",
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _goToMyLocation();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: centerCamera,
                    zoom: zoomCamera,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  onTap: (latLng) {
                    CameraPosition newPosition =
                    CameraPosition(target: latLng, zoom: _defaultZoom);
                    googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(newPosition));
                  },
                  onCameraMoveStarted: () {
                    setState(() {
                      movingCamera = true;
                    });
                  },
                  onCameraMove: (position) {
                    centerCamera = position.target;
                    zoomCamera = position.zoom;
                  },
                  onCameraIdle: () async {
                    if (ignoreGeocoding) {
                      ignoreGeocoding = false;
                      setState(() {
                        movingCamera = false;
                      });
                    } else {
                      setState(() {
                        movingCamera = false;
                        loadingAddress = true;
                      });

                      var address = (await _reverseGeocoding(
                          centerCamera.latitude, centerCamera.longitude))
                          .addressLine;
                      loadingAddress = false;

                      _setSelectedAddress(centerCamera, address);
                    }
                  },
                ),
                _mapButtons(),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: new Border.all(
                      //   color: Appconstants.secondprimaryColor,
                      //   width: 2.0,
                      // ),
                    ),
                    child: Icon(Icons.location_on,color: mainColor,size: 60,)
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(
                //       child: Container(
                //         child: ListTile(
                //           title: Text("State"),
                //           subtitle: selectedAddress == null
                //               ? Text(strings.firstMessageSelectAddress)
                //               : Text(selectedAddress),
                //           trailing: loadingAddress
                //               ? CircularProgressIndicator(
                //             backgroundColor: mainColor,
                //           )
                //               : null,
                //         ),
                //       ),
                //     ),
                //     Flexible(
                //       child: Container(
                //         child: ListTile(
                //           title: Text("City"),
                //           subtitle: selectedAddress == null
                //               ? Text(strings.firstMessageSelectAddress)
                //               : Text(selectedAddress),
                //           trailing: loadingAddress
                //               ? CircularProgressIndicator(
                //             backgroundColor: mainColor,
                //           )
                //               : null,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Container(
                  padding: EdgeInsets.only(top: 0, bottom: 8),
                  child: ListTile(
                    title: Text(strings.address,style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontWeight: FontWeight.w700),),
                    subtitle: selectedAddress == null
                        ? Text(strings.firstMessageSelectAddress,style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontWeight: FontWeight.w500),)
                        : Text(selectedAddress,style: GoogleFonts.lato(color: Colors.black,letterSpacing: 1,fontWeight: FontWeight.w500),),
                    trailing: loadingAddress
                        ? CircularProgressIndicator(
                      backgroundColor: mainColor,
                    )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          onPressed: !movingCamera &&
                              !loadingAddress &&
                              selectedAddress != null
                              ? () async {
                            PlacePickerResult pickerResult = PlacePickerResult(
                                selectedLatLng, selectedAddress);
                            //print(pickerResult);
                            final coordinates = new Coordinates(
                                pickerResult.latLng.latitude, pickerResult.latLng.longitude);
                            var addresses = await Geocoder.local.findAddressesFromCoordinates(
                                coordinates);
                            _ctx = context;
                            prefs = await SharedPreferences.getInstance();
                            mobileNo= prefs.getString("mobile_numbers") ?? '';
                                _netUtil.post(RestDatasource.UPDATE_LAT_LONG, body: {
                                  'mobile_numbers' : mobileNo,
                                  "latitude": pickerResult.latLng.latitude.toString(),
                                  "longitude": pickerResult.latLng.longitude.toString(),
                                  "state_name":addresses.first.adminArea.toString(),
                                  "city_name":addresses.first.subAdminArea.toString(),
                                  "google_landmark":selectedAddress.toString()
                                }).then((dynamic res) async {
                                  if (res["status"] == "yes") {
                                    FlashHelper.successBar(context, message: "Successfull");
                                    Navigator.of(_ctx).pushReplacementNamed("/registrationfourt",
                                        arguments: {
                                          "mobileNo" : mobileNo,
                                        });
                                  }
                                  else {
                                    FlashHelper.errorBar(context, message: "Something is Wrong");
                                  }
                                });
                            }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              "Confirm & Next".toUpperCase(),
                              style: GoogleFonts.lato(color: Colors.white,fontSize: 18,letterSpacing: 1,fontWeight: FontWeight.w700),
                            ),
                          ),
                          color: mainColor,
                          disabledColor: Colors.grey[350],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: mainColor)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
