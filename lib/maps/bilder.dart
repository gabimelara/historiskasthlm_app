import 'package:historiskasthlm_app/maps/tags.dart';
import 'all_addresses.dart';

class Bild {
  int id;
  String image;
  int year;
  String description;
  String documentID;
  String photographer;
  String licence;
  String block;
  String district;
  List<Tags> tags;
  List<allAddresses> addresses;

  Bild(
      {this.id,
        this.image,
        this.year,
        this.description,
        this.documentID,
        this.photographer,
        this.licence,
        this.block,
        this.district,
        this.tags,
        this.addresses});

  Bild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    year = json['year'];
    description = json['description'];
    documentID = json['documentID'];
    photographer = json['photographer'];
    licence = json['licence'];
    block = json['block'];
    district = json['district'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = new List<allAddresses>();
      json['addresses'].forEach((v) {
        addresses.add(new allAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['year'] = this.year;
    data['description'] = this.description;
    data['documentID'] = this.documentID;
    data['photographer'] = this.photographer;
    data['licence'] = this.licence;
    data['block'] = this.block;
    data['district'] = this.district;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
