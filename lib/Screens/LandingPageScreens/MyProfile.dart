import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/ProfileOptionDialog.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTag.dart';
import 'package:greamit_app/Model/WebMetaData.dart';
import 'package:greamit_app/Model/gream.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/EditProfile.dart';
import 'package:greamit_app/Screens/GreamDetailsPage.dart';
import 'package:greamit_app/Screens/LandingPageScreens/FollowerList.dart';
import 'package:greamit_app/Screens/LandingPageScreens/FollowingList.dart';
import 'package:greamit_app/Screens/PostAGream.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Services/WebMetaDataRepo.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';

import '../UserPostedGream.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isFollowing = false;
  final ValueNotifier<bool> profileOptionListener = new ValueNotifier(false);

  Stream<DocumentSnapshot> userStream;
  Stream<QuerySnapshot> stream;
  UserModel userModel;

  @override
  void initState() {
    super.initState();

    userStream = FirestoreCloudDb().getUserDoc(getUser.uID).snapshots();

    stream = FirestoreCloudDb()
        .getUserGreamsCollection(getUser.uID)
        .orderBy("postTimestamp", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () {
              if (profileOptionListener.value == false) {
                profileOptionListener.value = true;
              } else {
                profileOptionListener.value = false;
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: userStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.data != null) {
              userModel = UserModel.fromJson(snapshot.data.data);

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            if (getUser.image != null && getUser.image != "")
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(getUser.image),
                              )
                            else
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: null,
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      userModel.fullname,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Text(
                                      userModel.username,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 20),
                        child: Text(
                          userModel.bio,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FollowersList()));
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: userModel.followers.length.toString(),
                                    style: TextStyle(color: Color(0XFF444444)),
                                    children: [
                                      TextSpan(
                                          text: ' Followers',
                                          style:
                                              TextStyle(color: Colors.black38))
                                    ]),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FollowingList()));
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: userModel.following.length.toString(),
                                    style: TextStyle(color: Color(0XFF444444)),
                                    children: [
                                      TextSpan(
                                          text: ' Following',
                                          style:
                                              TextStyle(color: Colors.black38))
                                    ]),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            RichText(
                              text: TextSpan(
                                  text: userModel.greamPosts.toString(),
                                  style: TextStyle(color: Color(0XFF444444)),
                                  children: [
                                    TextSpan(
                                        text: ' Greams',
                                        style: TextStyle(color: Colors.black38))
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(21.0),
                        child: GestureDetector(
                          onTap: () => navigate(context, EditProfile()),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 18.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              'EDIT PROFILE',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                      if (userModel.uID != getUser.uID) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _isFollowing = !_isFollowing);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: _isFollowing ? kPrimaryColor : null,
                                border: Border.all(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                _isFollowing ? 'FOLLOWING' : 'FOLLOW',
                                style: TextStyle(
                                    color: _isFollowing
                                        ? Colors.white
                                        : kPrimaryColor),
                              ),
                            ),
                          ),
                        ),
                      ] else
                        ...[],
                      if (userModel.greamPosts != 0) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: StreamBuilder(
                              stream: stream,
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data.documents != null) {
                                  List<GreamitPost> listGreamits =
                                      <GreamitPost>[];

                                  snapshot.data.documents.forEach((element) {
                                    listGreamits.add(
                                        GreamitPost.fromJson(element.data));
                                  });

                                  return GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10.0,
                                      children: List.generate(
                                          listGreamits.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: FutureBuilder<WebMetaData>(
                                              future: getWebsiteMetadata(
                                                  websiteString:
                                                      listGreamits[index].link),
                                              builder: (context, snapshot) {
                                                return buildPostedGreamImage(
                                                    deviceWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    categoryTag:
                                                        listGreamits[index]
                                                            .categoryList,
                                                    image: snapshot.hasData !=
                                                                null &&
                                                            snapshot.data !=
                                                                null
                                                        ? snapshot
                                                            .data.data.image
                                                        : null,
                                                    title: listGreamits[index]
                                                        .title);
                                              }),
                                        );
                                      }));
                                } else if (!snapshot.hasData) {
                                  return Text(
                                    "No data",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  );
                                } else {
                                  return Loader(
                                    opacity: 0.2,
                                  );
                                }
                              }),
                        )
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Center(
                            child: Text(
                              "No Greamit Posts",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: profileOptionListener,
                      builder: (context, bool value, child) {
                        return Positioned(
                          bottom: 0,
                          child: Visibility(
                            visible: profileOptionListener.value,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black.withOpacity(0.2),
                              child: ProfileOptions(),
                            ),
                          ),
                        );
                      }),
                ],
              );
            } else if (!snapshot.hasData) {
              return Text(
                "No data",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              );
            } else {
              return Loader(
                opacity: 0.2,
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigate(context, PostAGream()),
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
      ),
    );
  }

  Widget buildPostedGreamImage(
      {double deviceWidth,
      String image,
      String title,
      List<String> categoryTag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          image != null
              ? Image.network(
                  image,
                  width: deviceWidth,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  '$kImagesFolder/random_img.png',
                  height: 230,
                  fit: BoxFit.contain,
                ),
          Container(
            height: 230,
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryTag.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CustomTag(
                          categoryTag[index],
                          backgroundColor: Colors.white.withOpacity(0.1),
                        );
                      }),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 18.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 350.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: title != null
                            ? Text(
                                title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300),
                              )
                            : Text(
                                'No Description found',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300),
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
