class Tags {
  String tag;
  List<Null> bilder;

  Tags({this.tag, this.bilder});

  Tags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    if (json['bilder'] != null) {
      bilder = new List<Null>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    // if (this.bilder != null) {
    //   data['bilder'] = this.bilder.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}