
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/main.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Container(
          color: Color(0xffffff),
          height: 200.0,
          alignment: Alignment.center,
          child: Column(children: [
            Container(
                child: Text('Welcome Stockholmer, let\'s explore',
                    style: TextStyle(color: Colors.black, fontSize: 36))),
            Container(
                child: ElevatedButton(
                  onPressed: () => {runApp(MyRealApp())},
                  child: new Text('Start'),
            ))
          ]),
        ),
      ),
    );
  }
}

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
