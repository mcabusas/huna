import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import "package:google_maps_webservice/places.dart";
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Prediction p;
  GoogleMapController _mapController;
  String searchAddr = "Enter Address";
  static const kGoogleApiKey_places = "AIzaSyA4-_FPY4lT-89lzerQumcnIRkjALK4ljM";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey_places);
  Map locationData = new Map();

  List<Marker> allMarkers = [];

  @override
  void initState(){
    super.initState();
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: (){
          print('tapped');
        },
        position: LatLng(40.688841, -74.044015)
      )
    );
  }
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Location'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(locationData.isEmpty){
              Fluttertoast.showToast(
                msg: "Please select you desired location.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0
              );
            }else{
              print(locationData);
              Navigator.pop(context, locationData);
            }
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: mapCreated,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(10.3157, 123.8854),
                zoom: 11,
              ),
              markers: Set.from(allMarkers),
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                child: TextField(
                  onTap: () async{
                      p = await PlacesAutocomplete.show(
                      context: context, 
                      apiKey: kGoogleApiKey_places,
                      mode: Mode.overlay,
                      language: "en",
                      components: [Component(Component.country, "ph")],
                      radius: 100000000
                    );
                    displayPrediction(p);
                  },
                  decoration: InputDecoration(
                    hintText: searchAddr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: Icon(Icons.search)
                  ),
                  onChanged: (val){
                    setState(() {
                      searchAddr = val;
                    });
                  },
                ),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      double lat = detail.result.geometry.location.lat;
      double long = detail.result.geometry.location.lng;

      locationData['placeId'] = p.placeId;
      locationData['description'] = p.description.toString();
      print(locationData);

      switchLocation(lat, long);
    }
  }

  void mapCreated(controller){
    setState(() {
      _mapController = controller;
    });
  }

  switchLocation(lat, long){
   _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, long), zoom: 20),
    ));
    setState(() {
      searchAddr = p.description;
      allMarkers.removeAt(0);
      allMarkers.add(
        Marker(
          markerId: MarkerId('myMarker'),
          draggable: true,
          onTap: (){
            print('tapped');
          },
          position: LatLng(lat, long),
        )
      );
    });
  }
}