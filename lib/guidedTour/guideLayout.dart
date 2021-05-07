import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:historiskasthlm_app/guidedTour/guideData.dart';
import 'package:historiskasthlm_app/main.dart';
import 'guideData.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      backgroundColor: Color.fromRGBO(230,236,255,1),   //backgrundsfärgen
      body: SafeArea(
        child: Stack(children: [
  //  IconButton(
   // icon: const Icon(Icons.arrow_back),
              //TODO:
  //  onPressed: () {
   //   if (currentIndex == dataPage.length - 1) {
     //   Navigator.pushReplacement(
      //    context,(_) => Navigator.of(context).pop(),
      //    ),
       // );
     // }
            //  onPressed: (){
             //   Navigator.pop(context);
             // },
             // onPressed:() => Navigator.of(context).pop(),

             // if (currentIndex == dataPage.length - 1) {
               //  Navigator.of(context).pop();
                //Navigator.push(context);
             // },

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(  //hämtar bilden från data klassen
                        dataPage[i].image,
                    //height: 500,

                    //    Image.asset(_controller.dataPage[index].image),
                     //   height: 370,
                      ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 0, top: 5), //RUBRIK
                    child: Text(
                      //RUBRIK
                     dataPage[i].title,  //hämtar titeln från data klassen
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500, color: Color.fromRGBO(27,32,49,100)),
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
            left: 9,
            bottom: 10,
            child: ElevatedButton(  //knapp
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromRGBO(104,112, 137, 1),
                  padding: EdgeInsets.symmetric(horizontal: 160, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),

              child: Text(  //gör att knappen nästa ändras till starta på sista sidan
                  currentIndex == dataPage.length - 1 ? "Starta" : "Nästa"),
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
            left: 205,
            bottom: 760,
            child: TextButton( //knappen högst upp
              style: ElevatedButton.styleFrom(
                  onPrimary: Color.fromRGBO(104,112, 137, 1),
                  primary: Color.fromRGBO(230,236,255,1),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9))),
              child: new Text("Skippa rundtur"),
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
          )]),
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
        color: Color.fromRGBO(104,112, 137, 1),
      ),
    );

  }

}
// Vi bör dock göra en if-sats om guidade tour ska bara visas engång inte varje gång man går in i appen.




