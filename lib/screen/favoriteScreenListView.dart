import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';
import 'displayPictureScreen.dart';
import 'favoritesScreen.dart';

class FavoriteScreenListView extends StatefulWidget {
  @override
  _FavoriteScreenListViewState createState() => _FavoriteScreenListViewState();
}

class _FavoriteScreenListViewState extends State<FavoriteScreenListView> {
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

  Container _listViewContainer(){
    return Container(
        height: 600,
        alignment: Alignment.center,
        child: _buildListView()
    );
  }

  Container _imageView(){
    return Container(
          child: _listViewContainer()
      );
  }

  Row _showItemsPref() {
    return Row(
          children: [IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.grid_on_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoriteScreen()),);
              }),
            IconButton(
              icon: Icon(Icons.list_alt_outlined, color: Colors.blueGrey,
                  size: 26.0),
            )]
      );
  }


  ///Listview för Favoriter
  ListView _buildListView(){
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (_, index) {
        return ListTile(
          minVerticalPadding: 40,
          title: Text('Picture item #$index'),
          leading: Image.network('https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss/SSMC002123S.t60a235d2.m600.xrhFT-K09Vg9dGT_Q.jpg'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen()),);
            // do something
          },);
      },
    );
  }
}
