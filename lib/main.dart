import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:historiskasthlm_app/distance.dart';
import 'package:historiskasthlm_app/maps/Map_screen.dart';
import 'package:historiskasthlm_app/maps/map.dart';
import 'package:historiskasthlm_app/screen/startScreen.dart';
import 'package:provider/provider.dart';
import 'maps/geolocator.dart';
import 'notification/routes.dart';



void main() {
  runApp(MyApp());
  theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity);
  SystemChrome.setEnabledSystemUIOverlays([]);
  WidgetsFlutterBinding.ensureInitialized();
  initializeApp();

}
void initializeApp() async{
  AwesomeNotifications().initialize(
      null, // this makes you use your default icon, if you haven't one
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blueAccent,
            ledColor: Colors.white
        )

      ]);
}
class MyApp extends StatelessWidget {
  final geoService = GeolocatorService();
  //WIDGET ÄR APPENS ROT.
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        create: (context) => geoService.getInitialLocation(),
        child:
        MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: Scaffold(body: StartScreen()),
          initialRoute: PAGE_HOME, ///BUG HÄR
          routes: materialRoutes,
        )
    );

  }
}