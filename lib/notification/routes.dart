import 'package:flutter/material.dart';
import 'package:historiskasthlm_app/screen/startScreen.dart';
import 'notification_home_page.dart';
import 'details_page.dart';

const String PAGE_HOME = '/';
const String PAGE_NOTIFICATION_DETAILS = '/notification-details';

Map<String, WidgetBuilder> materialRoutes = {

  PAGE_HOME: (context) => StartScreen(),
  PAGE_NOTIFICATION_DETAILS: (context) => NotificationDetailsPage(ModalRoute.of(context).settings.arguments),
};
