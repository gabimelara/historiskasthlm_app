import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
//SÖKButton LAYOUT
class _SearchScreenState extends State<SearchScreen> {//LÄGG DE I EN STACK
  bool showTextField = false;
  Widget _buildFloatingSearchBtn() {
    return Expanded(
      child: FloatingActionButton( //runda knapen
        child: Icon(Icons.search),
        onPressed: () {
          setState(() {
            showTextField = !showTextField;
          });
        },
     // ),
    ));
  }
  Widget _buildTextField() { //textrutan
    return Expanded(
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Search ',
              ),

          onTap: () {
            showTextField = false;
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child:
              Text('Historiska Stockholm',
                  style: TextStyle(color:Colors.grey[900]))),
          backgroundColor: Colors.orange[50],),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1, // icon
                    child: Container(
                    ),
                  ),
                ],
              ),
            ),

                  showTextField ? _buildTextField() :
                  Container(
                  ),
                  _buildFloatingSearchBtn(),
                ],
              ),
            );
  }

}

