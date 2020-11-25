import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Snackbar.dart';
import 'package:greamit_app/CustomWidgets/Views/category_item.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:greamit_app/Utilities/size_config.dart';

class GreamitCategoryPage extends StatefulWidget {
  final FirebaseUser user;

  const GreamitCategoryPage({this.user, Key key}) : super(key: key);

  @override
  _GreamitCategoryPageState createState() => _GreamitCategoryPageState();
}

class _GreamitCategoryPageState extends State<GreamitCategoryPage> {
  final SizeConfig config = SizeConfig();

  final List<String> _selectedCategories = <String>[];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _categories = <String>[
    'Food',
    'Music',
    'Fashion',
    'Design',
    'Photography',
    'Furniture',
  ];

  final List<String> _categories_image = <String>[
    'assets/images/cate_food.png',
    'assets/images/cate_music.png',
    'assets/images/cate_fashion.png',
    'assets/images/cate_design.png',
    'assets/images/cate_photography.png',
    'assets/images/cate_furniture.png',
  ];

  ValueNotifier<bool> setCate_progress = new ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: InkWell(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome to Greamit',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Tell us what you are interested in',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 730,
                      width: SizeConfig.screenWidthDp,
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.09,
                          children: List<Widget>.generate(_categories.length,
                              (int index) {
                            return CategoryItem(
                              notSelected:
                                  appTheme.primaryColor.withOpacity(0.05),
                              selected: appTheme.primaryColor.withOpacity(0.3),
                              cateImage: _categories_image[index],
                              text: _categories[index],
                              isSelected: _selectedCategories
                                  .contains(_categories[index]),
                              onSelected: () {
                                if (_selectedCategories
                                    .contains(_categories[index])) {
                                  setState(() {
                                    _selectedCategories
                                        .remove(_categories[index]);
                                  });
                                } else {
                                  setState(() {
                                    _selectedCategories.add(_categories[index]);
                                  });
                                }
                              },
                            );
                          })),
                    ),
                    Positioned(
                      bottom: 2.0,
                      child: ValueListenableBuilder(
                          valueListenable: setCate_progress,
                          builder: (context, bool value, child) {
                            return Column(
                              children: <Widget>[
                                Visibility(
                                  visible: setCate_progress.value,
                                  child: Loader(
                                    opacity: 0.05,
                                  ),
                                ),
                                Visibility(
                                  visible: !setCate_progress.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 26.0,
                                      right: 30.0,
                                    ),
                                    child: SizedBox(
                                      width: 360.0,
                                      child: ActionButton(
                                        title: buttonText(),
                                        fillColor: appTheme.primaryColor,
                                        onPressed: _selectedCategories.length <
                                                5
                                            ? null
                                            : () {
                                                setCate_progress.value = true;

                                                if (_selectedCategories.length <
                                                    5) {
                                                  setCate_progress.value =
                                                      false;

                                                  showSnackBar(scaffoldKey,
                                                      message:
                                                          'You need to select up to 5 categories',
                                                      duration: 5);
                                                } else {
                                                  _setupGreamitCategories();
                                                }
                                              },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  String buttonText() {
    if (_selectedCategories.isEmpty) return 'Select up to 5 Interests';
    if (_selectedCategories.length < 5)
      return 'Select ${5 - _selectedCategories.length} more';
    else
      return 'Done';
  }

  void _setupGreamitCategories() {
    if (getUser != null) {
      FirestoreCloudDb().updateUserData(userID: getUser.uID, fieldsToUpdate: {
        "greamsCategories": _selectedCategories,
      }).then((value) {
        setCate_progress.value = false;
        navigateReplace(context, LandingPage());
      });
    } else if (widget.user != null) {
      FirestoreCloudDb().getUserData(widget.user.uid).then((value) {
        value.snapshots().forEach((element) {
          var document = element;

          if (document != null) {
            FirestoreCloudDb()
                .updateUserData(userID: widget.user.uid, fieldsToUpdate: {
              'greams_categories': _selectedCategories,
            }).then((value) {
              try {
                var userModel = UserModel.fromJson(document.data);

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
                  likedGreamPosts: userModel.likedGreamPosts,
                  greamsCategories: userModel.greamsCategories,
                  comments: userModel.comments,
                  greamPosts: userModel.greamPosts,
                  joinedDateTime: userModel.joinedDateTime,
                ));

                navigateReplace(context, LandingPage());
              } catch (e) {
                setCate_progress.value = false;
                showSnackBar(scaffoldKey,
                    message: 'Sorry, Error access your account.', duration: 5);

                return;
              }
            });
          } else {
            setCate_progress.value = false;
            showSnackBar(scaffoldKey,
                message: 'An Error with accessing your profile', duration: 5);
          }
        });
      });
    } else {
      setCate_progress.value = false;
      showSnackBar(scaffoldKey,
          message: 'An Error with accessing your profile', duration: 5);
    }
  }
}
