import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/maps/Map_screen.dart';
import 'package:historiskasthlm_app/notification/notification_home_page.dart';
import 'favoritesScreen.dart';

class MyNavigationBar extends StatefulWidget { //Bottom bar class
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  int _currentIndex = 0; //// skrivs för att ikonen man klickar ska bli större
  final List<Widget> _screens=[
    Map_screen(),
    FavoriteScreen(),
    NotificationHomePage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // new (Body består av _Screens som har ett index)
      bottomNavigationBar: BottomNavigationBar(  // Navbar med alla ikoner
        selectedItemColor: Colors.deepOrange[900], //färgar ikonen man har klickat på vinröd
        unselectedItemColor: Colors.black, // de övriga ikonerna som inte är selected är då svarta
        backgroundColor: Colors.orange[50], //bakgrundsgärg på bottomNavigationBar
        onTap: onTabTapped, //Gör att ikoner är klickbara genom en void metod som finns längre ned i koden
        // new
        currentIndex: _currentIndex, // Gör att ikonen färgas varje gång man trycker på den.
        // Utan denna går det att trycka men färgen ändras inte
        items: [ //items som Navigationbar kommer att ha både bakgrund och ikonen
          new BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop), //Karta ikon
            label:('Karta'), //text under ikon
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp), //Hjärta ikon
            label: ('Favoriter'), //text under ikon
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications),  //Notiser ikon
            label: ('Notiser'), // text under ikon
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
