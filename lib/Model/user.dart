import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class User {

  final String dob;
  final String email;
  final String userID;
  final String gender;
  final List no_likes;
  final List no_greams;
  final String country;
  final String fullName;
  final String username;
  final String userImage;
  final List no_regreams;
  final List no_comments;
  final List no_greams_categories;

  User({
    @required this.email,
    @required this.userID,
    this.fullName,
    this.gender,
    this.no_likes,
    this.dob,
    this.country,
    this.username,
    this.userImage,
    this.no_greams,
    this.no_regreams,
    this.no_comments,
    this.no_greams_categories,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json[FireStoreConstants.EMAIL],
        userID: json[FireStoreConstants.ID],
        fullName: json[FireStoreConstants.FULL_NAME],
        username : json[FireStoreConstants.USER_NAME],
        userImage: json[FireStoreConstants.USER_IMAGE],
        gender: json[FireStoreConstants.GENDER],
        country : json[FireStoreConstants.COUNTRY],
        dob : json[FireStoreConstants.DOB],
        no_greams_categories: json[FireStoreConstants.NO_GREAMS_CATEGORIES],
        no_likes : json[FireStoreConstants.NO_LIKES],
        no_greams : json[FireStoreConstants.NO_GREAMS],
        no_regreams : json[FireStoreConstants.NO_RE_GREAMS],
        no_comments : json[FireStoreConstants.NO_COMMENTS],
    );
  }

  factory User.fromDocument(DocumentSnapshot snapshot) {

    String email = snapshot[FireStoreConstants.EMAIL] as String;
    String userID = snapshot[FireStoreConstants.ID] as String;
    String fullname = snapshot[FireStoreConstants.FULL_NAME] as String;
    String username = snapshot[FireStoreConstants.USER_NAME] as String;
    String userImage = snapshot[FireStoreConstants.USER_IMAGE]  as String;
    String dob = snapshot[FireStoreConstants.GENDER]  as String;
    String country = snapshot[FireStoreConstants.COUNTRY]  as String;
    String gender = snapshot[FireStoreConstants.GENDER]  as String;
    List no_greams_categories = snapshot[FireStoreConstants.NO_GREAMS_CATEGORIES]  as List;
    List no_likes = snapshot[FireStoreConstants.NO_LIKES]  as List;
    List no_greams = snapshot[FireStoreConstants.NO_GREAMS]  as List;
    List no_regreams = snapshot[FireStoreConstants.NO_RE_GREAMS]  as List;
    List no_comments = snapshot[FireStoreConstants.NO_COMMENTS]  as List;

    return User(email: email,
        userID: userID,
        fullName: fullname,
        username: username,
        dob: dob,
        country: country,
        gender: gender,
        no_greams: no_greams,
        no_likes: no_likes,
        no_greams_categories: no_greams_categories,
        no_comments: no_comments,
        no_regreams: no_regreams,
        userImage: userImage);
  }


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FireStoreConstants.EMAIL: email,
      FireStoreConstants.ID: userID,
      FireStoreConstants.FULL_NAME: fullName,
      FireStoreConstants.GENDER: gender,
      FireStoreConstants.COUNTRY: country,
      FireStoreConstants.USER_NAME: username ?? "",
      FireStoreConstants.DOB : dob ?? "",
      FireStoreConstants.NO_LIKES : no_likes ?? [],
      FireStoreConstants.NO_GREAMS_CATEGORIES : no_greams_categories ?? [],
      FireStoreConstants.NO_GREAMS : no_greams ?? [],
      FireStoreConstants.NO_RE_GREAMS : no_regreams ?? [],
      FireStoreConstants.NO_COMMENTS : no_comments ?? [],
      FireStoreConstants.USER_IMAGE : userImage,
    };
  }
}


