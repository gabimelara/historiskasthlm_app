import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
//Denna klass visar hur de uppdelade objekten ser ut i textformat.

class Databasobjekt_som_text extends StatefulWidget {
  @override
  _Databasobjekt_som_text createState() => _Databasobjekt_som_text();
}

class _Databasobjekt_som_text extends State<Databasobjekt_som_text> {
  List<allAddresses> _addressesList = List<allAddresses>(); //field för att representera adresserna i UI

  Future<List<allAddresses>> fetchAddresses() async {
    var url = Uri.parse('https://group10-15.pvt.dsv.su.se/demo/addresses');
    var response = await http.get(url);
    var addressesList = List<allAddresses>();  //[]
    if(response.statusCode == 200) {
      var addressesJson = json.decode(response.body); //kodar om responsen från json till en map
      for(var add in addressesJson){
        addressesList.add(allAddresses.fromJson(add));
      }
    }
    return addressesList;
  }
  @override
  void initState(){
    fetchAddresses().then((value) {
      setState(() {
        _addressesList.addAll(value);
      });
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
          body:
          ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                  child: Column(
                      children: <Widget>[
                        Text(_addressesList[index].address),
                        Text(_addressesList[index].latitude.toString()),
                        Text(_addressesList[index].longitude.toString()),

                      ]
                  )
              );
            },
            itemCount: _addressesList.length,
          )
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