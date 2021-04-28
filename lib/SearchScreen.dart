import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child:Text('Sök', style: TextStyle(color:Colors.grey[900]))),
   backgroundColor: Colors.orange[50],),
   body: SafeArea(
   child:Padding(
   padding: const EdgeInsets.symmetric(horizontal: 20),
   child: SearchBar(),
   ),
   ),
   );
 }
}


