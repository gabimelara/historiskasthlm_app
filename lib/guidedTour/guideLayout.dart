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
  int currentIndex = 0;
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
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
      backgroundColor: Color.fromRGBO(230,236,255,1),
      body: SafeArea(
        child: Stack(children: [
     // body: Column(
       // children: [
       //   Expanded(
        //    child:
            PageView.builder(
              controller: _controller,
              itemCount: dataPage.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
               // return Padding(
                  //padding: const EdgeInsets.all(40),
                  //child: Column(
                    //children: [

                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
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
                     dataPage[i].title,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500, color: Color.fromRGBO(27,32,49,100)),
                    ),
                  ),
                      SizedBox(height:20),
                      Padding(
                          padding: const EdgeInsets.only(  //ny
                            left: 20, right: 20, bottom: 40, top: 0), //ny
                            child: Text(
                            dataPage[i].description,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dataPage.length,
                    (index) => buildDot(index, context),   //ändra design
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromRGBO(104,112, 137, 1),
                  padding: EdgeInsets.symmetric(horizontal: 160, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),

              child: Text(
                  currentIndex == dataPage.length - 1 ? "Starta" : "Nästa"),
              onPressed: () {
                if (currentIndex == dataPage.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyNavigationBar(), //skickar till start sidan, om det står mapScreen kommer inte navigationBar upp
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
           //   style: TextButton.styleFrom(
            //    primary: Colors.white,
             //  backgroundColor:Color.fromRGBO(104,112, 137, 1),
               // textColor: Colors.white,
             //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //  shape: RoundedRectangleBorder(
               //     borderRadius: BorderRadius.circular(20))
             // ),
            ),
            ),
          Positioned(
            left: 195,
            bottom: 740,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromRGBO(104,112, 137, 1),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9))),
              child: new Text("Skippa rundtur"),
              onPressed: () {
             //   if (currentIndex == dataPage.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyNavigationBar(),
                    ),
                  );
               // }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },

          )
          )]),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
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





//  style: TextButton.styleFrom(
//            primary: Colors.white,
//          backgroundColor:Color.fromRGBO(104,112, 137, 1),
// textColor: Colors.white,
//        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(20))
// ),
//),