import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/notification/routes.dart';

class NotificationScreen extends StatefulWidget {

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  bool _toggled1 = false;
  bool _notificationsAllowed = true;
  int _counter = 0;

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: Text('Notifikationer', style: new TextStyle(color:Colors.grey[900],)),
          backgroundColor: Colors.orange[50]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => cancelAllNotifications(),
           child: Text('    Cancel notification    ')),

          SwitchListTile(
            title: const Text('Stänga av notiser'),
            //     secondary: const FlutterLogo(),
            activeColor:_toggled1
                ? Colors.deepOrange[900]: Theme.of(context).accentColor,
            value: _toggled1,
            onChanged: (value) {
              setState(() => _toggled1 = value);
              if ( _toggled1 != false) {
                setState(() => cancelAllNotifications());
              }
              },

          ),


          FloatingActionButton.extended(
              backgroundColor: Colors.black,
              onPressed: () => sendNotification(),
              label: Text('Skicka test notis')
    ),

          ]

      ),
    );
  }
  @override
  void initState() {

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      _notificationsAllowed = isAllowed;
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Here you get the token every time its changed by firebase process or by a new installation
    AwesomeNotifications().fcmTokenStream.listen((String newFcmToken) {
      print("New FCM token: "+newFcmToken);
    });

    AwesomeNotifications().createdStream.listen((ReceivedNotification notification) {
      print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().displayedStream.listen((ReceivedNotification notification) {
      print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().dismissedStream.listen((ReceivedAction dismissedAction) {
      print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
    });

    AwesomeNotifications().actionStream.listen((ReceivedAction action){
      print("Action received!");

      // Avoid to open the notification details page twice
      Navigator.pushNamedAndRemoveUntil(
          context,
          PAGE_NOTIFICATION_DETAILS,
              (route) => (route.settings.name != PAGE_NOTIFICATION_DETAILS) || route.isFirst,
          arguments: action
      );

    });

    //initializeFirebaseService();

    super.initState();
  }
  void sendNotification() async {

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 100,
            channelKey: "basic_channel",
            title: "En gammal gård i Stockholm",
            body: "En gammal gård i Stockholm på 1800",
            notificationLayout: NotificationLayout.BigPicture,
            largeIcon: "https://group10-15.pvt.dsv.su.se/demo/files/3183",
            bigPicture: "https://group10-15.pvt.dsv.su.se/demo/files/3183",
            showWhen: true,
            autoCancel: true,
            payload: {
              "secret": "Historiska"
            }
        )

    );

  }
  @override
  void dispose() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }
}
