class WebMetaData {
  Data data;

  WebMetaData({this.data});

  WebMetaData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String title;
  String domain;
  String siteName;
  String description;
  String author;
  String themeColor;
  String type;
  String card;
  String image;
  String favicon;
  List<Null> additionalInformation;

  Data(
      {this.title,
        this.domain,
        this.siteName,
        this.description,
        this.author,
        this.themeColor,
        this.type,
        this.card,
        this.image,
        this.favicon,
        this.additionalInformation});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    domain = json['domain'];
    siteName = json['siteName'];
    description = json['description'];
    author = json['author'];
    themeColor = json['themeColor'];
    type = json['type'];
    card = json['card'];
    image = json['image'];
    favicon = json['favicon'];
    // if (json['additionalInformation'] != null) {
    //   additionalInformation = new List<Null>();
    //   json['additionalInformation'].forEach((v) {
    //     additionalInformation.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['domain'] = this.domain;
    data['siteName'] = this.siteName;
    data['description'] = this.description;
    data['author'] = this.author;
    data['themeColor'] = this.themeColor;
    data['type'] = this.type;
    data['card'] = this.card;
    data['image'] = this.image;
    data['favicon'] = this.favicon;
    // if (this.additionalInformation != null) {
    //   data['additionalInformation'] =
    //       this.additionalInformation.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

