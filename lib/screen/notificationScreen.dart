import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  bool _toggled1 = false;
  bool _toggled2 = false;
  bool _toggled3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Notifikationer', style: new TextStyle(color:Colors.grey[900],)),
          backgroundColor: Colors.orange[50]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Rekommenderade platser'),
            //     secondary: const FlutterLogo(),
            activeColor:_toggled1
                ? Colors.deepOrange[900]: Theme.of(context).accentColor,
            value: _toggled1,
            onChanged: (value) {
              setState(() => _toggled1 = value);
            },
          ),
          SwitchListTile(
            title: const Text('Platser i närheten'),
            // secondary: const Icon(Icons.settings), // Point to Check
            activeColor:_toggled2
                ? Colors.deepOrange[900]: Theme.of(context).accentColor,
            value: _toggled2,
            onChanged: (value) {
              setState(() => _toggled2 = value);
            },
          ),
          SwitchListTile(
            title: const Text('Tidigare besökta platser'),
            activeColor:_toggled3
                ? Colors.deepOrange[900]: Theme.of(context).accentColor,
            value: _toggled3,
            onChanged: (value) {
              setState(() => _toggled3 = value);
            },
          ),
        ],
      ),
    );
  }
}