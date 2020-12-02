import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greamit_app/CustomWidgets/Views/GreamitOptionsDialog.dart';
import 'package:greamit_app/CustomWidgets/Views/ProfileOptionDialog.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomPostedGream.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTag.dart';
import 'package:greamit_app/Model/WebMetaData.dart';
import 'package:greamit_app/Model/gream.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/GreamLinkView.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Services/WebMetaDataRepo.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:jiffy/jiffy.dart';

class GreamDetailsPage extends StatefulWidget {
  static final id = 'greamDetailsId';
  GreamitPost greamitPost;
  DocumentReference documentReference;

  GreamDetailsPage({this.greamitPost, this.documentReference});

  @override
  _GreamDetailsPageState createState() => _GreamDetailsPageState();
}

class _GreamDetailsPageState extends State<GreamDetailsPage> {
  bool _commentClicked = false;
  bool _isLiked = false;

  final TextEditingController _commentController = TextEditingController();

  final ValueNotifier<bool> greamitOptionListener = new ValueNotifier(false);

  Stream<DocumentSnapshot> greamitDocstream;

  UserModel mainUserModel = new UserModel();
  GreamitPost greamitPost = new GreamitPost();

  @override
  void initState() {
    greamitDocstream = widget.documentReference.snapshots();

    FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
      mainUserModel = UserModel.fromJson(value.data);
    }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    bool _isFollowing = FirestoreCloudDb().isFollowing(
        userID: greamitPost.postUserID,
        listOfFollowers: mainUserModel.following);
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => popView(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () {
              if (greamitOptionListener.value == false) {
                greamitOptionListener.value = true;
              } else {
                greamitOptionListener.value = false;
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: greamitDocstream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.data != null) {
              greamitPost = GreamitPost.fromJson(snapshot.data.data);

              FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
                mainUserModel = UserModel.fromJson(value.data);
              }).then((value) {
                _isLiked = FirestoreCloudDb().isLiked(
                    documentID: widget.documentReference.documentID,
                    listOfLikes: mainUserModel.likedGreamPosts);
              });

              print(_isLiked);

              return Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                greamitPost.postUserFullname,
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                  Jiffy.unix(greamitPost.postTimestamp)
                                      .fromNow()),
                              trailing: FlatButton.icon(
                                  onPressed: () {
                                    FirestoreCloudDb()
                                        .followProfile(
                                            documentReference:
                                                FirestoreCloudDb()
                                                    .getUserDoc(getUser.uID),
                                            usersDocumentReference:
                                                widget.documentReference,
                                            followersList:
                                                mainUserModel.following)
                                        .then((value) {
                                      FirestoreCloudDb()
                                          .getUserDoc(getUser.uID)
                                          .get()
                                          .then((value) {
                                        mainUserModel =
                                            UserModel.fromJson(value.data);
                                      }).then((value) {
                                        setState(() {});
                                      });
                                    });
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                    });
                                  },
                                  icon: Icon(
                                    _isFollowing ? Icons.check : Icons.add,
                                    color: appTheme.primaryColor,
                                    size: 24.0,
                                  ),
                                  label: Text(
                                    _isFollowing ? 'FOLLOWING' : 'FOLLOW',
                                    style: TextStyle(
                                        color: appTheme.primaryColor,
                                        fontSize: 18.0),
                                  )),
                            ),
                            Text(
                              widget.greamitPost.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                widget.greamitPost.link,
                                style: TextStyle(
                                    height: 1.5, fontStyle: FontStyle.italic),
                              ),
                            ),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // shrinkWrap: true,
                                  itemCount:
                                      widget.greamitPost.categoryList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CustomTag(
                                        widget.greamitPost.categoryList[index]);
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: FutureBuilder<WebMetaData>(
                                    future: getWebsiteMetadata(
                                        websiteString: widget.greamitPost.link),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data.data.image != null) {
                                        return Image.network(
                                          snapshot.data.data.image,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        );
                                      } else {
                                        return Center(
                                          child: Text(
                                            "No image",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  greamitPost.likes.length.toString() +
                                      ' Likes',
                                  style: TextStyle(color: Colors.black45),
                                ),
                                SizedBox(width: 15.0),
                                Text(
                                  greamitPost.comments.length.toString() +
                                      ' Comments',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(widget.greamitPost.description),
                            ),
                            Divider(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      if (greamitPost.comments.length != 0) ...[
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: greamitPost.comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    height: 100,
                                    child: _buildCommentSection(
                                        comment: greamitPost.comments[index]));
                              }),
                        ),
                      ] else
                        ...[],
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: greamitOptionListener,
                      builder: (context, bool value, child) {
                        return Positioned(
                          bottom: 0,
                          child: Visibility(
                            visible: greamitOptionListener.value,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black.withOpacity(0.2),
                              child: GreamitPostOptions(),
                            ),
                          ),
                        );
                      }),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            widget.greamitPost.postUserFullname,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                              Jiffy.unix(widget.greamitPost.postTimestamp)
                                  .fromNow()),
                          trailing: greamitPost.postUserID != getUser.uID
                              ? FlatButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                    });
                                  },
                                  icon: Icon(
                                    FirestoreCloudDb().isFollowing(
                                            userID: greamitPost.postUserID,
                                            listOfFollowers:
                                                mainUserModel.following)
                                        ? Icons.check
                                        : Icons.add,
                                    color: appTheme.primaryColor,
                                    size: 24.0,
                                  ),
                                  label: Text(
                                    FirestoreCloudDb().isFollowing(
                                            userID: greamitPost.postUserID,
                                            listOfFollowers:
                                                mainUserModel.following)
                                        ? 'FOLLOWING'
                                        : 'FOLLOW',
                                    style: TextStyle(
                                        color: appTheme.primaryColor,
                                        fontSize: 18.0),
                                  ))
                              : Container(),
                        ),
                        Text(
                          widget.greamitPost.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GreamLinkView(
                                            greamUrl: widget.greamitPost.link,
                                          )));
                            },
                            child: Text(
                              widget.greamitPost.link,
                              style: TextStyle(
                                  height: 1.5, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // shrinkWrap: true,
                              itemCount: widget.greamitPost.categoryList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CustomTag(
                                    widget.greamitPost.categoryList[index]);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              '$kImagesFolder/himym.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.greamitPost.likes.length.toString() +
                                  ' Likes',
                              style: TextStyle(color: Colors.black45),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              widget.greamitPost.comments.length.toString() +
                                  ' Comments',
                              style: TextStyle(color: Colors.black45),
                            ),
                            // Expanded(
                            //   child: Text(
                            //     'insider.com',
                            //     textAlign: TextAlign.end,
                            //     style: TextStyle(color: appTheme.primaryColor),
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(widget.greamitPost.description),
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  if (widget.greamitPost.comments.length != 0) ...[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: widget.greamitPost.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 100,
                                child: _buildCommentSection(
                                    comment:
                                        widget.greamitPost.comments[index]));
                          }),
                    ),
                  ] else
                    ...[],
                ],
              );
            }
          }),
      bottomNavigationBar: _commentClicked
          ? ListTile(
              leading: CircleAvatar(),
              title: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Drop your comment here',
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  FirestoreCloudDb().addComment(commentData: {
                    "comment": _commentController.text,
                    "name": getUser.fullname,
                    "timestamp": DateTime.now().millisecondsSinceEpoch,
                    "userID": getUser.uID,
                  }, greamDocumentReference: widget.documentReference).then(
                      (value) {
                    setState(() {
                      _commentClicked = !_commentClicked;
                    });
                  });
                },
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      FirestoreCloudDb().likeUpdate(
                          greamDocID: widget.documentReference.documentID,
                          greamDocumentReference: widget.documentReference,
                          profileDocRef:
                              FirestoreCloudDb().getUserDoc(getUser.uID),
                          likeList: greamitPost.likes);
                    },
                    icon: _isLiked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.black54,
                          ),
                    label: Text(
                      'Like',
                      style: TextStyle(color: Colors.black54),
                    )),
                FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        _commentClicked = !_commentClicked;
                      });
                    },
                    icon: SvgPicture.asset('$kImagesFolder/comment_icon.svg'),
                    label: Text(
                      'Comment',
                      style: TextStyle(color: Colors.black54),
                    )),
                FlatButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset('$kImagesFolder/send_icon.svg'),
                    label: Text(
                      'Share',
                      style: TextStyle(color: Colors.black54),
                    )),
              ],
            ),
    );
  }
}

Widget _buildCommentSection({Comments comment}) {
  return Column(
    children: [
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                comment.name ?? "",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              "",
              style: TextStyle(color: Colors.black26),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Jiffy.unix(comment.timestamp).fromNow()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                comment.comment,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    ],
  );
}
