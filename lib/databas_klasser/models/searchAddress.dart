class searchAddress {
  int id;
  String image;
  int year;
  String description;
  String documentID;
  String photographer;
  String licence;
  String block;
  String district;
  //List<Tags> tags;

  searchAddress(
      {this.id,
        this.image,
        this.year,
        this.description,
        this.documentID,
        this.photographer,
        this.licence,
        this.block,
        this.district,
        //	this.tags
      });

  searchAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    year = json['year'];
    description = json['description'];
    documentID = json['documentID'];
    photographer = json['photographer'];
    licence = json['licence'];
    block = json['block'];
    district = json['district'];
    /*if (json['tags'] != null) {
			tags = new List<String>();
			json['tags'].forEach((v) {
				tags.add(new String.fromJson(v));
			});
		}*/
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
/*		if (this.tags != null) {
			data['tags'] = this.tags.map((v) => v.toJson()).toList();
		}
		return data;
	}*/
  }

/*class Tags {
	String tag;
	List<Null> bilder;
	Tags({this.tag, this.bilder});
	Tags.fromJson(Map<String, dynamic> json) {
		tag = json['tag'];
		if (json['bilder'] != null) {
			bilder = new List<Null>();
			json['bilder'].forEach((v) {
				bilder.add(new Null.fromJson(v));
			});
		}
	}
	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['tag'] = this.tag;
		if (this.bilder != null) {
			data['bilder'] = this.bilder.map((v) => v.toJson()).toList();
		}
		return data;
	}*/
}