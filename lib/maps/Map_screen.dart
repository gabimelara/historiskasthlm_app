import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historiskasthlm_app/filtrering/filter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:historiskasthlm_app/maps/tags.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'all_addresses.dart';
import 'bilder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:favorite_button/favorite_button.dart';


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
  bool selected = true;
  static const earliestYear = 1840;

  bool isFiltered = false;
  int prefStart = earliestYear;
  int prefEnd = 2021;
  List<String> filterTaglist;

  addToLikes(int i) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('favorites');

    if (list == null){
      List<String> temp = [];
      list = temp;
    }
    String id = i.toString();
    if (list.contains(id)){
      list.remove(id);
    } else {
      list.add(id);
    }
    await prefs.setStringList('favorites', list);
    print(prefs.getStringList('favorites'));
  }
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
      }}
    return addressesList;
  }

  Future<List<allAddresses>> fetchAddressesFiltered(
      int start, int end, List<String> tag) async {
    var url;
    if (tag.isEmpty) {
      url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/getByFiltering?' +
          'start=' +
          start.toString() +
          '&end=' +
          end.toString());
    } else {
      url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/getByFiltering?' +
          'start=' +
          start.toString() +
          '&end=' +
          end.toString() +
          '&tag=' +
          tag.join(','));
    }
    print(url);
    var response = await http.get(url);
    List<allAddresses> addressesList = [];
    if (response.statusCode == 200) {
      var addressesJson = json.decode(utf8.decode(response.bodyBytes));
      for (var addressParsed in addressesJson) {
        print(addressParsed);
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

  void updateFilterState(int startYear, int endYear, List<String> tagList) {
    List<allAddresses> _filterList = [];
    markers.clear();
    isFiltered = true;
    prefStart = startYear;
    prefEnd = endYear;
    filterTaglist = tagList;
    String markerValue;
    fetchAddressesFiltered(startYear, endYear, tagList).then((value) {
      _filterList.addAll(value);
      for (var address in _filterList) {
        setState(() {
          updateMapState(address, markerValue);
        });
      }
    });
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
  isLiked(int index){
    onLikeButtonTapped;
    addToLikes(_bildList[index].id);
  }

  void updateMapState(var address, String markerValue) {
    markers.add(Marker(
      markerId: MarkerId(address.address),
      position: LatLng(address.latitude, address.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(8),
      onTap: () {
        markerValue = address.address;
        fetchBilder(markerValue).then((value) {
          _bildList = value; // TODO: Filtrera bilderna här?
          if (isFiltered) {
            List<Bild> _filteredBildList = <Bild>[];
            for (Bild b in _bildList) {
              if (b.year > prefStart && b.year < prefEnd) {
                for (Tags t in b.tags) {
                  if (filterTaglist.contains(t.getTagName())) {
                    _filteredBildList.add(b);
                    break;
                  }
                }
              }
            }
            _bildList = _filteredBildList;
            isFiltered = false;
          }
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
                        padding: EdgeInsets.all(4),
                        itemCount: _bildList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              width: 400,
                              child: Card(
                                  margin: EdgeInsets.only(left: 10, right: 20, top: 12),
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  semanticContainer: true,
                                  clipBehavior:
                                  Clip.antiAliasWithSaveLayer,
                                  child: SingleChildScrollView(
                                      child: Container(
                                          height: 700,
                                          child: Stack(children: <Widget>[
                                            Positioned(top: 10, left: 10, right: 10,
                                                child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                        children: <Widget>[
                                                          Wrap(
                                                            children: <Widget>[
                                                              Stack(children: <Widget>[
                                                                Image.memory( base64Decode (_bildList[index].image),
                                                                  height: 350, width: 400,
                                                                  colorBlendMode: BlendMode.darken, fit: BoxFit.fill),
                                                                Positioned(top: 0, left: 0, right: 300,
                                                                    child: IconButton(
                                                                        icon: Icon(Icons.close_outlined, color: Colors.red, size: 30),
                                                                        onPressed: (){
                                                                          Navigator.pop(context);
                                                                        }
                                                                    )),
                                                                Positioned(top: 300, left: 280, right: 0,
                                                                    child: FavoriteButton(
                                                                      isFavorite: true,
                                                                iconColor: Colors.white,
                                                                iconDisabledColor: Colors.red,
                                                                valueChanged: (_isFavorite) {
                                                                  addToLikes(
                                                                      _bildList[index]
                                                                          .id);
                                                                },
                                                              ))]),
                                                              ListTile(
                                                                leading: Padding(
                                                                    padding: EdgeInsets.only(right: 0, left: 0, top: 0),
                                                                    child: Text(
                                                                      ("Id:" + _bildList[index].documentID.toString()),
                                                                      style: TextStyle( fontSize: 8.0, color: Colors.black,
                                                                        fontWeight: FontWeight.w500,),
                                                                    )),
                                                                subtitle: Padding(
                                                                    padding: EdgeInsets.only( right: 0, left: 120, top: 5, bottom: 20),
                                                                    child: Text( ("År: " + _bildList[index].year.toString()),
                                                                      style: TextStyle(
                                                                        fontSize: 17.0,
                                                                        fontStyle: FontStyle.normal,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    )),
                                                              ),
                                                              ListTile(
                                                                title: Padding(
                                                                    padding: EdgeInsets.only(right: 10, left: 0, top: 0, bottom: 0),
                                                                    child: Text((_bildList[index].description),
                                                                      style: TextStyle(fontSize: 18.0,
                                                                        fontStyle: FontStyle.normal,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    )),),

                                                              ListTile(
                                                                subtitle: Padding(
                                                                    padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 20),
                                                                    child: Text(("BY: " + _bildList[index].photographer),
                                                                        style: TextStyle( fontSize: 15.0,  fontStyle: FontStyle.italic,
                                                                            color: Colors.black, fontWeight: FontWeight.w400))),),
                                                              ListTile(
                                                                title: Padding(
                                                                    padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
                                                                    child: Text((_bildList[index].district),
                                                                      style: TextStyle( letterSpacing: 2.0, fontSize: 15.0,
                                                                        color: Colors.black, fontWeight: FontWeight.w400,
                                                                      ),
                                                                    )),
                                                                subtitle: Padding(
                                                                    padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 50),
                                                                    child: Text((_bildList[index].block),
                                                                      style: TextStyle(fontSize: 15.0, color: Colors.black,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    )),
                                                              ),
                                                            ],
                                                          ),

                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 40),
                                                            child: Align( alignment: Alignment.bottomCenter,
                                                              child: DotsIndicator(dotsCount: _bildList.length,
                                                                  position: index,
                                                                  decorator: DotsDecorator( color: Colors.black87, activeColor: Colors.red)),
                                                            ),)])
                                                ))]))
                                  )));}),));},
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
          target: LatLng(result[0].position.latitude, result[0].position.longitude), zoom: 18)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
        ),
      ),
      Positioned(
          top: 600,
          right: 310,
          left: 0,
          child: FloatingActionButton(
            backgroundColor: const Color(0xffffffff),
            foregroundColor: Colors.white,
            onPressed: () =>
                _location.onLocationChanged.listen((l) {
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      //BUG NÄR MAN ANVÄNDER DET SÅ GÅR INTE ATT SÖKA PÅ PLATSER
                      CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 18),
                    ),
                  );
                }),

            // Respond to button press
            child: Icon(Icons.center_focus_strong, color: Colors.black),
          )
      ),
      Positioned(
        top: 500,
        right: 0,
        left: 310,
        child: FloatingActionButton(
          heroTag: Text("filter"),
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

_showCustomDialog(BuildContext context) {
  DateTime _selectedStartDate = DateTime(earliestYear);
  DateTime _selectedEndDate = DateTime.now();
  List<String> _selectedTags = [];
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
                child: Stack(children: <Widget>[
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
                          child: Text('Filtrera',
                              style: TextStyle(
                                  color: Colors.black,
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
                             Text('Sök från år:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          StatefulBuilder(builder: (context, setState) {
                            return Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0),
                                        //(x,y)
                                        blurRadius: 3.0,
                                      )
                                    ],
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                height: 200,
                                width: 300,
                                child: YearPicker(
                                    firstDate: DateTime.utc(earliestYear),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime.utc(earliestYear),
                                    selectedDate: _selectedStartDate,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedStartDate = value;
                                      });
                                     ThemeData(
                                          primaryColor: Colors.red[400],
                                          accentColor: Colors.green[800]);
                                    }));
                          }),
                          Text('Sök till år:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          StatefulBuilder(builder: (context, setState) {
                            return Container(
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
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                height: 200,
                                width: 300,
                                child: YearPicker(
                                    firstDate: DateTime.utc(1750),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    selectedDate: _selectedEndDate,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedEndDate = value;

                                      });
                                    }));
                          }),
                          Text('Tags',
                              style: TextStyle(
                                  color: Colors.black,
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
                                  border: Border.all(color: Colors.black12),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              height: 300,
                              width: 300,
                              child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: fotografList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String _key =
                                        fotografList.keys.elementAt(index);

                                        return CheckboxListTile(
                                          value: fotografList[_key],
                                          title: Text(_key),
                                          onChanged: (val) {
                                            setState(() {
                                              fotografList[_key] = val;
                                            });
                                          },
                                          activeColor: Colors.deepOrange,
                                          checkColor: Colors.white,
                                        );
                                      },
                                    );
                                  })),
                          SizedBox(height: 12),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 0, bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget> [
                                  SizedBox(
                                    width: 5,
                                  ),
                              Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child:
                                  ElevatedButton(
                                    onPressed: (){
                                      initState();
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(20.0),
                                    ),),
                                    child:  Text("Rensa",
                                        style: TextStyle(fontSize: 15)),)),
                                  ElevatedButton(
                                    onPressed: () {
                                      fotografList.forEach((key, value) {
                                        if (value == true) {
                                          _selectedTags.add(key);
                                        }
                                      }
                                      );
                                      updateFilterState(_selectedStartDate.year,
                                          _selectedEndDate.year, _selectedTags);
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(20.0),
                                    ),),
                                    child: Text("Applicera",
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                ])));
      });
}
}

Map<String, bool> fotografList = {
  'Offentliga evenemang': false,
  'Folkliv': false,
  'Folksamlingar': false,
  'Torg': false,
  'Butiker': false,
  'Hotell': false,
  'Spårvagnar': false,
  'Dragkärror': false,
  'Skulpturer': false,
  'Hästfordon': false,
  'Reklam': false,
  'Fasader': false,
  'Gatubelysning': false,
  'Gatubeläggning': false,
  'Gatumiljöer': false,
  'Skyltar': false,
  'Plank': false,
  'Varuhus': false,
  'Cyklar': false,
  'Bilar': false,
  'Hållplatser': false,
  'Huvudbonader': false,
  'Flerbostadshus': false,
  'Trähusbebyggelse': false,
  'Barn': false,
  'Byggnader': false,
  'Parker': false,
  'Gator': false,
  'Stenhusbebyggelse': false,
  'Kläder': false,
};