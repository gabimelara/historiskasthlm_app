
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
          height: 350.0,
          alignment: Alignment.center,
          child: Column(children: [
            Container(
                child: Text('Välkommen Stockholmare, börja utforska',
                    style: TextStyle(color: Colors.white, fontSize: 36))),
            Container(
              height: 200.0,
              alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white),
                  onPressed: () => {runApp(MyRealApp())},

                  child: new Text('Start'),
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
