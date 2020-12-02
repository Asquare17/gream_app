import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomDropDownButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomPostedGream.dart';
import 'package:greamit_app/Model/WebMetaData.dart';
import 'package:greamit_app/Model/gream.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/GreamDetailsPage.dart';
import 'package:greamit_app/Screens/PostAGream.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  static final id = 'homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> stream;
  List<UserModel> listUserModel = <UserModel>[];
  UserModel mainUserModel = new UserModel();

  final ValueNotifier<String> mainHomeFeedFilterListener =
      new ValueNotifier("");

  @override
  void initState() {
    super.initState();

    stream = FirestoreCloudDb()
        .getGreamsCollection()
        .orderBy("postTimestamp", descending: true)
        .snapshots();

    FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
      mainUserModel = UserModel.fromJson(value.data);
    }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          navigate(context, PostAGream());
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150.0,
                    child: CustomDropDownButton(
                      color: appTheme.primaryColor,
                      textColor: Colors.white,
                      items: _filterList,
                      hintText: 'Popular',
                      onChanged: (string) {
                        mainHomeFeedFilterListener.value = string;
                      },
                    ),
                  ),
                  Card(
                    color: appTheme.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset('$kImagesFolder/filter_icon.svg'),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                  stream: stream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.documents != null) {
                      List<GreamitPost> listGreamits = <GreamitPost>[];
                      List<bool> isLikedList = <bool>[];

                      snapshot.data.documents.forEach((element) {
                        listGreamits.add(GreamitPost.fromJson(element.data));
                        isLikedList.add(FirestoreCloudDb().isLiked(
                            documentID: element.documentID,
                            listOfLikes: mainUserModel.likedGreamPosts));
                      });

                      return ValueListenableBuilder(
                          valueListenable: mainHomeFeedFilterListener,
                          builder: (context, String value, child) {
                            var filteredGreamitLists;

                            if (value == "Following") {
                              filteredGreamitLists = listGreamits.where(
                                  (element) => mainUserModel.following
                                      .contains(element.postUserID));

                              if (filteredGreamitLists.isNotEmpty) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredGreamitLists.length,
                                    itemBuilder: (context, index) {
                                      int indexForDocReference =
                                          listGreamits.indexWhere((element) =>
                                              element.postTimestamp ==
                                              filteredGreamitLists
                                                  .toList()[index]
                                                  .postTimestamp);

                                      return CustomPostedGream(
                                        reGream: () {},
                                        commentOnGream: () {
                                          navigate(
                                              context,
                                              GreamDetailsPage(
                                                greamitPost:
                                                    listGreamits[index],
                                                documentReference: snapshot
                                                    .data
                                                    .documents[
                                                        indexForDocReference]
                                                    .reference,
                                              ));
                                        },
                                        likeGream: () {
                                          navigate(
                                              context,
                                              GreamDetailsPage(
                                                greamitPost:
                                                    filteredGreamitLists
                                                        .toList()[index],
                                                documentReference: snapshot
                                                    .data
                                                    .documents[
                                                        indexForDocReference]
                                                    .reference,
                                              ));
                                        },
                                        isLiked: isLikedList[index],
                                        onGreamitPostTap: () {
                                          navigate(
                                              context,
                                              GreamDetailsPage(
                                                greamitPost:
                                                    filteredGreamitLists
                                                        .toList()[index],
                                                documentReference: snapshot
                                                    .data
                                                    .documents[
                                                        indexForDocReference]
                                                    .reference,
                                              ));
                                        },
                                        description: filteredGreamitLists
                                            .toList()[index]
                                            .description,
                                        title: filteredGreamitLists
                                            .toList()[index]
                                            .title,
                                        numberOfComments: filteredGreamitLists
                                            .toList()[index]
                                            .comments
                                            .length
                                            .toString(),
                                        numberOfLikes: filteredGreamitLists
                                            .toList()[index]
                                            .likes
                                            .length
                                            .toString(),
                                        postersName: filteredGreamitLists
                                            .toList()[index]
                                            .postUserFullname,
                                        postCategories: filteredGreamitLists
                                            .toList()[index]
                                            .categoryList,
                                        link: filteredGreamitLists
                                            .toList()[index]
                                            .link,
                                        postedTime: Jiffy.unix(
                                                filteredGreamitLists
                                                    .toList()[index]
                                                    .postTimestamp)
                                            .fromNow(),
                                        postersImage: "",
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: listGreamits.length,
                                  itemBuilder: (context, index) {
                                    return CustomPostedGream(
                                      documentReference: snapshot
                                          .data.documents[index].reference,
                                      reGream: () {},
                                      commentOnGream: () {
                                        navigate(
                                            context,
                                            GreamDetailsPage(
                                              greamitPost: listGreamits[index],
                                              documentReference: snapshot.data
                                                  .documents[index].reference,
                                            ));
                                      },
                                      likeGream: () {
                                        navigate(
                                            context,
                                            GreamDetailsPage(
                                              greamitPost: listGreamits[index],
                                              documentReference: snapshot.data
                                                  .documents[index].reference,
                                            ));
                                      },
                                      isLiked: isLikedList[index],
                                      onGreamitPostTap: () {
                                        navigate(
                                            context,
                                            GreamDetailsPage(
                                              greamitPost: listGreamits[index],
                                              documentReference: snapshot.data
                                                  .documents[index].reference,
                                            ));
                                      },
                                      description:
                                          listGreamits[index].description,
                                      title: listGreamits[index].title,
                                      numberOfComments: listGreamits[index]
                                          .comments
                                          .length
                                          .toString(),
                                      numberOfLikes: listGreamits[index]
                                          .likes
                                          .length
                                          .toString(),
                                      postersName:
                                          listGreamits[index].postUserFullname,
                                      postCategories:
                                          listGreamits[index].categoryList,
                                      link: listGreamits[index].link,
                                      postedTime: Jiffy.unix(
                                              listGreamits[index].postTimestamp)
                                          .fromNow(),
                                      postersImage: "",
                                    );
                                  },
                                ),
                              );
                            }
                          });
                    } else if (!snapshot.hasData) {
                      return Text(
                        "No data",
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      );
                    } else {
                      return Loader(
                        opacity: 0.2,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> _filterList = ['Popular', 'Following', 'New & Noteworthy'];
