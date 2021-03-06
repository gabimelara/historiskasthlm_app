import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/screen/picsById.dart';
import 'package:historiskasthlm_app/sharedPrefs/addToLikesClass.dart';
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

  void showPopup(int id) {
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
                                                          Positioned(top: 300, left: 280, right: 0,
                                                              child: FavoriteButton(
                                                                isFavorite: true,
                                                                iconColor: Colors.red,
                                                                iconDisabledColor: Colors.white,
                                                                valueChanged: (_isFavorite) {
                                                                  addToLikes(_bildList[index].id);
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
                                                              child: Text( ("??r: " + _bildList[index].year.toString()),
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
                                                                  color: Colors.blueGrey, fontWeight: FontWeight.w400,
                                                                ),
                                                              )),
                                                          subtitle: Padding(
                                                              padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 50),
                                                              child: Text((_bildList[index].block),
                                                                style: TextStyle(fontSize: 15.0, color: Colors.blueGrey,
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
                                                            decorator: DotsDecorator( color: Colors.black87, activeColor: Colors.blueGrey)),
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
  }


getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('favorites');
    return list;
  }

  //TODO: avlikea inne i bild + listview
  //TODO: fixa att bilder inte hinner laddas
  //TODO: flytta hj??rtat till h??ger
  //TODO: ??ndra s?? listview visas f??rst?


  List<picsById> _bildList = [];

  Future<picsById> fetchPicById(String id) async {
    var url = Uri.parse(
        'https://group10-15.pvt.dsv.su.se/demo/files/getById/' + id);
    var response = await http.get(url);
    var bildId;
    if (response.statusCode == 200) {
      var bilderJson = json.decode(utf8.decode(
          response.bodyBytes)); //Ett objekt som ??r kopplat till addressId
      bildId = (picsById.fromJson(bilderJson));
    }
    print(bildId);
    return bildId;
  }

  void loadScreen() {
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
        },);
      }
      _buildListView();
    }
    );
  }

  void initState() {
    loadScreen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              'Favoriter', style: new TextStyle(color: Colors.grey[900],)),
          backgroundColor: Colors.orange[50],
          // bakgrundsf??rg p?? titel l??ngst upp
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ), // bakgrundsf??rg p?? titel l??ngst upp
        body: new Center(
            child: bodyCon()
        )

    );
  }

  Column bodyCon() {
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
    if (pictureView) {
      return Row(
          children: [
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
                alignment: Alignment.center,
                icon: Icon(Icons.grid_on_outlined, color: Colors.black),
                onPressed: () {
                  setState(() {
                    listedPictures = false;
                    pictureView = true;
                  });
                }),
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
          ]
      );
    }
    return Row(
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            icon: Icon(Icons.grid_on_outlined, color: Colors.blueGrey),
              onPressed: () {
                setState(() {
                  pictureView = true;
                });
              }
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
        ]
    );
  }

  ///Listview f??r Favoriter
  ListView _buildListView() {
    return ListView.builder(
        itemCount: _bildList.length,
        itemBuilder: (_, index) {
          return Container(
              padding: new EdgeInsets.only(top: 5, bottom: 10),
              child: ListTile(
                minVerticalPadding: 20,
                minLeadingWidth: 60,
                title: Text(_bildList[index].description, style:
                TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),),
                leading: Image.memory(
                    base64Decode(_bildList[index].image),
                    width: 80,
                    height: 300,
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.fill),
                onTap: () { setState(() {
                  showPopup(_bildList[index].id);
                  print(_bildList[index].id);
                });
                trailing: Icon(Icons.arrow_forward);

                  /*Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => DisplayPictureScreen()),);
           // do something*/
                },));
        });
  }
  ///GridView f??r favoriter
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
                  height: 150,
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.fill),
              onPressed: () {
                setState(() {
                  showPopup(_bildList[index].id);
                  print(_bildList[index].id);
                });
              }
          );
        }
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
      }
    });
  }
}

class PostHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
