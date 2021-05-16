import 'package:filter_list/filter_list.dart';
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
  BitmapDescriptor pinLocationIcon;
  List<FilterList> selectFilters = [];


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
          initialCameraPosition: CameraPosition(
              target: _initialcameraposition, zoom: 15),
          onMapCreated: _onMapCreated,
          markers: _createMarker(),
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
            child: Icon(Icons.center_focus_strong,color: Colors.grey),

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
            child: Icon(Icons.filter_list_alt,color: Colors.black),

            ),
          ),

      Positioned( ///DET SKA BORT SEN NÄR VI HAR KOPPLAT IHOP VÅRA PINS MED "BILD DIALOGEN"
          top: 246,
          right: 37,
          left: 320,
          child: FloatingActionButton(
            backgroundColor: const Color(0xffffff66),
            foregroundColor: Colors.transparent,
            onPressed: () {

              ///HÄR BÖRJAR BILD SCREEN
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
                      margin: EdgeInsets.only(bottom: 100, left: 12, right: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: 520,
                          width: 320,
                          child: Image.network('https://group10-15.pvt.dsv.su.se/demo/files/3183',
                                  fit: BoxFit.fill) ///FÖR ATT HANTERA FLER ÄN 1 BILD KAN VI ANVÄNDA LIST
                      ),
                      margin: EdgeInsets.only(bottom: 40, left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
            child: Icon(Icons.add_location_outlined ,color: Colors.black),
          )
      ),
      Positioned(
        //HÄR BÖRJAR SÖKRUTAN
        top: 85,
        right: 15,
        left: 15,
        child: TextField(
          autofocus: false,
          style: TextStyle(fontSize: 20.0, color: Color.fromRGBO(0, 0, 0, 1)), ///INPUT FÄRG
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Sök här...',
              border: new OutlineInputBorder(
                borderSide: const BorderSide(width: 1.0, ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
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
      )
    ]
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Din plats"),
        position: LatLng(59.3294, 18.0686),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Stockholm"),
      ),
    ].toSet();
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15)));
    });
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<FilterList>(
        context,
      listData: filterList,
      selectedListData: selectFilters,
      applyButonTextBackgroundColor: Colors.blueGrey,
      applyButtonTextStyle:  TextStyle(color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 20),
      controlButtonTextStyle: TextStyle(color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20),
      height: 600,
      hideHeaderText: true,
      hideCloseIcon :true,
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
