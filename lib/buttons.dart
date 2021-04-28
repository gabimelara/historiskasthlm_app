import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/main.dart';
import 'package:historiskasthlm_app/mapScreen.dart';
import 'package:historiskasthlm_app/mapScreen.dart';
import 'package:historiskasthlm_app/overview.dart';
import 'mapScreen.dart';

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key key, this.currentIndex, this.dataLength, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
        currentIndex == dataLength - 1
        ? [
        Expanded(
          child: ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 40.0,
              ),

              child:  //DropdownButton( //dropdown meny behöver en lista för att fungerar
              // List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow), //färg på nu kör vi knapp
                    enableFeedback: true, //ljud när man klickar
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (context)=> MyNavigationBar()); //måste ändra till MapScreen
                    Navigator.push(context, route);
                  },

                  child: Container(
                      child: Text(
                        "Nu kör vi!",
                        style: Theme.of(context).textTheme.button,
                      )))),
        )
        ]
            : [
    ElevatedButton( //kan ändras till TextButton
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green), //färg på nu kör vi knapp
    enableFeedback: true, //ljud när man klickar
    ),
    onPressed: () {
    Route route = MaterialPageRoute(builder: (context)=> MyNavigationBar()); //måste ändra till MapScreen
    Navigator.push(context, route);
    },
    child: Text(
    "Skip",
    style: Theme.of(context).textTheme.bodyText2,
    ),
    ),
    Row(
    children: [
    ElevatedButton(
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green), //färg på nu kör vi knapp
    enableFeedback: true, //ljud när man klickar
    ),
    onPressed: () {
    controller.nextPage(
    duration: Duration(milliseconds: 100),
    curve: Curves.easeInOut);
    },
    child: Text(
    "Nästa",
    style: Theme.of(context).textTheme.bodyText1,
    ),
    ),
    //Container(
    //alignment: Alignment.center,
    //child: Icon(
    //Icons.arrow_right_alt, //pilen till nästa sidan.
    //color: Colors.orange,
    //))
    ],
    )
    ],
    );
  }
}
