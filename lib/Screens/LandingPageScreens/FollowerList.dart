import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';

class FollowersList extends StatefulWidget {
  @override
  _FollowersListState createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  Stream<QuerySnapshot> stream;
  UserModel mainUserModel = new UserModel();

  @override
  void initState() {
    super.initState();

    stream = FirestoreCloudDb().getUsersCollection().snapshots();

    FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
      mainUserModel = UserModel.fromJson(value.data);
    }).then((value) {});
  }

  List<UserModel> listUserModel = <UserModel>[];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0),
          child: Text(
            'Back',
            style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
          ),
        ),
        title: Text(
          'Followers',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: stream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.documents != null) {
                      List<UserModel> listUserModel = <UserModel>[];

                      List<bool> isFollowingList = <bool>[];

                      UserModel userModel = new UserModel();

                      snapshot.data.documents.forEach((element) {
                        userModel = UserModel.fromJson(element.data);

                        if (userModel.uID != getUser.uID) {
                          if (mainUserModel.followers.contains(userModel.uID)) {
                            listUserModel.add(userModel);
                          }
                        }

                        isFollowingList.add(FirestoreCloudDb().isFollowing(
                            userID: element.documentID,
                            listOfFollowers: mainUserModel.following));

                        print(element.data.toString());
                      });

                      return ListView.builder(
                          itemCount: listUserModel.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                listUserModel[index].fullname,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(listUserModel[index].username,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w400)),
                              trailing: FlatButton.icon(
                                  onPressed: () {
                                    print(mainUserModel.toJson().toString());

                                    FirestoreCloudDb()
                                        .followProfile(
                                            documentReference:
                                                FirestoreCloudDb()
                                                    .getUserDoc(getUser.uID),
                                            usersDocumentReference: snapshot
                                                .data
                                                .documents[index]
                                                .reference,
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
                                  },
                                  icon: Icon(
                                    isFollowingList[index]
                                        ? Icons.check
                                        : Icons.add,
                                    color: kPrimaryColor,
                                    size: 24.0,
                                  ),
                                  label: Text(
                                    isFollowingList[index]
                                        ? 'FOLLOWING'
                                        : 'FOLLOW',
                                    style: TextStyle(
                                        color: kPrimaryColor, fontSize: 18.0),
                                  )),
                            );
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
            ),
            ActionButton(
              title: 'Done',
              fillColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomFollowersUser extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         child: ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: CircleAvatar(
//               child: Icon(Icons.person),
//             ),
//             title: Text(
//               'Roseline Maxwel',
//               style: TextStyle(color: Colors.black),
//             ),
//             subtitle: Text(
//               '@rosiemax',
//               style: TextStyle(color: Colors.black26),
//             ),
//             trailing: Text(
//               'FOLLOWING',
//               style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
//             )),
//       ),
//     );
//   }
// }
