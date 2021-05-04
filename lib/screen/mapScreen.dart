import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//KARTASCREEN LAYOUT HÄR

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();

}
class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(59.324554, 18.070520);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Historiska Stockholm', style: new TextStyle(color:Colors.grey[900],)),
          backgroundColor: Colors.orange[50]
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}



