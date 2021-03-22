import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  static const LatLng DEFAULT_LAT_LNG = LatLng(21.122541, 	-28.202545); //Madrid

  String result = '';

  @override
  Widget build(BuildContext context) {


    pickArea() async{
      AreaPickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AreaPickerScreen(
        googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Colors.purple,
        mapStrings: MapPickerStrings.english(),
        placeAutoCompleteLanguage: 'en',
        markerAsset: 'assets/images/icon_look_area.png',
      )));

      setState(() {
        result = pickerResult.toString();
      });
    }

    pickPlace() async {
      PlacePickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  PlacePickerScreen(
        googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Colors.purple,
        mapStrings: MapPickerStrings.english(),
        placeAutoCompleteLanguage: 'en',
      )));

      setState(() {
        result = pickerResult.toString();
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("TE"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: pickArea,
                child: Text("Pick area"),
              ),
              RaisedButton(
                onPressed: pickPlace,
                child: Text("Pick place"),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(result),
              )
            ],
          ),
        )
    );
  }
}