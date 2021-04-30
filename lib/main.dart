import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historiskasthlm_app/favoritesScreen.dart';
import 'package:historiskasthlm_app/notificationScreen.dart';
import 'package:historiskasthlm_app/searchScreen.dart';
import 'overview.dart';
//import 'package:historiskasthlm_app/mapScreen.dart';
//import 'package:flutter/services.dart';
void main() {
  runApp(MyApp());
  // hide status bar
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  //WIDGET ÄR APPENS ROT.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        // APPENS THEME

        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white), //RUBRIKEN
          bodyText1: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold), // NÄSTA KNAPP
          bodyText2: TextStyle(
              fontSize: 20.0, height: 1.3, color: Colors.white, fontWeight: FontWeight.w200), //SKIPP KANPP
          button: TextStyle(
              fontSize: 20, color: Colors.pink, fontWeight: FontWeight.w700), //NU KÖR VI KNAPP
        ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body:HomePage()),
    );

  }

//@override
//Widget build(BuildContext context) {
//return MaterialApp(
//  home: StartScreen(),
// theme: ThemeData(
//);
}
class GoogleScreen extends StatefulWidget {
  @override
  _GoogleScreenState createState() => _GoogleScreenState();
//HEj  ..... .Gabriela
}
class _GoogleScreenState extends State<GoogleScreen> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(59.324554, 18.070520);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
 @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Historiska Stockholm', style: new TextStyle(color:Colors.grey[900],)),
          backgroundColor: Colors.orange[50]
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
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
    GoogleScreen(),
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
            label:('Karta'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),  //Icons.search eller Icons.image_search? vilken är bäst?
            label: ('Sök'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            label: ('Favoriter'),
            backgroundColor: Colors.orange[50],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: ('Notiser'),
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