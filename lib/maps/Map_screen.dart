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
  List<Year> selectYear = [];


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
          initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 15),
          onMapCreated: _onMapCreated,
          // mapType: MapType.hybrid,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,


        ),
      ),
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
                  CameraUpdate.newCameraPosition( //BUG NÄR MAN ANVÄNDER DET SÅ GÅR INTE ATT SÖKA PÅ PLATSER
                    CameraPosition(
                        target: LatLng(l.latitude, l.longitude), zoom: 15),
                  ),
                );
              })),
        ),
      ),
      Positioned(
          top: 150,
          right: 0,
          left: 320,
          child: CircleAvatar(
            //Positions knappen
            radius: 30,
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            child: IconButton(
              icon: Icon(Icons.filter_list_alt),
              color: Colors.black,
              onPressed: _openFilterDialog,
            ),
          )
      ),


      Positioned(
        //HÄR BÖRJAR SÖKRUTAN
        top: 85,
        right: 15,
        left: 15,
        child: TextField(
          autofocus: false,
          style: TextStyle(fontSize: 20.0, color: Color.fromRGBO(0, 0, 0, 1)),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Sök...',
              border: new OutlineInputBorder(
                borderSide: BorderSide.none,
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
  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15)));
    });
  }
  void _openFilterDialog() async {
    await FilterListDialog.display<Year>(
      context,
      listData: userList,
      selectedListData: selectYear,
      height: 480,
      headlineText: "Välj årtal",
      searchFieldHintText: "Sök",
      choiceChipLabel: (item) {
        return item.artal;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },

      onItemSearch: (list, text) {
        if (list != null) {
          if (list.any((element) =>
              element.artal.toLowerCase().contains(text.toLowerCase()))) {
            /// return list which contains matches
            return list
                .where((element) =>
                element.artal.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        }

        return [];
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectYear = List.from(list);
        });
        Navigator.pop(context);
      },

    );
  }
}
class Year {   //hårdkodad klass för att se om det funkar
  final String artal;
  final String avatar;
  Year({this.artal, this.avatar});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<Year> userList = [
  Year(artal: "1990"),
  Year(artal: "1900 "),
  Year(artal: "1995 "),
  Year(artal: "1994 "),
  Year(artal: "1989"),
  Year(artal: "1992 "),
  Year(artal: "1986 "),

];
