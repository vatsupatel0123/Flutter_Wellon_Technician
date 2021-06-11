import 'dart:async';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as $;
import 'package:wellon_partner_app/utils/network_util.dart';

class MapScreen extends StatefulWidget {
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  final MapPickerStrings mapStrings;
  final String placeAutoCompleteLanguage;

  const MapScreen(
      {Key key,
        @required this.googlePlacesApiKey,
        @required this.initialPosition,
        @required this.mainColor,
        this.mapStrings,
        this.placeAutoCompleteLanguage})
      : super(key: key);

  @override
  State<MapScreen> createState() => PlacePickerCustomScreenState(
      googlePlacesApiKey: googlePlacesApiKey,
      initialPosition: initialPosition,
      mainColor: mainColor,
      mapStrings: mapStrings,
      placeAutoCompleteLanguage: placeAutoCompleteLanguage);
}

class PlacePickerCustomScreenState extends State<MapScreen> {
  BuildContext _ctx;
  final String googlePlacesApiKey;
  final LatLng initialPosition;
  final Color mainColor;

  NetworkUtil _netUtil = new NetworkUtil();

  MapPickerStrings strings;
  String placeAutoCompleteLanguage;

  PlacePickerCustomScreenState(
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
        padding: EdgeInsets.only(top: 40, left: 8, right: 8),
        child: Column(
          children: <Widget>[
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
                ),
//                _mapButtons(),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(
                      Icons.location_on,
                      size: 60,
                      color: mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
//
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
