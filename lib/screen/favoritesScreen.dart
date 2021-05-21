import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';
import 'displayPictureScreen.dart';
import 'favoriteScreenListView.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool listedPictures = false;
  ///Potentiell Lista för favoriter
  List<allAddresses> favorites;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Favoriter', style: new TextStyle(color: Colors.grey[900],)),
        backgroundColor: Colors.orange[50],
        // bakgrundsfärg på titel längst upp
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ), // bakgrundsfärg på titel längst upp
      body: new Center(
        child: Column(
          children: [
            Container(
              height: 50,
                child: _showItemsPref()),
            Container(
              height: 600,
                child: _imageView())])
     )

    );
  }

  Container _imageView(){
    return Container(
        child: _buildGridView()
    );
  }

  Row _showItemsPref() {
    return Row(
          children: <Widget>[
            IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.grid_on_outlined, color: Colors.blueGrey),
            ),
            IconButton(
                icon: Icon(Icons.list_alt_outlined, color: Colors.black,
                    size: 26.0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteScreenListView()));
                }
            )
          ]
      );
    }
  }

  ///GridView för favoriter
  GridView _buildGridView(){
    return GridView.builder(
        itemCount: 27,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0),
        itemBuilder: (_, index){
          return IconButton(
            icon: Image.network('https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss/SSMC002123S.t60a235d2.m600.xrhFT-K09Vg9dGT_Q.jpg', width: 150, height: 150),
            /*onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FavoriteScreenListView()));
            }*/);
        });
  }
