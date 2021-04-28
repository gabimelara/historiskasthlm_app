import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Center(
        child:new Text('This is Favorite  page'),
      ),
    );
  }
}