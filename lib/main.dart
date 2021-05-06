import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:historiskasthlm_app/screen/favoritesScreen.dart';
import 'package:historiskasthlm_app/screen/map_screen.dart';
import 'package:historiskasthlm_app/screen/notificationScreen.dart';
import 'package:historiskasthlm_app/screen/searchScreen.dart';
import 'package:historiskasthlm_app/screen/startScreen.dart';
import 'package:provider/provider.dart';

import 'maps/geolocator.dart';
void main() {
  runApp(MyApp());
  // hide status bar
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  final geoService = GeolocatorService();
  //WIDGET ÄR APPENS ROT.
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        create: (context) => geoService.getInitialLocation(),
        child:
        MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              accentColor: Colors.orange[50],
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white), //RUBRIKEN
                        bodyText1: TextStyle(
                          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                bodyText2: TextStyle(
                    fontSize: 20.0, height: 1.3, color: Colors.white, fontWeight: FontWeight.w200), //SKIPP KANPP
                      button: TextStyle(
                          fontSize: 20, color: Colors.pink, fontWeight: FontWeight.w700), //NU KÖR VI KNAPP
     ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
      ),
          home: Scaffold(body:StartScreen()),
    )
    );

  }

//@override
//Widget build(BuildContext context) {
//return MaterialApp(
//  home: StartScreen(),
// theme: ThemeData(
//);
}

class MyNavigationBar extends StatefulWidget { //Bottombar class
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  int _currentIndex = 0; //// skrivs för att ikonen man klickar ska bli större
  final List<Widget> _screens=[
    Map_screen(),
    SearchScreen(),
    FavoriteScreen(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // new (Body består av _Screens som har ett index)
      bottomNavigationBar: BottomNavigationBar(  // Navbar med alla ikoner
        selectedItemColor: Colors.deepOrange[900], //färgar ikonen man har klickat på vinröd
        unselectedItemColor: Colors.black, // de övriga ikonerna som inte är selected är då svarta
        onTap: onTabTapped, //Gör att ikoner är klickbara genom en void metod som finns längre ned i koden
        // new
        currentIndex: _currentIndex, // Gör att ikonen färgas varje gång man trycker på den.
                                    // Utan denna går det att trycka men färgen ändras inte
        items: [ //items som Navigationbar kommer att ha både bakgrund och ikonen
          new BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop), //Karta ikon
            label:('Karta'), //text under ikon
            backgroundColor: Colors.orange[50], //Bakgrundsfärg
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search), //Sök ikon
            label: ('Sök'), //text under ikon
            backgroundColor: Colors.orange[50], //Bakgrundsfärg
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp), //Hjärta ikon
            label: ('Favoriter'), //text under ikon
            backgroundColor: Colors.orange[50], //Bakgrundsfärg
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications),  //Notiser ikon
            label: ('Notiser'), // text under ikon
            backgroundColor: Colors.orange[50], //Bakgrundsfärg
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {  //void som gör att knaparna funkar när man klickar och byter till de olika sidorna som finns.
    setState(() {
      _currentIndex = index; //kopplar det till currentIndex body som finns
    });
  }
}