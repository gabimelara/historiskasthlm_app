import 'dart:async';
import 'package:flutter/material.dart';

class Picture {
  final String address;
  final String year;
  final String photographer;
  final String location;
  bool liked = false;
  Picture(this.address, this.year, this.photographer, this.location);
}

class DisplayPictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            centerTitle: true,
            title: Text('Mina favoriter', style: new TextStyle(color:Colors.grey[900],)),
            backgroundColor: Colors.orange[50]
        ),
        body: Post()
    );
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

class Post extends StatefulWidget{
  @override
  PostState createState() => new PostState();

}

class PostState extends State<Post> {
  bool liked = false;
  bool showHeartOverlay = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              PostHeader(),
              GestureDetector(
                  onDoubleTap: () => _doubleTapped(),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.network(
                            'https://digitalastadsmuseet.stockholm.se/fotoweb/cache/5021/Skiss_1/1043/SSMASW003492S.t60507314.m2048.xw7kxel8YWJe-7_AW.jpg'),
                        showHeartOverlay
                            ? Icon(Icons.favorite, color: Colors.white, size: 80.0)
                            : Container()]
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
            ])
    );
  }
}