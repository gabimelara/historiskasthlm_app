import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historiskasthlm_app/filtrering/filter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'all_addresses.dart';
import 'bilder.dart';
import 'package:dots_indicator/dots_indicator.dart';

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
  BitmapDescriptor pinLocationIcon;
  List<FilterList> selectFilters = [];
  Set<Marker> markers = Set();
  double pinPillPosition = -100;
  int dotsIndex = 0;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
    });
  }

  List<allAddresses> _addressesList = List<allAddresses>();

  ///ÄNDRA TILL List<allAddresses> _addressesList = [];
  Future<List<allAddresses>> fetchAddresses() async {
    var url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/addresses');
    var response = await http.get(url);
    var addressesList = List<allAddresses>();
    if (response.statusCode == 200) {
      var addressesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var addressParsed in addressesJson) {
        addressesList.add(allAddresses.fromJson(addressParsed));
      }
    }
    return addressesList;
  }


  Future<List<allAddresses>> fetchAddressesFiltered(int start, int end, List<String> tag) async {
    //var url = Uri.parse('http://group10-15.pvt.dsv.su.se/demo/getByFiltering?' + 'start=' + start + '&end=' + end + '&tag=' + tag);
    var url = Uri(scheme: 'https',host: 'group10-15.pvt.dsv.su.se', path: '/demo/getByFiltering/',queryParameters: {'start': start, 'end' : end, 'tag' : tag});
    var response = await http.get(url);
    List <allAddresses> addressesList = [];
    if (response.statusCode == 200) {
      var addressesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var addressParsed in addressesJson) {
        addressesList.add(allAddresses.fromJson(addressParsed));
      }
    }
    return addressesList;
  }

  List<String> test = [];


  List<Bild> _bildList = <Bild>[];

  Future<List<Bild>> fetchBilder(String address) async {
    var url = Uri.parse(
        'https://group10-15.pvt.dsv.su.se/demo/files/getByAddress/' + address);
    var response = await http.get(url);
    var bildList = <Bild>[];
    if (response.statusCode == 200) {
      var bilderJson = json.decode(utf8.decode(response.bodyBytes));
      for (var bildParsed in bilderJson) {
        bildList.add(Bild.fromJson(bildParsed));
      }
    }
    return bildList;
  }

  _showCustomDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: RawScrollbar(
                  isAlwaysShown: true,
                  thumbColor: Colors.grey,
                  radius: Radius.circular(40),
                  thickness: 5,
                  child:
                  Stack(
                      children:
                      <Widget>[
                        Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.only(top: 0),
                            height: 50,
                            width: 350,
                            decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Align(
                                child: Text('Kategorier',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)))),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.only(top: 0),
                                    height: 50,
                                    width: 300,
                                    color: Colors.transparent),

                                Text('År',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 3.0,
                                          )
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))
                                    ),
                                    height: 200,
                                    width: 300,

                                    child: Stack(children:
                                    <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.0, right:5.0,top: 40),
                                          child: TextField(autofocus: false,
                                              style: TextStyle(fontSize: 18.0,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                              decoration: new InputDecoration(
                                                  filled: false,
                                                  fillColor: Colors.white,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          const Radius.circular(
                                                              10.0))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black12,
                                                          width: 2.0),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          const Radius.circular(
                                                              10.0))),
                                                  hintText: 'Sök efter år...',
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15.0, top: 15.0),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(Icons.search),
                                                    onPressed: () async {
                                                    },

                                                  )))),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0, right:5.0,top: 100),
                                        child: TextField(autofocus: false,
                                            style: TextStyle(fontSize: 18.0,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1)),
                                            decoration: new InputDecoration(
                                                filled: false,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0),
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        const Radius.circular(
                                                            10.0))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 2.0),
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        const Radius.circular(
                                                            10.0))),
                                                hintText: 'Sök efter år...',
                                                contentPadding: EdgeInsets.only(
                                                    left: 15.0, top: 15.0),
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.search),
                                                  onPressed: () async {
                                                  },

                                                ))),
                                      )])),


                                Text('Tags',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 3.0,
                                          )
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))
                                    ),
                                    height: 300,
                                    width: 300,

                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: fotografList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String _key = fotografList.keys
                                                  .elementAt(
                                                  index);

                                              return CheckboxListTile(
                                                value: fotografList[_key],
                                                title: Text(_key),

                                                onChanged: (val) {
                                                  setState(() {
                                                    fotografList[_key] = val;
                                                  }

                                                  );
                                                },
                                                activeColor: Colors.blue,
                                                checkColor: Colors.white,


                                              );
                                            },
                                          );
                                        })),

                                SizedBox(height: 12),


                                Padding(
                                  padding: EdgeInsets.only(left: 15.0, right:15.0,top: 0, bottom:5),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color.fromRGBO(3, 3, 3, 1.0))),
                                    onPressed: () => Navigator.of(context).pop(),
                                    color: Color.fromRGBO(3, 3, 3, 1.0),
                                    textColor: Colors.white,
                                    child: Text("   Applicera    ",
                                        style: TextStyle(fontSize: 15)),

                                  ),
                                )],
                            ),

                          ),

                        )
                      ])));
        });
  }
  void updateMapState(var address, String markerValue) {
    markers.add(Marker(
      markerId: MarkerId(address.address),
      position: LatLng(address.latitude, address.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(8),
      onTap: () {
        ///FIXA ontap change color
        markerValue = address.address;
        fetchBilder(markerValue).then((value) {
          _bildList = value;
          showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: "Map",
            barrierColor: Colors.black.withOpacity(0.4),
            transitionDuration: Duration(milliseconds: 600),
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return Align(
                  alignment: Alignment.center,
                  child: Container(

                    ///  alignment: Alignment.center,
                    height: 710,

                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,

                        ///byt till vertical om ni vill
                        padding: EdgeInsets.all(4),
                        itemCount: _bildList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              width: 400,
                              child: Card(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 20, top: 12),
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                  ),
                                  semanticContainer: true,
                                  clipBehavior:
                                  Clip.antiAliasWithSaveLayer,
                                  child: SingleChildScrollView(
                                    //DETTA ÄR NYTT
                                      child: Container(
                                          height: 700,
                                          child: Stack(children: <Widget>[
                                            Positioned(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                        children: <
                                                            Widget>[
                                                          Wrap(
                                                            children: <
                                                                Widget>[
                                                              Image
                                                                  .memory(
                                                                  base64Decode(
                                                                      _bildList[index]
                                                                          .image),
                                                                  height:
                                                                  400,
                                                                  width:
                                                                  400,
                                                                  colorBlendMode:
                                                                  BlendMode
                                                                      .darken,
                                                                  fit: BoxFit
                                                                      .fill),

                                                              ListTile(
                                                                leading: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 0,
                                                                        left: 0,
                                                                        top: 0),
                                                                    child: Text(
                                                                      ("Id:" +
                                                                          _bildList[index]
                                                                              .documentID
                                                                              .toString()),
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 8.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                      ),
                                                                    )),
                                                                subtitle: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 0,
                                                                        left: 120,
                                                                        top: 5,
                                                                        bottom: 20),
                                                                    child: Text(
                                                                      ("År: " +
                                                                          _bildList[index]
                                                                              .year
                                                                              .toString()),
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 17.0,
                                                                        fontStyle: FontStyle
                                                                            .normal,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                      ),
                                                                    )),
                                                              ),
                                                              ListTile(
                                                                title: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 10,
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom: 0),
                                                                    child: Text(
                                                                      (_bildList[index]
                                                                          .description),
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 18.0,
                                                                        fontStyle: FontStyle
                                                                            .normal,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                      ),
                                                                    )),
                                                              ),

                                                              ListTile(
                                                                //child: Icon(Icons.camera_enhance_outlined)),

                                                                subtitle: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 0,
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom: 20),
                                                                    child: Text(
                                                                        ("BY: " +
                                                                            _bildList[index]
                                                                                .photographer),
                                                                        style: TextStyle(
                                                                            fontSize: 15.0,
                                                                            fontStyle: FontStyle
                                                                                .italic,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight: FontWeight
                                                                                .w400))),
                                                              ),

                                                              ListTile(
                                                                title: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 0,
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom: 0),
                                                                    child: Text(
                                                                      (_bildList[index]
                                                                          .district),
                                                                      style:
                                                                      TextStyle(
                                                                        letterSpacing: 2.0,
                                                                        //SKA VI HA DET?
                                                                        fontSize: 15.0,
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                      ),
                                                                    )),
                                                                subtitle: Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right: 0,
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom: 50),
                                                                    child: Text(
                                                                      (_bildList[index]
                                                                          .block),
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 15.0,
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                      ),
                                                                    )),
                                                              ),
                                                            ],
                                                          )
                                                        ])))
                                            ,
                                            Padding(

                                              padding: EdgeInsets.only(
                                                  bottom: 20),
                                              child: Align(
                                                  alignment: Alignment
                                                      .bottomCenter,

                                                  child: DotsIndicator(
                                                    dotsCount: _bildList
                                                        .length,
                                                    position: index,
                                                    decorator: DotsDecorator(
                                                      color: Colors
                                                          .black87,
                                                      activeColor: Colors
                                                          .blueGrey,
                                                    ),
                                                  )

                                              ),
                                            )
                                          ])
                                      ))));
                        }),
                  ));
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                    .animate(anim1),
                child: child,
              );
            },
          );
        });
      },
    ));
  }

  @override
  void initState() {
    String markerValue;

    fetchAddresses().then((value) {
      _addressesList.addAll(value);
      for (var address in _addressesList) {
        setState(() {
          updateMapState(address, markerValue);
        });
      }
    });
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 18)));
    });
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
          CameraPosition(target: _initialcameraposition, zoom: 16),
          onMapCreated: _onMapCreated,
          markers: Set.from(markers),
          // mapType: MapType.hybrid,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
        ),
      ),
      Positioned(
          top: 700,
          right: 320,
          left: 0,
          child: FloatingActionButton(
            backgroundColor: const Color(0xffffffff),
            foregroundColor: Colors.white,
            onPressed: () =>
                _location.onLocationChanged.listen((l) {
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      //BUG NÄR MAN ANVÄNDER DET SÅ GÅR INTE ATT SÖKA PÅ PLATSER
                      CameraPosition(
                          target: LatLng(l.latitude, l.longitude),
                          zoom: 18),
                    ),
                  );
                }),

            // Respond to button press
            child: Icon(Icons.center_focus_strong, color: Colors.black),
          )
        //Positions knappen
      ),
      Positioned(
        top: 150,
        right: 0,
        left: 320,
        child: FloatingActionButton(
          backgroundColor: const Color(0xffffffff),
          foregroundColor: Colors.white,
          onPressed: () => _showCustomDialog(context),
          child: Icon(Icons.filter_list_alt, color: Colors.black),
        ),
      ),


      Positioned(
        //HÄR BÖRJAR SÖKRUTAN
        top: 85,
        right: 15,
        left: 15,
        child: TextField(
          autofocus: false,
          style: TextStyle(fontSize: 20.0, color: Color.fromRGBO(0, 0, 0, 1)),
          decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
                  borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 2.0),
                  borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0))),
              hintText: 'Sök här...',
              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: searchandNavigate,
                iconSize: 35.0,
                color: Colors.black87,
              )),
          onChanged: (val) {
            setState(() {
              searchAddr = val;
            });
          },
        ),
      )
    ]);
  }

}

Map<String, bool> fotografList = {
  'Mathias': false, 'Laris': false, 'Emma': false, 'Gabi': false,
  'Love': false, 'Laura': false, 'Gustaf': false,
  'Ludwig': false, 'Oksana': false, 'Lena': false,
};

