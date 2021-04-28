import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();

}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Center(child:Text('Sök', style: TextStyle(color:Colors.grey[900]))),
        backgroundColor: Colors.orange[50],),
      body: new Center(
        child:new Text('This is Search page'),
      ),
    );
  }
}

