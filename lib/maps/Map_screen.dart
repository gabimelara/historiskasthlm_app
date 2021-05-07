import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//KARTASCREEN LAYOUT HÄR

class Map_screen extends StatefulWidget {

  @override
  _Map_screenState createState() => _Map_screenState();

}
class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294,18.0686);
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
    return new Stack(
        children: <Widget>[
          Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                centerTitle: true,
                title: Text('Historiska Stockholm', style: new TextStyle(color:Colors.grey[900],)),
                backgroundColor: Colors.orange[50],

              ),
              body: GoogleMap(
                initialCameraPosition: CameraPosition(target: _initialcameraposition),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,

              )
          ),
          Positioned( //HÄR BÖRJAR SÖKRUTAN
              top: 120,
              right: 15,
              left: 15,
              child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,),
                  child: Row(
                      children: <Widget>[
                        IconButton(
                          splashColor: Colors.grey,
                          icon: Icon(Icons.place),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                                hintText: "Sök..."),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton( splashColor: Colors.grey,
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() { },
                              );
                            },
                          ),
                        )
                      ]
                  )
              )
          )
        ]
    );
  }
}
