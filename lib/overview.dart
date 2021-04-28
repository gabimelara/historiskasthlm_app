import 'package:historiskasthlm_app/buttons.dart';
import 'package:historiskasthlm_app/data.dart';
import 'package:flutter/material.dart';

//här har vi innehållet till sidorna.
final List<Data> data = [
  Data(
      description:
      "Låt oss ta en snabb rundtur i appen och alla funktioner du kan hitta i den.",
      title: "Välkommen",
      thumbnail: "assets/mobil.jpeg",
      backgroundColor: Colors.blueGrey),
  Data(
      description:
      "Den röda cirkeln visar din position så att du alltid vet vilken del av Stockholm du befinner dig i",
      title: "Platsmarkörer",
      thumbnail: "assets/kron.jpeg",
      backgroundColor: Colors.blueGrey),
  Data(
      description:
      "Röda kartnålar på kartan visar alla platser där du kan utforska bilder",
      title: "Hitta bilder",
      thumbnail: "assets/images.jpeg",
      backgroundColor: Colors.blueGrey),

  Data(
      description:
      "Sök efter specifika platser eller adresser som du vill utforska! Du kan också ange sökningar efter en fotograf, år eller namn. ",
      title: "Sök efter specifika platser",
      thumbnail: "assets/",
      backgroundColor: Colors.blueGrey),

  Data(
      description:
      "Se historiska bilder från en specifik adress genom att trycka på motsvarande kartnål på kartan.",
      title: "Visa bilder",
      thumbnail: "assets/kron.jpeg",
      backgroundColor: Colors.blueGrey),

  Data(
      description:
      "Du kan zooma in på bilder som tagits på en viss adress genom att välja en bild.",
      title: "Zomma in på bilder",
      thumbnail: "assets/kron.jpeg",
      backgroundColor: Colors.blueGrey),
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> /*with ChangeNotifier*/ {
  final _controller = PageController();
  int _currentIndex = 0;

//här har vi layouten
  @override
  Widget build(BuildContext context) {
    return Container(
        color: data[_currentIndex].backgroundColor,
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              color: data[_currentIndex].backgroundColor,
              alignment: Alignment.center,
              child: Column(children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _controller,
                                  onPageChanged: (value) {
                                    // _painter.changeIndex(value);
                                    setState(() {
                                      _currentIndex = value;
                                    });
                                    //notifyListeners();
                                  },
                                  children: data
                                      .map((e) => DataPage(data: e))
                                      .toList())),
                          flex: 4),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(vertical: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(data.length,
                                            (index) => createCircle(index: index)),
                                  )),
                              BottomButtons(
                                currentIndex: _currentIndex,
                                dataLength: data.length,
                                controller: _controller,
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            )));
  }
//PRICKARNA
  createCircle({int index}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 50),
        margin: EdgeInsets.only(right: 8), //avståndet mellan prickarna
        height: 6,
        width: _currentIndex == index ? 15 : 5, //här kan man bestämma om man vill ha streckar eller prickar
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3))); //FÄRG PÅ PRICKARNA
  }
}
