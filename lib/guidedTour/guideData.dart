class Data {
  final image;
  final title;
  final description;

  Data(
      this.image,
      this.title,
      this.description);
}

//class DataPage extends GetxController {
 // var selectedPageIndex = 0.obs;
 // bool get isLastPage => selectedPageIndex.value == dataPage.length - 1;  //ska inte denna defineras som false eller true här?
 // var pageController = PageController();

  //forwardAction() {
   // if (isLastPage)
    //  MyNavigationBar();
   // else
   // {
    //  pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
  // ((  }
 //}

  List<Data> dataPage = [
    Data('assets/välkommen.jpg', 'Välkommen',
        'Låt oss ta en snabb rundtur i appen och alla funktioner du kan hitta i den.'),

    Data('assets/platsmarkör.jpg', 'Platsmarkörer',
        'Den röda cirkeln visar din position så att du alltid vet vilken del av Stockholm du befinner dig i.'),

    Data('assets/hittaPins.jpg', 'Hitta bilder',
        'Röda kartnålar på kartan visar alla platser där du kan utforska bilder'),

    Data('assets/sökplatser.jpg', 'Sök efter specifika platser',
        'Specifika platser eller adresser som du vill utforska!'),

    Data('assets/filtreraBilder.jpg', 'Filtrera bilder',
        'Filtrea dina sökningar efter en fotograf, år eller namn.'),

    Data('assets/visabilder.jpg', 'Visa bilder',
        'Se historiska bilder från en specifik adress genom att trycka på motsvarande kartnål på kartan.'),

    Data('assets/zooma.jpg', 'Zomma in på bilder.',
        'Du kan zooma in på bilder som tagits på en viss adress genom att välja en bild.')
  ];
//}


//}

