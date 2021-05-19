import 'package:fluster/fluster.dart';
import 'dart:convert';
import 'dart:core';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

//KARTASCREEN LAYOUT HÄR
//https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

/*
Vad fetchAddresses gör är att hämta innehållet som finns på den angivna länken (url). Det innehållet består av en json-fil, det vill säga ett objekt som innehåller
adresser samt koordinater. For-loopen styckar sedan upp innehållet till flera objekt baserat på de kriterier som finns i
modell-klassen (allAddresses, ligger längst ner) och lägger dessa i en lista (addressList).

Efter detta måste de uppstyckade objekten omvandlas till pins och läggas i ett set, vilket görs i initState-metoden.
Metoden i sig bestämmer vad för information som ska finnas med initialt på sidan. Vad metoden först gör är att kalla på fetchAddresses-metoden
för att kopiera listan (addressList) som returnerats därifrån till en egen lista (_addressesList).
Själva setState (tror jag) är där det som initialt ska finnas med på sidan definieras, vilket i vårt fall är att vi vill omvandla alla element till pins och lägga dessa
i ett set. For-loopen fungerar ungefär likadant som den i fetchAddresses, men här vill vi ta varje objekt i listan (_addressesList) och ha dess adress (address.address)
som ID för markern samt att koordinaterna bestämmer var markern kommer placeras. När markern är skapad läggs den i ett set (markers), eftersom Google - vid utplacering
av multipla markers - kräver att dessa ligger i just ett set. I bodyn finns en sats (markers: Set.from(markers)) som säger att det är i "markers" våra markers finns.

Modell-klassen (allAddresses) ligger längst ner i Map_screen. Eftersom filen som hämtas från databasen är just en fil som måste delas upp har vi modellklassen, som i sig
berättar vad i filen som avser ett enskilt objekt (alltså efter vilka kriterier filen ska delas upp). Den styckar även upp det enskilda objektets innehåll och placerar
detta i variabler så att det uppstyckade objektet i sig innehåller variabler med dess unika data. I vårt fall består det uppstyckade objektet av en adress, latitude,
longitude samt en array (bilder, används dock ej för något). För extra övertydlighet ser varje objekts rådata ut så här när det hämtats från databasen:
{"address":"Medborgarplatsen","latitude":59.31433730000001,"longitude":18.0735509,"bilder":[]}
När vi sedan styckar upp objektet i fetchAddresses for-loop, kommer variabeln address innehålla "Medborgarplatsen", latitude "59.31433730000001", longitude "18.0735509"
och bilder (den tomma) arrayen.

Test-klassen "Databasobjekt_som_text" (ligger i mappen test_klasser) visar hur objekten ser ut som text och är förmodligen lite enklare att förstå!

 */ //Övertydlig beskrivning av hur data hämtas från databas och omvandlas till pins

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
  List<allAddresses> ads;
  Fluster<allAddresses> fluster;

  /// [Fluster] instance used to manage the clusters
  Fluster<allAddresses> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

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
      Fluster<allAddresses> fluster = Fluster<allAddresses>(
          minZoom: 0,
          maxZoom: 20,
          radius: 150,
          extent: 2048,
          nodeSize: 64,
          points: ads,
          createCluster: (BaseCluster cluster, double longitude, double latitude)
          => allAddresses(
            markerId: cluster.id.toString(),
            position: LatLng(latitude, longitude),
            isCluster: cluster.isCluster,
            clusterId: cluster.id,
            pointsSize: cluster.pointsSize,
            childMarkerId: cluster.childMarkerId,
          ));
    }
    );
  }

  //https://www.coletiv.com/blog/how-to-cluster-markers-on-google-maps-using-flutter/
  //https://pub.dev/packages/google_maps_cluster_manager/example
  //https://medium.com/coletiv-stories/how-to-cluster-markers-on-flutter-google-maps-44620f607de3

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
    final updatedMarkers = getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    Future<List<Marker>> getClusterMarkers(
        Fluster<allAddresses> clusterManager,
        double currentZoom,
        Color clusterColor,
        Color clusterTextColor,
        int clusterWidth,
        ) {
      if (clusterManager == null) return Future.value([]);

      return Future.wait(clusterManager.clusters(
        [-180, -85, 180, 85],
        currentZoom.toInt(),
      ).map((mapMarker) async {
        if (mapMarker.isCluster != null) {
          mapMarker.icon = await _getClusterMarker(
            mapMarker.pointsSize != null,
            clusterColor,
            clusterTextColor,
            clusterWidth,
          );
        }

        return mapMarker.toMarker();
      }).toList());  }
    final List<Marker> googleMarkers = fluster
        .clusters([-180, -85, 180, 85], 16)
        .map((cluster) => cluster.toMarker())
        .toList();
    fetchAddresses().then((value) {
      ads.addAll(value);
      for(var address in ads) {
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
              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: searchandNavigate,
                iconSize: 35.0, color: Colors.black87,)),
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

class allAddresses extends Clusterable{
  String address;
  double latitude;
  double longitude;
  List<Null> bilder;
  LatLng position;
  Icon icon;

  allAddresses({this.address, this.latitude, this.longitude, markerId,  isCluster = false, clusterId, pointsSize, childMarkerId, position, this.icon}):

  super(
  markerId: address,
  latitude: latitude,
  longitude: longitude,
  isCluster: isCluster,
  clusterId: clusterId,
  pointsSize: pointsSize,
  childMarkerId: childMarkerId,
  );

  allAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['bilder'] != null) {
      bilder = [];
    } //kopplade bilder
  }

  Marker toMarker() => Marker(
    markerId: MarkerId(address),
    position: LatLng(
      latitude,
      longitude,
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(10),
  );

  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }  //kopplade bilder*/
}