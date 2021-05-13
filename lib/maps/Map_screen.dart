import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:historiskasthlm_app/databas_klasser/addressesStreamer.dart';
import 'package:historiskasthlm_app/databas_klasser/blocs/allAddresses_bloc.dart';
import 'package:http/http.dart' as http;

//KARTASCREEN LAYOUT HÄR

//https://stackoverflow.com/questions/64615365/flutter-how-can-i-get-markers-from-json-api-and-show-on-google-map
//https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
//https://stackoverflow.com/questions/51854891/error-listdynamic-is-not-a-subtype-of-type-mapstring-dynamic
//Kvar att göra: type conversion av List<map<String, dynamic>>

class Map_screen extends StatefulWidget {
  @override
  _Map_screenState createState() => _Map_screenState();
}

class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294, 18.0686);
  GoogleMapController _controller;
  Location _location = Location();
  Future _future;



  Future loadString() async {
    var url = "https://group10-15.pvt.dsv.su.se/demo/addresses/";
    var response = await http.get(Uri.parse(url));
    final dynamic responseBody = jsonDecode(response.body);
   // allAddresses address = new allAddresses.fromJson(responseBody);
    List<String> addressesConverted = new List<String>.from(responseBody);
    print(addressesConverted);
    return addressesConverted;
  }

  List<Marker> allMarkers = [];

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = loadString();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: Text('Historiska Stockholm',
              style: new TextStyle(
                color: Colors.grey[900],
              )),
          backgroundColor: Colors.orange[50],
        ),
        /* body: GoogleMap(

               initialCameraPosition: CameraPosition(
                  target: _initialcameraposition),


                onMapCreated: _onMapCreated,
                myLocationEnabled: true,

                markers: {
                 stockholmMarker
              },


              ),*/
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: _future,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<dynamic> parsedJson = jsonDecode(snapshot.data);

                allMarkers = parsedJson.map((i) {
                  return Marker(
                    markerId: MarkerId(i['address']),
                    position: LatLng(i['latitude'], i['longitude']),
                    onTap: () {},
                  );
                }).toList();
                return GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition),
                  markers: Set.from(allMarkers),
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationEnabled: true,
                );
              },
            ),
          ),
        ]),
      ),
      Positioned(
          //HÄR BÖRJAR SÖKRUTAN
          top: 70,
          right: 15,
          left: 15,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(children: <Widget>[
                IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(Icons.place),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    //BYTTA KEYBOAD TYPE
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Sök..."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(
                        () {},
                      );
                    },
                  ),
                )
              ]))),
      Positioned(
          top: 130,
          right: 15,
          left: 15,
          child: new Container(
            height: 73,
            width: 50,
            child:
                ListView(scrollDirection: Axis.horizontal, children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.transparent,
                ),
                width: 160.0,
                height: 5,
                child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    label: Text(
                      'Adress',
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        color: new Color.fromRGBO(128, 128, 128, 1),
                      ),
                    )),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.transparent,
                  ),
                  width: 160.0,
                  height: 5,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    label: Text('År',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color.fromRGBO(128, 128, 128, 1),
                        )),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.transparent,
                  ),
                  width: 160.0,
                  height: 5,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    label: Text('Byggnader',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color.fromRGBO(128, 128, 128, 1),
                        )),
                  )),
            ]),
          ))
    ]);
  }
}

Marker stockholmMarker = Marker(
    markerId: MarkerId('stockholm1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(14),
    position: LatLng(59.31433730000001, 18.0735509),
    infoWindow: InfoWindow(title: 'Medborgarplatsen'),
    // onTap: () {
    //     Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => HomePage()),
    //     );
    //   }
    // }
    onTap: () {
      print('hej');
    });
class allAddresses {
  String address;
  double latitude;
  double longitude;
  //List<Null> bilder;

  allAddresses({this.address, this.latitude, this.longitude});

  allAddresses.fromJson(Map<String, dynamic> json) {
    var addressConverted = json['allAddresses'];

    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    /*if (json['bilder'] != null) {
      bilder = new List<Null>();
      json['bilder'].forEach((v) {
        bilder.add(new Null.fromJson(v));
      });
    }*/ //kopplade bilder
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    /*  if (this.bilder != null) {
      data['bilder'] = this.bilder.map((v) => v.toJson()).toList();
    }
    return data;
  } */ //kopplade bilder
  }
}

//https://www.youtube.com/watch?v=lNqEfnnmoHk
//https://www.geoapify.com/map-marker-icons-generator-create-beautiful-icons-for-your-map
//https://www.youtube.com/watch?v=acjtWVc_7sc
