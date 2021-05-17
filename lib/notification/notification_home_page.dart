import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'routes.dart';

class NotificationHomePage extends StatefulWidget {
  NotificationHomePage({Key key}) : super(key: key);
  final String title = 'Historiska Stockholm';

  @override
  _NotificationHomePageState createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {

  bool _notificationsAllowed = false;
  int _counter = 0;


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

  void cancelAllNotifications(){
    AwesomeNotifications().cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              children: <Widget>[

                SizedBox( height: 20),
                FloatingActionButton.extended(
                    onPressed: () => sendNotification(),
                    label: Text('Skicka Notis')
                ),

                SizedBox( height: 20),

              ]
          ),
        )
    );
  }
}