import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
//KARTASCREEN LAYOUT HÄR

class Map_screen extends StatefulWidget {

  @override
  _Map_screenState createState() => _Map_screenState();

}
class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294, 18.0686);
  GoogleMapController _controller;
  Location _location = Location();

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
  Widget build(BuildContext context) {
    return new Stack(
        children: <Widget>[
          Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                centerTitle: true,
                title: Text('Historiska Stockholm',
                    style: new TextStyle(color: Colors.grey[900],)),
                backgroundColor: Colors.orange[50],

              ),
              body: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: _initialcameraposition),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,

              )
          ),
          Positioned( //HÄR BÖRJAR SÖKRUTAN
              top: 70,
              right: 15,
              left: 15,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            //BYTTA KEYBOAD TYPE
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
                          child: IconButton(splashColor: Colors.grey,
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() {},
                              );
                            },
                          ),
                        )
                      ]
                  )
              )
          ),

          Positioned(
              top: 130,
              right: 15,
              left: 15,

              child: new Container(
                height: 73,
                width: 50,
                child:

                ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.transparent,),
                        width: 160.0,
                        height: 5,
                        child: FloatingActionButton.extended(
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30.0))
                            ), label: Text('Adress', style:
                        new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color.fromRGBO(128, 128, 128, 1),
                        ),

                        )

                        ),
                      ),

                      Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.transparent,),
                          width: 160.0,
                          height: 5,
                          child: FloatingActionButton.extended(
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30.0))
                            ), label:
                          Text('År', style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Roboto',
                            color: new Color.fromRGBO(128, 128, 128, 1),
                          )
                          ),

                          )

                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.transparent,),
                          width: 160.0,
                          height: 5,
                          child: FloatingActionButton.extended(
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30.0))
                            ), label:
                          Text('Byggnader', style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Roboto',
                            color: new Color.fromRGBO(128, 128, 128, 1),
                          )
                          ),

                          )

                      ),
                    ]
                ),
              )
          )
        ]
    );
  }
}
