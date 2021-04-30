import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();

}

class _MapScreenState extends State<MapScreen> {
  @override
 Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
       // centerTitle:true,
       // title: Center (child:Text('Historiska Stockholm', style: TextStyle(color:Colors.grey[900]))),
       // backgroundColor: Colors.orange[50],),
     // body: new Center(
       // child:new Text('Karta'),
      ),
    );
  }
}