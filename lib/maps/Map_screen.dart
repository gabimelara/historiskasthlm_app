import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

//KARTASCREEN LAYOUT HÄR

class Map_screen extends StatefulWidget {
  @override
  _Map_screenState createState() => _Map_screenState();
}

class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294, 18.0686);
  GoogleMapController _controller;
  String searchAddr;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    //  _location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //    CameraUpdate.newCameraPosition(
    //      CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
    //   ),
    // );
    // });
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
          body: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialcameraposition),
            onMapCreated: _onMapCreated,
            // mapType: MapType.hybrid,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          )),
      Positioned(
        top: 650,
        right: 320,
        left: 0,
        child: CircleAvatar(
          //Positions knappen
          radius: 30,
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          child: IconButton(
              icon: Icon(Icons.center_focus_strong),
              color: Colors.grey,
              onPressed: () => _location.onLocationChanged.listen((l) {
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(l.latitude, l.longitude), zoom: 15),
                      ),
                    );
                  })),
        ),
      ),
      Positioned(
        //HÄR BÖRJAR SÖKRUTAN
        top: 85,
        right: 15,
        left: 15,
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Sök',
                border: InputBorder.none,
                //  keyboardType: TextInputType.text,
                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchandNavigate,
                    iconSize: 30.0)),
            onChanged: (val) {
              setState(() {
                searchAddr = val;
              });
            },
          ),
        ),
      ),
      Positioned(
          top: 150,
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

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15)));
    });
  }
}

/* Container(
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
             ]))), */
