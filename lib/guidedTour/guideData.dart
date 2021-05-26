class Data {
  final image;
  final title;
  final description;

  Data(
      this.image,
      this.title,
      this.description);
}

  List<Data> dataPage = [
    Data('assets/välkommen.png', 'Välkommen',
        'Låt oss ta en snabb rundtur i appen och alla funktioner du kan hitta i den.'),

    Data('assets/pins.png', 'Platsmarkörer', ///TODO
        'Den röda cirkeln visar din position så att du alltid vet vilken del av Stockholm du befinner dig i.'),

    Data('assets/pins.png', 'Hitta bilder',
        'Röda kartnålar på kartan visar alla platser där du kan utforska bilder'),

    Data('assets/sökplatser.png', 'Sök efter specifika platser',
        'Specifika platser eller adresser som du vill utforska!'),

    Data('assets/filtreraBilder.png', 'Filtrera sökning',
        'Filtrea dina sökningar efter år eller tags.'),

    Data('assets/visabilder.jpg', 'Visa bilder', ///TODO
        'Se historiska bilder från en specifik adress genom att trycka på motsvarande kartnål på kartan.'),

    Data('assets/zooma.jpg', 'Notifikationer.',///TODO
        'Du kan få notiser när du är nära en bild.')
  ];
