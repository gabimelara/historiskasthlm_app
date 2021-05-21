import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/guidedTour/guideLayout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_bar.dart';



//Öppnas från GUIDELAYOUT/Laura
class StartScreen extends StatelessWidget {
  bool screenChoice;

_guidedTourShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tourShown = (prefs.getBool('guideShown'));
    //print(tourShown);
    if(tourShown == null){
      prefs.setBool('guideShown', true);
      print('guideShown');
      return screenChoice = false;
    } else{
      print('hej');
      return screenChoice = true;
    }
  }
@override
void initState(){

  screenChoice = _guidedTourShown();

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(169, 186, 157, 1),
      body: Center(
        child: new Container(
          height: 450.0,
          alignment: Alignment.topCenter,
          child: Column(
              children: [
                Container(
                    child: Text('Välkommen Stockholmare,\nbörja utforska!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold))),
                Container(
                  height: 350.0,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Color.fromRGBO(56, 56, 56, 0.8),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13))
                    ),
                    onPressed: () {
                        if(_guidedTourShown()){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyNavigationBar()),);
                      }else {
                         // _guidedTourShown().setBool('guideShown', true);
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Guidade()),
                      );
                      }
                    },

                    child: new Text('Öppna karta',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}