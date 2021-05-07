import 'package:flutter/material.dart';
import 'displayPictureScreen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Favoriter', style: new TextStyle(color: Colors.grey[900],)),
        backgroundColor: Colors.orange[50], // bakgrundsfärg på titel längst upp
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayPictureScreen()),);
              // do something
            },
          )
        ],
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
      ), // bakgrundsfärg på titel längst upp
      body: new Center(
        child:new Text('Favoriter'),
      ),

    );
  }
}