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
    Data('assets/1.png', 'Välkommen',
        'Låt oss ta en snabb rundtur i appen och alla funktioner du kan hitta i den.'),

    Data('assets/2.png', 'Hitta bilder',
        'Röda kartnålar på kartan visar alla platser där du kan utforska bilder'),

    Data('assets/3.png', 'Position',
        'Den blåa cirkeln visar din position så att du alltid vet i vilken del av Stockholm du befinner dig.'),

    Data('assets/4.png', 'Sök efter specifika platser',
        'Specifika platser eller adresser som du vill utforska!'),

    Data('assets/5.png', 'Filtrera sökning',
        'Filtrera dina sökningar efter år eller tags.'),

    Data('assets/6.png', 'Visa bilder',
        'Se historiska bilder från en specifik adress genom att trycka på motsvarande kartnål på kartan.'),

    Data('assets/7.png', 'Favoriter',
        'Du kan gilla dina favoritbilder.'),

  ];
