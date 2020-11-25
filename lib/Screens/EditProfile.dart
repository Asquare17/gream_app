import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:image_picker/image_picker.dart';

import 'LandingPageScreens/MyProfile.dart';

class EditProfile extends StatefulWidget {

  static final String id = 'editProfileId';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File userProfileImage;

  StorageTaskSnapshot storageSnapshot;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://greamit-693db.appspot.com');

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  FocusNode _fnameNode = FocusNode();
  FocusNode _usernameNode = FocusNode();
  FocusNode _bioNode = FocusNode();

  ValueNotifier<bool> edit_profile_progress = new ValueNotifier(false);
  String _fullName = getUser.fullname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => popView(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0),
            child: Text(
              'Back',
              style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
            ),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  if (getUser.image != null && getUser.image != "")

                    InkWell(
                      onTap: () {

                        pickImage(ImageSource.gallery).then((value) {

                          setState(() {
                            userProfileImage = value;
                          });
                        });

                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              getUser.image),
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {

                        pickImage(ImageSource.gallery).then((value) {

                          setState(() {
                            userProfileImage = value;
                          });
                        });

                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: userProfileImage != null ? FileImage(userProfileImage) : null,
                        ),
                      ),
                    ),

                  SizedBox(height: 4.0),

                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Upload Profile Picture',
                        style: TextStyle(color: kPrimaryColor),
                      )),
                  SizedBox(height: 8.0),
                  Text(
                    'Full Name',
                    style: TextStyle(color: Colors.black),
                  ),
                  CustomTextField(
                    controller: _fullnameController,
                    currentNode: _fnameNode,
                    initialValue: getUser.fullname,
                    onChanged: (value) {
                      _fullName = value;
                    },
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Username',
                    style: TextStyle(color: Colors.black),
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    currentNode: _usernameNode,
                    initialValue: getUser.username,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Bio',
                    style: TextStyle(color: Colors.black),
                  ),
                  CustomTextField(
                    controller: _bioController,
                    currentNode: _bioNode,
                    maxLines: 5,
                  )
                ],
              ),
              SizedBox(height: 20.0),
              ValueListenableBuilder(
                  valueListenable: edit_profile_progress,
                  builder: (context, bool value, child) {
                    return Column(
                      children: <Widget>[
                        Visibility(
                          visible: edit_profile_progress.value,
                          child: Loader(
                            opacity: 0.05,
                          ),
                        ),
                        Visibility(
                            visible: !edit_profile_progress.value,
                            child: Builder(
                              builder: (context) {
                                return ActionButton(
                                    title: 'Save Changes',
                                    fillColor: kPrimaryColor,
                                    onPressed: () async {

                                      edit_profile_progress.value = true;

                                      if(userProfileImage != null) {

                                        saveProfileImage(userProfileImage, DateTime.now().millisecondsSinceEpoch.toString()).then((value) async {

                                           await FirestoreCloudDb().updateUserData(
                                              userID: getUser.uID,
                                              fieldsToUpdate: {
                                                "username": _usernameController.text == "" || _usernameController.text == null ? getUser.username : "@" + _usernameController.text.replaceAll("@", ""),
                                                "fullname": _fullnameController.text == "" || _fullnameController.text ==  null ? getUser.fullname : _usernameController.text,
                                                "bio": _bioController.text == "" || _bioController.text == null ? getUser.bio : _bioController.text,
                                                "image": value,
                                              }).whenComplete(() {

                                                updateUserProfile();
                                          });

                                        });

                                      } else {

                                        await FirestoreCloudDb().updateUserData(
                                            userID: getUser.uID,
                                            fieldsToUpdate: {
                                              "username": _usernameController.text == "" || null ? getUser.username : "@" + _usernameController.text.replaceAll("@", ""),
                                              "fullname": _fullnameController.text == "" || null ? getUser.fullname : _usernameController.text,
                                              "bio": _bioController.text == "" || null ? getUser.bio : _bioController.text,
                                            }).whenComplete(() {

                                                updateUserProfile();
                                        });
                                      }

                                    });
                                },
                            )
                        )
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void updateUserProfile() {

    FirestoreCloudDb().getUserData(getUser.uID).then((value) {

      value.snapshots().forEach((element) {

        var document = element;
        if (document != null) {

          var userModel = UserModel.fromJson(document.data);

          try {

            setUser(UserModel(
              uID: userModel.uID,
              email: userModel.email,
              country: userModel.country,
              fullname: userModel.fullname,
              followers: userModel.followers,
              following: userModel.following,
              reGreamPosts: userModel.reGreamPosts,
              gender: userModel.gender,
              dob: userModel.dob,
              image: userModel.image,
              bio: userModel.bio,
              likedGreamPosts: userModel.likedGreamPosts,
              greamsCategories: userModel.greamsCategories,
              comments: userModel.comments,
              greamPosts: userModel.greamPosts,
              joinedDateTime: userModel.joinedDateTime,
            ));

            navigateReplace(context, LandingPage());

          } catch (e) {

            return;
          }

        }
      });
    });

  }


  Future<File> pickImage(ImageSource source) async {
    PickedFile selectedFile = await ImagePicker.platform.pickImage(source: source, maxHeight: 460, maxWidth: 460);
    return File(selectedFile.path);
  }


  Future<String> saveProfileImage(File file, String name) async {
    StorageReference reference = _storage.ref().child("user_images/$name");
    StorageUploadTask uploadTask = reference.putFile(file);
    storageSnapshot = await uploadTask.onComplete;
    String url = await storageSnapshot.ref.getDownloadURL();
    return  url;
  }

}
