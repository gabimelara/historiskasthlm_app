import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/screen/picsById.dart';
import 'package:historiskasthlm_app/sharedPrefs/addToLikesClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


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

              child: ScrollablePositionedList.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  initialScrollIndex: id,
                  ///byt till vertical om ni vill
                  padding: EdgeInsets.all(4),
                  itemCount: _bildList.length,

                  itemBuilder: (BuildContext context, int index) {

                    return Container(
                        width: 400,
                        child: Card(
                            margin: EdgeInsets.only(
                                left: 10, right: 20, top: 12),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20.0),
                            ),
                            semanticContainer: true,
                            clipBehavior:
                            Clip.antiAliasWithSaveLayer,
                            child: SingleChildScrollView(
                              //DETTA ÄR NYTT
                                child: Container(
                                    height: 700,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                          child: Container(
                                              color: Colors.white,
                                              child: Column(
                                                  children: <
                                                      Widget>[
                                                    Wrap(
                                                      children: <
                                                          Widget>[
                                                        Image.memory(
                                                            base64Decode(_bildList[index]
                                                                .image),
                                                            height:
                                                            400,
                                                            width:
                                                            400,
                                                            colorBlendMode:
                                                            BlendMode
                                                                .darken,
                                                            fit: BoxFit
                                                                .fill),
                                                        IconButton(
                                                          icon: Icon(Icons.auto_awesome),
                                                          onPressed: () => addToLikes(_bildList[index].id),
                                                          iconSize: 35.0,
                                                          color: Colors.black87,
                                                        ),
                                                        ListTile(
                                                          leading: Padding(
                                                              padding: EdgeInsets.only(right: 0, left: 0, top: 0),
                                                              child: Text(
                                                                ("Id:" +
                                                                    _bildList[index].documentID.toString()),
                                                                style:
                                                                TextStyle(
                                                                  fontSize: 8.0,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              )),
                                                          subtitle: Padding(
                                                              padding: EdgeInsets.only(right: 0, left: 120, top: 5, bottom:20),
                                                              child: Text(
                                                                ("År: " + _bildList[index].year.toString()),
                                                                style:
                                                                TextStyle(
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
                                                              child: Text(
                                                                (_bildList[index].description),
                                                                style:
                                                                TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontStyle: FontStyle.normal,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              )),
                                                        ),

                                                        ListTile(
                                                          //child: Icon(Icons.camera_enhance_outlined)),

                                                          subtitle: Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: 0, left: 0, top: 0, bottom: 20),
                                                              child: Text(
                                                                  ("BY: " + _bildList[index].photographer),
                                                                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, color: Colors.black, fontWeight: FontWeight.w400))),
                                                        ),

                                                        ListTile(
                                                          title: Padding(
                                                              padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
                                                              child: Text(
                                                                (_bildList[index].district),
                                                                style:
                                                                TextStyle(
                                                                  letterSpacing: 2.0,  //SKA VI HA DET?
                                                                  fontSize: 15.0,
                                                                  color: Colors.blueGrey,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              )),
                                                          subtitle: Padding(
                                                              padding: EdgeInsets.only(right: 0, left: 0, top: 0, bottom:50),
                                                              child: Text(
                                                                (_bildList[index].block),
                                                                style:
                                                                TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors.blueGrey,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ])))
                                      ,
                                      Padding(

                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Align(
                                            alignment: Alignment. bottomCenter,

                                            child: DotsIndicator(
                                              dotsCount: _bildList.length,
                                              position: index,
                                              decorator: DotsDecorator(
                                                color: Colors.black87,
                                                activeColor: Colors.blueGrey,
                                              ),
                                            )

                                        ),
                                      )])
                                ))));
                  }),
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
  }

  getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('favorites');
    return list;
  }

  //TODO: avlikea inne i bild + listview
  //TODO: fixa att bilder inte hinner laddas
  //TODO: formatera text osv i listview
  //TODO: ändra så listview visas först


  List<picsById> _bildList = [];

  Future<picsById> fetchPicById(String id) async {
    var url = Uri.parse(
        'https://group10-15.pvt.dsv.su.se/demo/files/getById/' + id);
    var response = await http.get(url);
    var bildId;
    if (response.statusCode == 200) {
      var bilderJson = json.decode(utf8.decode(
          response.bodyBytes)); //Ett objekt som är kopplat till addressId
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
      _buildGridView();
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
    if (pictureView) {
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
                });
              })
        ]
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
                  showPopup(index);
                  // jumpTo(_bildList[index].id);
                  print(index.toString());
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
          onTap: () { setState(() {
            showPopup(index);
            // jumpTo(_bildList[index].id);
            print(index.toString());
          });
          trailing: Icon(Icons.arrow_forward);

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