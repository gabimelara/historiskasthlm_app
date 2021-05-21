import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool listedPictures = false;
  bool pictureView = false;
  bool liked = false;
  bool showHeartOverlay = false;

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
            child: bodyCon()
        )

    );
  }

  Column bodyCon() {
    if (pictureView) {
      return Column(
        children: [
          Container(
              height: 50,
              child: _showItemsPref()),
          Container(
              height: 600,
              child: pictureViewScreen())
        ]
      );
    }
    return Column(
        children: [
          Container(
              height: 50,
              child: _showItemsPref()),
          Container(
              height: 600,
              child: _imageView())
        ]
      );
  }

  Container _imageView() {
    if (listedPictures) {
      return Container(
          child: _buildListView()
      );
    }
    return Container(
        child: _buildGridView()
    );
  }

  Row _showItemsPref() {
    if(pictureView){
      return Row(
          children: [IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.grid_on_outlined, color: Colors.black),
              onPressed: () {
                setState(() {
                  listedPictures = false;
                  pictureView = false;
                });
              }),
            IconButton(
              icon: Icon(Icons.list_alt_outlined, color: Colors.black,
                  size: 26.0),
                  onPressed: () {
                    setState(() {
                      listedPictures = true;
                      pictureView = false;
                  });
                }
            ),
            IconButton(
              icon: Icon(Icons.image, color: Colors.blueGrey, size: 26.0)
            )
          ]
      );
    }
    if (listedPictures) {
      return Row(
          children: [
            IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.grid_on_outlined, color: Colors.black),
              onPressed: () {
                setState(() {
                  listedPictures = false;
                });
              }),
            IconButton(
              icon: Icon(Icons.list_alt_outlined, color: Colors.blueGrey,
                  size: 26.0),
            ),
            IconButton(
                icon: Icon(Icons.image, color: Colors.black, size: 26.0)
            )
          ]
      );
    }
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
                setState(() {
                  listedPictures = true;
                });
              }
          ),
          IconButton(
              icon: Icon(Icons.image, color: Colors.black, size: 26.0),
              onPressed: () {
                setState(() {
                  listedPictures = true;
              });})]
    );
  }


  ///GridView för favoriter
  GridView _buildGridView() {
    return GridView.builder(
        itemCount: 27,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0),
        itemBuilder: (_, index) {
          return IconButton(
            icon: Image.network(
                'https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss/SSMC002123S.t60a235d2.m600.xrhFT-K09Vg9dGT_Q.jpg',
                width: 150, height: 150),
            /*onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FavoriteScreenListView()));
            }*/);
        });
  }

  ///Listview för Favoriter
  ListView _buildListView() {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (_, index) {
        return ListTile(
          minVerticalPadding: 40,
          title: Text('Picture item #$index'),
          leading: Image.network(
              'https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss/SSMC002123S.t60a235d2.m600.xrhFT-K09Vg9dGT_Q.jpg'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            setState(() {
              pictureView = true;
              listedPictures = false;
            });
            /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen()),);
            // do something*/
          },);
      },
    );
  }

  Column pictureViewScreen() {
    return Column(children:
    [
      PostHeader(),
      GestureDetector(
          onDoubleTap: () => _doubleTapped(),
          child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.network(
                    'https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss/SSMC002123S.t60a235d2.m600.xrhFT-K09Vg9dGT_Q.jpg'),
                showHeartOverlay
                    ? Icon(Icons.favorite, color: Colors.white, size: 80.0)
                    : Container()
              ]
          )
      ),
      ListTile(
          leading: IconButton(
            padding: EdgeInsets.fromLTRB(330.0, 0.0, 0.0, 0.0),
            iconSize: 40.0,
            icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.grey,),
            onPressed: () => _pressed(),
          )
      ),
      Container(
          child: Text('Årtal: XXXX\nFotograf: \nStockholm',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              ))
      )
    ]
    );
  }
  _pressed() {
    setState(() {
      liked = !liked;
    });
  }
  _doubleTapped() {
    setState(() {
      showHeartOverlay = true;
      liked = true;
      if (showHeartOverlay) {
        Timer(const Duration(milliseconds: 150), () {
          setState(() {
            showHeartOverlay = false;
          });
        });
      }});
  }

}

class PostHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
        padding: EdgeInsets.all(10.0),
        child:
        Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(160.0, 0.0, 0.0, 0.0),
              child: Text('Address',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold
                  )
              )
          )
        ])
    );
  }
}
