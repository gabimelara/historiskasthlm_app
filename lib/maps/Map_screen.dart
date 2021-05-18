import 'dart:convert';
import 'dart:core';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {


      //   _controller.animateCamera(
      //    CameraUpdate.newCameraPosition(
      //
      // CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15);
      //   ),
      // );
      // });

      // LatLng latLngA = new LatLng(12.3456789,98.7654321);
      // LatLng latLngB = new LatLng(98.7654321,12.3456789);
      //
      // Location locationA = new Location();
      // locationA.setLatitude(latLngA.latitude);
      // locationA.setLongitude(latLngA.longitude);
      //
      // Location locationB = new Location();
      // locationB.setLatitude(latLngB.latitude);
      // locationB.setLongitude(latLngB.longitude);
      //
      // double distance = locationA.distanceTo(locationB);;
    }
    );
    _location.onLocationChanged.listen((l) {
      //   _controller.animateCamera(
      //    CameraUpdate.newCameraPosition(
      //
      // CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15);
      //   ),
      // );
      // });

      // LatLng latLngA = new LatLng(12.3456789,98.7654321);
      // LatLng latLngB = new LatLng(98.7654321,12.3456789);
      //
      // Location locationA = new Location();
      // locationA.setLatitude(latLngA.latitude);
      // locationA.setLongitude(latLngA.longitude);
      //
      // Location locationB = new Location();
      // locationB.setLatitude(latLngB.latitude);
      // locationB.setLongitude(latLngB.longitude);
      //
      // double distance = locationA.distanceTo(locationB);;
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

  @override
  void initState() {
    String markerValue;
    fetchAddresses().then((value) {
      _addressesList.addAll(value);
      for (var address in _addressesList) {
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(address.address),
            position: LatLng(address.latitude, address.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(10),
            onTap: () {
              ///FIXA ontap change color
              markerValue = address.address;
              fetchBilder(markerValue).then((value) {
                _bildList = value;
                // print("address: " +
                //     address.address +
                //     "\nmarkerValue: " +
                //     markerValue +
                //     "\nvalue: " +
                //     value.toString() +
                //     "\ndesc: " +
                //     value[0].description);
                showGeneralDialog(
                  barrierDismissible: true,
                  barrierLabel: "Map",
                  barrierColor: Colors.black.withOpacity(0.4),
                  transitionDuration: Duration(milliseconds: 500),
                  context: context,
                  pageBuilder: (context, anim1, anim2) {
                    return Align(
                      //alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 700,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, ///byt till vertical om ni vill
                            padding: EdgeInsets.all(20),
                            itemCount: _bildList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  width: 370,
                                  child: Card(
                                      child: Wrap(
                                        children: <Widget>[
                                      Image.memory(base64Decode(
                                      _bildList[index].image)),
                                          ListTile(
                                            title: Text((_bildList[index].description),
                                              style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),),
                                          )
                                        ],
                                      )
                                  )


                              );
                            },
                          ),

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
        });
      }
    });
  }

  //super.initState();

  List<allAddresses> _addressesList = List<allAddresses>();
  ///ÄNDRA TILL List<allAddresses> _addressesList = [];
  Future<List<allAddresses>> fetchAddresses() async {
    var url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/addresses');
    var response = await http.get(url);
    var addressesList = List<allAddresses>();
    if (response.statusCode == 200) {
      var addressesJson = json.decode(response.body);
      for (var addressParsed in addressesJson) {
        addressesList.add(allAddresses.fromJson(addressParsed));
      }
    }
    return addressesList;
  }
  @override
  void initState(){
    fetchAddresses().then((value) {
      _addressesList.addAll(value);
      for(var address in _addressesList) {
        setState(() {
          markers.add(
              Marker(
                markerId: MarkerId(address.address),
                position: LatLng(address.latitude, address.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(10),
                onTap: () {     ///FIXA ontap change color
                  showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: "Map",
                    barrierColor: Colors.black.withOpacity(0.4),
                    transitionDuration: Duration(milliseconds: 500),
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 600,
                            width: 380,
                            margin: EdgeInsets.only(
                                bottom: 100, left: 12, right: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    20.0))),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                  height: 520,
                                  width: 320,
                                  child: Image.network(
                                      'https://group10-15.pvt.dsv.su.se/demo/files/3183',
                                      fit: BoxFit.fill)

                                ///FÖR ATT HANTERA FLER ÄN 1 BILD KAN VI ANVÄNDA LIST
                              ),
                              margin: EdgeInsets.only(
                                  bottom: 40, left: 12, right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),
                            ),
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
                },

              )
          );
        }
        );
      }
    });
  }
  //super.initState();



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
          initialCameraPosition: CameraPosition(
              target: _initialcameraposition, zoom: 16),
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
          top: 650,
          right: 320,
          left: 0,
          child: FloatingActionButton(
            backgroundColor: const Color(0xffffffff),
            foregroundColor: Colors.white,
            onPressed: () =>
                _location.onLocationChanged.listen((l) {
                  _controller.animateCamera(
                    CameraUpdate
                        .newCameraPosition( //BUG NÄR MAN ANVÄNDER DET SÅ GÅR INTE ATT SÖKA PÅ PLATSER
                      CameraPosition(
                          target: LatLng(l.latitude, l.longitude), zoom: 15),
                    ),
                  );
                }
                ),
            // Respond to button press
            child: Icon(Icons.center_focus_strong, color: Colors.grey),

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
          onPressed: _openFilterDialog,
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
                  borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 2.0),
                  borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0))),
              hintText: 'Sök här...',
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
                iconSize: 35.0, color: Colors.black87,)),
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
    ]
    );
  }

/*  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Din plats"),
        position: LatLng(59.3294, 18.0686),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Stockholm"),
      ),
    ].toSet();
  }*/
      )
    ]);
  }

/*  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Din plats"),
        position: LatLng(59.3294, 18.0686),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Stockholm"),
      ),
    ].toSet();
  }*/

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 12)));
    });
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<FilterList>(
      context,
      listData: filterList,
      selectedListData: selectFilters,
      applyButonTextBackgroundColor: Colors.blueGrey,
      applyButtonTextStyle: TextStyle(color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20),
      controlButtonTextStyle: TextStyle(color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20),
      height: 600,
      hideHeaderText: true,
      hideCloseIcon: true,
      //headlineText: "Välj filtrering",
      searchFieldHintText: "Filtrera här...",
      choiceChipLabel: (item) {
        return item.filter;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },

      onItemSearch: (list, text) {
        if (list != null) {
          if (list.any((element) =>
              element.filter.toLowerCase().contains(text.toLowerCase()))) {
            /// return list which contains matches
            return list
                .where((element) =>
                element.filter.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        }

  void _openFilterDialog() async {
    await FilterListDialog.display<FilterList>(
      context,
      listData: filterList,
      selectedListData: selectFilters,
      applyButonTextBackgroundColor: Colors.blueGrey,
      applyButtonTextStyle: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
      controlButtonTextStyle: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
      height: 600,
      hideHeaderText: true,
      hideCloseIcon: true,
      //headlineText: "Välj filtrering",
      searchFieldHintText: "Filtrera här...",
      choiceChipLabel: (item) {
        return item.filter;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },

      onItemSearch: (list, text) {
        if (list != null) {
          if (list.any((element) =>
              element.filter.toLowerCase().contains(text.toLowerCase()))) {
            /// return list which contains matches
            return list
                .where((element) =>
                element.filter.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        }

        return [];
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectFilters = List.from(list);
        });
        Navigator.pop(context);
      },

    );
  }

}

class FilterList {
  final String filter;
  FilterList({this.filter});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<FilterList> filterList = [
  FilterList(filter: "1990"),
  FilterList(filter: "1900 "),
  FilterList(filter: "1995 "),
  FilterList(filter: "1994 "),
  FilterList(filter: "Persson"),
  FilterList(filter: "1992 "),
  FilterList(filter: "1986 "),

];
class allAddresses {
  String address;
  double latitude;
  double longitude;
  List<Null> bilder;

  allAddresses({this.address, this.latitude, this.longitude});

  allAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['bilder'] != null) {
      bilder = new List<Null>();

    } //kopplade bilder
  }
        return [];
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectFilters = List.from(list);
        });
        Navigator.pop(context);
      },
    );
  }
}

class FilterList {
  final String filter;

  FilterList({this.filter});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<FilterList> filterList = [
  FilterList(filter: "1990"),
  FilterList(filter: "1900 "),
  FilterList(filter: "1995 "),
  FilterList(filter: "1994 "),
  FilterList(filter: "Persson"),
  FilterList(filter: "1992 "),
  FilterList(filter: "1986 "),
];

class allAddresses {
  String address;
  double latitude;
  double longitude;
  List<Null> bilder;

  allAddresses({this.address, this.latitude, this.longitude});

  allAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['bilder'] != null) {
      bilder = new List<Null>();
    } //kopplade bilder
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  } //kopplade bilder
}

class Bild {
  int id;
  String image;
  int year;
  String description;
  String documentID;
  String photographer;
  String licence;
  String block;
  String district;
  List<Tags> tags;
  List<allAddresses> addresses;

  Bild(
      {this.id,
        this.image,
        this.year,
        this.description,
        this.documentID,
        this.photographer,
        this.licence,
        this.block,
        this.district,
        this.tags,
        this.addresses});

  Bild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    year = json['year'];
    description = json['description'];
    documentID = json['documentID'];
    photographer = json['photographer'];
    licence = json['licence'];
    block = json['block'];
    district = json['district'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = new List<allAddresses>();
      json['addresses'].forEach((v) {
        addresses.add(new allAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['year'] = this.year;
    data['description'] = this.description;
    data['documentID'] = this.documentID;
    data['photographer'] = this.photographer;
    data['licence'] = this.licence;
    data['block'] = this.block;
    data['district'] = this.district;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  String tag;
  List<Null> bilder;

  Tags({this.tag, this.bilder});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }  //kopplade bilder
}
  Tags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    if (json['bilder'] != null) {
      bilder = new List<Null>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    // if (this.bilder != null) {
    //   data['bilder'] = this.bilder.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}