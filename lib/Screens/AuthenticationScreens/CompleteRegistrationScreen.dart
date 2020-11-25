import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Snackbar.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomDropDownButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/GreamsCategoryPage.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:intl/intl.dart';

class CompleteRegistrationScreen extends StatefulWidget {
  static final String id = 'completeRegistrationsScreenId';

  @override
  _CompleteRegistrationScreenState createState() =>
      _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState
    extends State<CompleteRegistrationScreen> {
  String _selectedGender;
  DateTime _dateOfBirth = DateTime.now();
  TextEditingController _dateOfBirthController = TextEditingController();

  ValueNotifier<bool> complete_register_progress = new ValueNotifier(false);

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  FocusNode _firstnameNode = FocusNode();
  FocusNode _lastnameNode = FocusNode();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        var formatter = DateFormat('yyyy-MM-dd');
        String readableDate = '${formatter.format(_dateOfBirth)}';
        _dateOfBirthController.text = readableDate;
        FocusScope.of(context).requestFocus(new FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text(
                  'Welcome to Greamit',
                  style: TextStyle(
                      color: appTheme.textTheme.headline6.color,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Complete details to allow us find you the latest content.',
                  style: TextStyle(
                    color: appTheme.textTheme.headline6.color,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20.0),
                CustomTextField(
                  controller: _firstnameController,
                  hintText: 'First Name',
                ),
                CustomTextField(
                  controller: _lastnameController,
                  hintText: 'Last Name',
                ),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                ),
                CustomDropDownButton(
                  hintText: 'Gender',
                  items: _listOfGender,
                  selectedItem: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    /*Without this color property, onTap(){} won't work.*/
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: CustomTextField(
                        hintText: 'Date of birth',
                        isDateOfBirthField: true,
                        controller: _dateOfBirthController,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: ValueListenableBuilder(
                      valueListenable: complete_register_progress,
                      builder: (context, bool value, child) {
                        return Column(
                          children: <Widget>[
                            Visibility(
                              visible: complete_register_progress.value,
                              child: Loader(
                                opacity: 0.05,
                              ),
                            ),
                            Visibility(
                              visible: !complete_register_progress.value,
                              child: ActionButton(
                                title: 'Continue',
                                fillColor: appTheme.primaryColor,
                                onPressed: () {
                                  complete_register_progress.value = true;
                                  _updateProfile();
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _listOfGender = ['Male', 'Female', 'Prefer not to say'];

  void _updateProfile() {
    if (_firstnameController.text != "" &&
        _lastnameController.text != null &&
        _usernameController.text != "" &&
        _selectedGender != "" &&
        _dateOfBirthController.text != null) {
      FirestoreCloudDb().updateUserData(userID: getUser.uID, fieldsToUpdate: {
        "fullname": _firstnameController.text + " " + _lastnameController.text,
        "dob": _dateOfBirthController.text,
        "username": _usernameController.text,
        "gender": _selectedGender,
      }).then((value) {
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
                  fullname: _firstnameController.text +
                      " " +
                      _lastnameController.text,
                  followers: userModel.followers,
                  following: userModel.following,
                  reGreamPosts: userModel.reGreamPosts,
                  gender: userModel.gender,
                  dob: userModel.dob,
                  username: userModel.username,
                  likedGreamPosts: userModel.likedGreamPosts,
                  greamsCategories: userModel.greamsCategories,
                  comments: userModel.comments,
                  greamPosts: userModel.greamPosts,
                  joinedDateTime: userModel.joinedDateTime,
                ));

                complete_register_progress.value = false;
                navigateReplace(context, GreamitCategoryPage());
              } catch (e) {
                return;
              }
            } else {}
          });
        });
      });
    } else {
      print(_firstnameController.text);
      print(_lastnameController.text);

      complete_register_progress.value = false;
    }
  }
}
