import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/guidedTour/guideLayout.dart';



//Öppnas från GUIDELAYOUT/Laura
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: new Container(
          height: 450.0,
          alignment: Alignment.topCenter,
          child: Stack(
              children: [
                Positioned(right: 0,left: 0,top: 0, bottom: 150,
                  child: Container(
                  height:350,
                    child: Image.asset('assets/logo_black.png'))),
                  Positioned( top:300, right: 20, left: 20, bottom: 10,
                  child: Container(
                    height: 350.0,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 115, vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Guidade()),
                      );
                    },

                    child: new Text('Start',
                        style: TextStyle(color: Colors.orange[50], fontSize: 20)),
                  ),
                ),
                )]),
        ),
      ),
    );
  }
}