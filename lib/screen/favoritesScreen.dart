import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/screen/picsById.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool listedPictures = false;
  bool pictureView = false;
  bool liked = false;
  bool showHeartOverlay = false;
  List<String> temp = [];

  getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('favorites');
  return list;
  }

  //TODO: avlikea inne i bild + listview
  //TODO: fixa att bilder inte hinner laddas
  //TODO: skapa bildvy
  //TODO: formatera text osv i listview
  //TODO: ändra så listview visas först

  List<picsById> _bildList = <picsById>[];
  Future<picsById> fetchPicById(String id) async {
    var url = Uri.parse(
        'https://group10-15.pvt.dsv.su.se/demo/files/getById/' + id);
    var response = await http.get(url);
    var bildId;
    if (response.statusCode == 200) {
      var bilderJson = json.decode(utf8.decode(response.bodyBytes)); //Ett objekt som är kopplat till addressId
        bildId = (picsById.fromJson(bilderJson));
    }
    print(bildId);
    return bildId;
  }

  @override
  void initState() {
      getFavorites().then((value) {
          temp.addAll(value);
          print(temp);
          for (String s in temp) {
            setState(() {
              fetchPicById(s).then((value) {
                _bildList.add(value);
                print('andra');
                print(_bildList);
            });
            },);}
          _buildGridView();
      }
      );
  }

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
        itemCount: _bildList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0),
        itemBuilder: (_, index) {
            return IconButton(
              icon: Image.memory(
                base64Decode(_bildList[index].image),
                width: 150,
                height: 150),
                onPressed: () {
                  setState(() {
                    pictureView = true;
                    listedPictures = false;
                  });
                }
              );
          }
        );
  }

  /*List<IconButton> getImageButtons(){
    List<IconButton> list = [];
    for(String s in temp){
      fetchPicById(s).then((value) {
        _bildList = value;
        IconButton icon = new IconButton(
            icon: Image.memory(
                base64Decode(_bildList[].image),
                width: 150,
                height: 150)
        )
      },);
    }

  }*/

  ///Listview för Favoriter
  ListView _buildListView() {
    return ListView.builder(
      itemCount: _bildList.length,
      itemBuilder: (_, index) {
        return ListTile(
          minVerticalPadding: 40,
          title: Text(_bildList[index].description),
          leading: Image.memory(

          base64Decode(_bildList[index].image),
              height: 150),
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
