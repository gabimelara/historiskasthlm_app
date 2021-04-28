import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/FavoritesScreen.dart';
import 'package:historiskasthlm_app/Mapscreen.dart';
import 'package:historiskasthlm_app/NotificationScreen.dart';
import 'package:historiskasthlm_app/SearchScreen.dart';
import 'package:historiskasthlm_app/StartScreen.dart';

//Hello Laris!!

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      // theme: ThemeData(
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _currentIndex = 0; //// skrivs för att ikonen man klickar ska bli större
  final List<Widget> _screens=[
    MapScreen(),
    SearchScreen(),
    FavoriteScreen(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(  //alla ikoner med färg och bakgrund
        selectedItemColor: Colors.deepOrange[900],
        unselectedItemColor: Colors.black,
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop), //Icons.pin_drop eller Icons.map? Vilken är finast?
            title: Text('Karta'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),  //Icons.search eller Icons.image_search? vilken är bäst?
            title: Text('Sök'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            title: Text('Favoriter'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notiser'),
            backgroundColor: Colors.orange[50],
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {  //void som gör att knaparna funkar när man klickar
    setState(() {
      _currentIndex = index;
    });
  }
}
















