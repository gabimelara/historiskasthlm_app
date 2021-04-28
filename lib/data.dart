import 'package:flutter/material.dart';


class Data {
  final String title;
  final String description;
  final String thumbnail;
  final Color backgroundColor;

  Data(
      {this.title, this.description, this.thumbnail, this.backgroundColor});
}

class DataPage extends StatelessWidget {
  final Data data;

  DataPage({this.data});

  @override //layouten
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 500,
            height: 250,
            margin: EdgeInsets.only(top: 24, bottom: 16),
            child:
            Image.asset('assets/mobile.png'),//BUG vi vill inte lägga till bara en bild.
            //height: MediaQuery.of(context).size.height * 0.33,
            alignment: Alignment.center),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    data.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
