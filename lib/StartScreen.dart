
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/main.dart';

//Öppnas från main /Laura
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(169, 186, 157, 1),
      body: Center(
        child: new Container(
          height: 400.0,
          alignment: Alignment.topCenter,
          child: Column(children: [
            Container(
                child: Text('Välkommen Stockholmare,\nbörja utforska!',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
            Container(
              height: 300.0,
              alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color.fromRGBO(56, 56, 56, 0.8),
                    ),
                  onPressed: () => {runApp(MyRealApp())},

                  child: new Text('Öppna karta',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
            ),
          ]),
        ),
      ),
    );
  }
}

//Öppnar MyApp i main /Laura
class MyRealApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Historiska Stockholm',
      home: MyNavigationBar(),
      // theme: ThemeData(
    );
  }
}
