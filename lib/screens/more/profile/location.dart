
import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wellon_partner_app/models/pick_result.dart';



class Location extends StatefulWidget {
  Location({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  static const LatLng DEFAULT_LAT_LNG = LatLng(21.170240, 72.831062); //Madrid

  String result = '';

  @override
  Widget build(BuildContext context) {

    pickPlace() async {
      PlacePickerResult pickerResult = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  PlacePickerScreen(
        googlePlacesApiKey: "AIzaSyDuA5aLsnS-_62kSI2kGG4OjIgpz6c9lR4",
        initialPosition: DEFAULT_LAT_LNG,
        mainColor: Colors.green,
        mapStrings: MapPickerStrings.spanish(),
        placeAutoCompleteLanguage: 'es',
      )));

      setState(() {
        result = pickerResult.toString();
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Location"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
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