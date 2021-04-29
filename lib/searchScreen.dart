import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Picture {
  final String address;
  final String year;
  final String photographer;
  final String location;
  Picture(this.address, this.year, this.photographer, this.location);
}

class SearchScreen extends StatelessWidget {
  Future<List<Picture>> search(String search) async {
    await Future.delayed(
        Duration(seconds: 1)); //Den visar resultatet efter 1 sekund
    return List.generate(search.length, (int index) {
      return Picture(
        "$search $index",
        "1960",
        "Fotograf: Johan Johansson",
        "Stockholm.",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Sök', style: TextStyle(color: Colors.grey[900]))),
        backgroundColor: Colors.orange[50],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Picture>(
            hintText: "Sök...",
            onSearch: search,
            onItemFound: (Picture picture, int index) {
              return ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text(picture.address,
                    style: TextStyle(color: Colors.black, fontSize: 18.0)),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(picture.year),
                      Text(picture.photographer),
                      Text(picture.location),
                    ]),
                trailing: Icon(Icons.favorite, color: Colors.deepOrange[900]),
              );
            },
          ),
        ),
      ),
    );
  }
}

//https://blog.smartnsoft.com/an-automatic-search-bar-in-flutter-flappy-search-bar-a470bc67fa1f
