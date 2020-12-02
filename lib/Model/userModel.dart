class UserModel {
  String country;
  String dob;
  String email;
  String fullname;
  String gender;
  List<String> greamsCategories;
  String uID;
  int comments;
  int greamPosts;
  String bio;
  String image;
  List<String> likedGreamPosts;
  List<String> reGreamPosts;
  String username;
  List<String> followers;
  List<String> blocked;
  List<String> following;
  int joinedDateTime;

  UserModel(
      {this.country,
      this.dob,
      this.email,
      this.fullname,
      this.gender,
      this.greamsCategories,
      this.uID,
      this.comments,
      this.greamPosts,
      this.likedGreamPosts,
      this.bio,
      this.image,
      this.reGreamPosts,
      this.username,
      this.followers,
      this.following,
      this.blocked,
      this.joinedDateTime});

  UserModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    dob = json['dob'];
    email = json['email'];
    fullname = json['fullname'];
    gender = json['gender'];
    greamsCategories = json['greamsCategories'].cast<String>();
    uID = json['uID'];
    comments = json['Comments'];
    greamPosts = json['greamPosts'];
    likedGreamPosts = json['likedGreamPosts'].cast<String>();
    reGreamPosts = json['reGreamPosts'].cast<String>();
    username = json['username'];
    bio = json['bio'];
    image = json['image'];
    followers = json['followers'].cast<String>();
    following = json['following'].cast<String>();
    blocked = json['blocked'].cast<String>();
    joinedDateTime = json['joinedDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['fullname'] = this.fullname;
    data['gender'] = this.gender;
    data['greamsCategories'] = this.greamsCategories;
    data['uID'] = this.uID;
    data['Comments'] = this.comments;
    data['greamPosts'] = this.greamPosts;
    data["bio"] = this.bio;
    data["image"] = this.image;
    data['likedGreamPosts'] = this.likedGreamPosts;
    data['reGreamPosts'] = this.reGreamPosts;
    data['username'] = this.username;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['blocked'] = this.blocked;
    data['joinedDateTime'] = this.joinedDateTime;
    return data;
  }
}
