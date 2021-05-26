import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:historiskasthlm_app/screen/navigation_bar.dart';


import 'guideData.dart';

/// Vi bör dock göra en if-sats om guidade tour ska bara visas engång inte varje gång man går in i appen.

class Guidade extends StatefulWidget {
  @override
  _GuidadeState createState() => _GuidadeState();
}

class _GuidadeState extends State<Guidade> {
  int currentIndex = 0;        //skapar en index
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0); //startar index första sidan
    super.initState();
  }

  @override
  void dispose() { //osäkert vad detta gör
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],   //backgrundsfärgen
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
              controller: _controller,
              itemCount: dataPage.length,
              onPageChanged: (int index) {
                setState(() {            //gör att man kan byta sidorna
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(  //hämtar bilden från data klassen
                        dataPage[i].image,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 0, top: 5), //RUBRIK
                        child: Text(
                          //RUBRIK
                          dataPage[i].title,  //hämtar titeln från data klassen
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      SizedBox(height:20),
                      Padding(
                          padding: const EdgeInsets.only(  //ny
                              left: 20, right: 20, bottom: 40, top: 0), //ny
                          child: Text(
                            dataPage[i].description,  //hämtar beskrivningen från data klassen
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )
                      )],
                  ),
                );
              }),

          Positioned(
            bottom:30,
            left: 146,
            height: 100,
            child: Row(  //skapar prickarna
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dataPage.length,
                    (index) => buildDot(index, context),   //gör att prickarna ändras när man byter sida
              ),
            ),
          ),
          Positioned(
            left: 42,
            bottom: 20,
            child: ElevatedButton(  //knapp
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),

              //gör att knappen nästa ändras till starta på sista sidan
              child: Text(
                  currentIndex == dataPage.length - 1 ? "Starta" : "Nästa",
              style: TextStyle(color: Colors.orange[50])),
              onPressed: () {
                if (currentIndex == dataPage.length - 1) { //if satsen som gör att man kan navigera med  starta knappen till kartan/startsidan
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyNavigationBar(), //skickar till startsidan
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100), //tid
                  curve: Curves.bounceIn,
                );
              },

            ),
          ),

          Positioned(
              left: 240,
              bottom: 740,
              child: TextButton( //knappen högst upp
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[50],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
                child: new Text("Skippa rundtur",style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyNavigationBar(), //skickar direk till startsidan
                    ),
                  );

                  _controller.nextPage(
                    duration: Duration(milliseconds: 100), //tid
                    curve: Curves.bounceIn,
                  );
                },

              )
          ),
          Positioned(
              left: 0,
              bottom: 740,
              child: TextButton( //knappen högst upp
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[50],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
                child: Text(
                    currentIndex == dataPage.length + 1 ? "Tillbaka" : "Tillbaka",style: TextStyle(color: Colors.black)),
                onPressed: () {
                  if (currentIndex == dataPage.length + 1) {
                  }
                  _controller.previousPage(
                    duration: Duration(milliseconds: 100), //tid
                    curve: Curves.bounceIn,
                  );
                },

              )
          )
        ]),
      ),
    );
  }


  Container buildDot(int index, BuildContext context) {  //dekoration av prickarna.
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
    );

  }

}

