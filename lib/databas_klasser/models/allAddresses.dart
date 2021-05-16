class allAddresses {
  String address;
  double latitude;
  double longitude;
  //List<Null> bilder;

  allAddresses({this.address, this.latitude, this.longitude});

  allAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    /*if (json['bilder'] != null) {
      bilder = new List<Null>();
      json['bilder'].forEach((v) {
        bilder.add(new Null.fromJson(v));
      });
    }*/ //kopplade bilder
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    /*  if (this.bilder != null) {
      data['bilder'] = this.bilder.map((v) => v.toJson()).toList();
    }
    return data;
  } */ //kopplade bilder
  }
}