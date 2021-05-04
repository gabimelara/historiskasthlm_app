import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

class Data {
  final image;
  final title;
  final description;

  Data(
      this.image,
      this.title,
      this.description);
}

class DataPage extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == dataPage.length - 1;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
//HÄR MÅSTE VI HA EN IF SATS SÅ ATT SKICKAR TILL MAPSCREEN
} else
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
  }

  List<Data> dataPage = [
    Data('assets/mobile.jpg', 'Welcome',
        'Låt oss ta en snabb rundtur i appen och alla funktioner du kan hitta i den.'),

    Data('assets/mobile.jpg', 'Platsmarkörer',
        'Den röda cirkeln visar din position så att du alltid vet vilken del av Stockholm du befinner dig i.'),

    Data('assets/mobile.jpg', 'Hitta bilder',
        'Röda kartnålar på kartan visar alla platser där du kan utforska bilder'),

    Data('assets/mobile.jpg', 'Sök efter specifika platser',
        'Sök efter specifika platser eller adresser som du vill utforska! Du kan också ange sökningar efter en fotograf, år eller namn.'),

    Data('assets/mobile.jpg', 'Visa Bilder',
        'Se historiska bilder från en specifik adress genom att trycka på motsvarande kartnål på kartan.'),

    Data('assets/mobile.jpg', 'Zomma in på bilder.',
        'Du kan zooma in på bilder som tagits på en viss adress genom att välja en bild.')
  ];
}

