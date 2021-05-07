import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


//KARTASCREEN LAYOUT HÄR

class Map_screen extends StatefulWidget {

  @override
  _Map_screenState createState() => _Map_screenState();

}
class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294, 18.0686);
  GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr)

  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Historiska Stockholm', style: new TextStyle(color:Colors.grey[900],)),
          backgroundColor: Colors.orange[50],

        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialcameraposition),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,

        )

    );


  }
}
