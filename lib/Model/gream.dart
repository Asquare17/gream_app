class GreamitPost {
  List<String> categoryList;
  List<Comments> comments;
  List<String> reGreams;
  String description;
  String title;
  bool isBlocked;
  bool isMalicious;
  int postTimestamp;
  String postUserID;
  String postUserFullname;
  String postUserPhoto;
  List<String> likes;
  List<String> subCategoryList;
  String link;

  GreamitPost(
      {this.categoryList,
        this.comments,
        this.description,
        this.title,
        this.isBlocked,
        this.isMalicious,
        this.reGreams,
        this.postTimestamp,
        this.postUserID,
        this.postUserPhoto,
        this.likes,
        this.postUserFullname,
        this.subCategoryList,
        this.link});

  GreamitPost.fromJson(Map<String, dynamic> json) {
    categoryList = json['categoryList'].cast<String>();
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    description = json['description'];
    title = json['title'];
    isBlocked = json['isBlocked'];
    isMalicious = json['isMalicious'];
    postTimestamp = json['postTimestamp'];
    postUserFullname = json['postUserFullname'];
    postUserPhoto = json['postUserPhoto'];
    postUserID = json['postUserID'];
    likes = json['likes'].cast<String>();
    subCategoryList = json['subCategoryList'].cast<String>();
    reGreams = json['reGreams'].cast<String>();
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryList'] = this.categoryList;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['title'] = this.title;
    data['isBlocked'] = this.isBlocked;
    data['isMalicious'] = this.isMalicious;
    data['postTimestamp'] = this.postTimestamp;
    data['postUserID'] = this.postUserID;
    data['postUserFullname'] = this.postUserFullname;
    data['postUserPhoto'] = this.postUserPhoto;
    data['likes'] = this.likes;
    data['subCategoryList'] = this.subCategoryList;
    data['reGreams'] = this.reGreams;
    data['link'] = this.link;
    return data;
  }
}

class Comments {
  String comment;
  String name;
  int timestamp;
  String userID;

  Comments({this.comment, this.name, this.timestamp, this.userID});

  Comments.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    name = json['name'];
    timestamp = json['timestamp'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['name'] = this.name;
    data['timestamp'] = this.timestamp;
    data['userID'] = this.userID;
    return data;
  }
}

List<Map<String, dynamic>> allCommentToJson(List<Comments> listComments) {
  return listComments.map((v) => v.toJson()).toList();
}

