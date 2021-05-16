import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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



 */ //Övertydlig beskrivning av hur data hämtas från databas och omvandlas till pins

class Map_screen extends StatefulWidget {
  @override
  _Map_screenState createState() => _Map_screenState();
}

class _Map_screenState extends State<Map_screen> {
  LatLng _initialcameraposition = LatLng(59.3294, 18.0686);
  GoogleMapController _controller;
  Location _location = Location();
  Set<Marker> markers = Set();

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
  List<allAddresses> _addressesList = List<allAddresses>(); //field för att representera adresserna i UI
  /*
@url - länken till vår databas.
@response - innehållet som skickats tillbaka från databasen.
@addressesList - lista med databasens innehåll parsed/uppdelat till objekt
@If-sats - kollar statuskoden på innehållet (response) och om statuskoden är 200 betyder det att det inte blivit något fel vid hämtningen,
utan att rätt objekt har hämtats.
@addressesJson - sparar innehållet avkodat så det är i rätt format för att använda i flutter.
@for-loop - innehållet delas upp till mindre objekt efter en modell (allAddresses), och lägger till i listan addressesList.
 */
  Future<List<allAddresses>> fetchAddresses() async {
    var url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/addresses');
    var response = await http.get(url);
    var addressesList = List<allAddresses>();
    if(response.statusCode == 200) {
      var addressesJson = json.decode(response.body);
      for(var addressParsed in addressesJson){
        addressesList.add(allAddresses.fromJson(addressParsed));
      }
    }
    return addressesList;
  }
  /*
  @initState - avser hur appens initiala tillstånd ska vara.
  @_addressesList - kopierar innehållet från addressesList.
  @for-loop - för varje objekt (address) i listan (_addressesList) skapas en marker, där objektets adress (address.address)
  blir markerns ID och latitude & longitude (address.latitude respektive address.longitude) berättar var markern ska placeras.
  Markern placeras sen i ett set (markers).
   */
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
                icon: BitmapDescriptor.defaultMarkerWithHue(14),
              ));
        });
      }
    });
    super.initState();
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
              target: _initialcameraposition),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: Set.from(markers),
        ),
      ),
      Positioned(
        //HÄR BÖRJAR SÖKRUTAN
          top: 70,
          right: 15,
          left: 15,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(children: <Widget>[
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Sök..."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(
                            () {},
                      );
                    },
                  ),
                )
              ]))),
      Positioned(
          top: 130,
          right: 15,
          left: 15,
          child: new Container(
            height: 73,
            width: 50,
            child:
            ListView(scrollDirection: Axis.horizontal, children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.transparent,
                ),
                width: 160.0,
                height: 5,
                child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0))),
                    label: Text(
                      'Adress',
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        color: new Color.fromRGBO(128, 128, 128, 1),
                      ),
                    )),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.transparent,
                  ),
                  width: 160.0,
                  height: 5,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0))),
                    label: Text('År',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color.fromRGBO(128, 128, 128, 1),
                        )),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 34.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.transparent,
                  ),
                  width: 160.0,
                  height: 5,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0))),
                    label: Text('Byggnader',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color.fromRGBO(128, 128, 128, 1),
                        )),
                  )),
            ]),
          ))
    ]);
  }
}

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
  }  //kopplade bilder
}


/*
Aggregering/klustring av pins:
https://developers.google.com/maps/documentation/android-sdk/utility/marker-clustering

Koppla data till pin:
https://developers.google.com/maps/documentation/android-sdk/marker#associate_data_with_a_marker

Gömma pins:
https://stackoverflow.com/questions/14507821/is-it-possible-to-show-hide-markers-in-android-google-maps-api-v2

Custom pin pop-up:
https://www.youtube.com/watch?v=DhYofrJPzlI&ab_channel=CodingWithMitch
https://developers.google.com/maps/documentation/android-sdk/infowindows#custom_info_windows

Marker customization:
https://developers.google.com/maps/documentation/android-sdk/marker#customize_a_marker


 */

//https://www.youtube.com/watch?v=lNqEfnnmoHk
//https://www.geoapify.com/map-marker-icons-generator-create-beautiful-icons-for-your-map
//https://www.youtube.com/watch?v=acjtWVc_7sc

