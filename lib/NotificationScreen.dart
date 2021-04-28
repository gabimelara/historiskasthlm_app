import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();

}
//Hej Emma här!!!
class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Center(
        child:new Text('This is Notification page'),
      ),
    );
  }
}