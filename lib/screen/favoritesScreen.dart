import 'package:flutter/material.dart';
import 'displayPictureScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Favoriter', style: new TextStyle(color: Colors.grey[900],)),
        backgroundColor: Colors.orange[50],
        // bakgrundsfärg på titel längst upp
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen()),);
              // do something
            },
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ), // bakgrundsfärg på titel längst upp
      body: new Center(
        child: RaisedButton(
    onPressed: _incrementCounter,
    child: Text('Increment counter'),

        ),

      ),

    );
  }
}
_incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
  print(prefs.getInt('counter'));
}
