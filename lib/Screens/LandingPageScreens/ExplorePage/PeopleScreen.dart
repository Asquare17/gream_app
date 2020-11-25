import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/size_config.dart';

class SuggestedPeople extends StatefulWidget {

  @override
  _SuggestedPeopleState createState() => _SuggestedPeopleState();

}

class _SuggestedPeopleState extends State<SuggestedPeople> {

  Stream<QuerySnapshot> stream;
  UserModel mainUserModel = new UserModel();

  @override
  void initState() {
    super.initState();

    stream = FirestoreCloudDb().getUsersCollection().snapshots();

    FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
      mainUserModel = UserModel.fromJson(value.data);
    }).then((value) {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  hintText: 'Find people on Greamit',
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: SvgPicture.asset(
                      '$kImagesFolder/search_icon.svg',
                      width: 2.0,
                      height: 2.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Suggested for you',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),

        StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if(snapshot.hasData && snapshot.data.documents != null) {

              List<UserModel> listUserModel = <UserModel>[];
              List<bool> isFollowingList = <bool>[];

              UserModel userModel = new UserModel();

              snapshot.data.documents.forEach((element) {

                userModel = UserModel.fromJson(element.data);

                if(userModel.uID != getUser.uID) {
                  listUserModel.add(userModel);
                }

                isFollowingList.add(FirestoreCloudDb().isFollowing(userID: element.documentID, listOfFollowers: mainUserModel.following));

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
                      subtitle: Text(listUserModel[index].username, style: TextStyle(fontWeight: FontWeight.w400)),
                      trailing: FlatButton.icon(
                          onPressed: () {

                            print(mainUserModel.toJson().toString());

                            FirestoreCloudDb().followProfile(
                                documentReference: FirestoreCloudDb().getUserDoc(getUser.uID),
                                usersDocumentReference: snapshot.data.documents[index].reference,
                                followersList: mainUserModel.following
                            ).then((value) {

                              FirestoreCloudDb().getUserDoc(getUser.uID).get().then((value) {
                                mainUserModel = UserModel.fromJson(value.data);
                              }).then((value) {

                                setState(() { });

                              });

                            });

                          },
                          icon: Icon(
                            isFollowingList[index] ? Icons.check : Icons.add,
                            color: kPrimaryColor,
                            size: 24.0,
                          ),
                          label: Text(
                            isFollowingList[index] ? 'FOLLOWING' : 'FOLLOW',
                            style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
                          )
                      ),
                    );
                  }
              );

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
          }
        ),
      ],
    );
  }
}
