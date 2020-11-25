import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomDropDownButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Snackbar.dart';
import 'package:greamit_app/Model/user.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CompleteRegistrationScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/EmailVerificationScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/Helper.dart';
import 'package:greamit_app/Utilities/navigator.dart';

class CreateAccountScreen extends StatefulWidget {
  static final String id = 'createAccountId';

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String _selectedCountry;
  FocusNode _emNode = FocusNode();
  FocusNode _pswNode = FocusNode();
  FocusNode _comfirmpswNode = FocusNode();
  bool _isPickCountryWidgetVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  ValueNotifier<bool> signup_progress = new ValueNotifier(false);
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                  'Find the latest information easily',
                  style: TextStyle(
                    color: appTheme.textTheme.headline6.color,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20.0),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  currentNode: _emNode,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  currentNode: _pswNode,
                  isPasswordField: true,
                ),
                CustomTextField(
                  controller: _confirmpasswordController,
                  hintText: 'Confirm password',
                  currentNode: _comfirmpswNode,
                  isPasswordField: true,
                ),
                InkWell(
                  onTap: () {
                    setState(() => _isPickCountryWidgetVisible = true);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: CustomTextField(
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                        hintText: 'Country',
                        controller: _countryController,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPickCountryWidgetVisible,
                  child: PickCountryWidget(
                    onPressed: (country) {
                      setState(() {
                        _countryController.text = country;
                        _selectedCountry = country;
                        print(_selectedCountry);
                      });
                    },
                    onCancelledPressed: () {
                      setState(() => _isPickCountryWidgetVisible = false);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: ValueListenableBuilder(
                      valueListenable: signup_progress,
                      builder: (context, bool value, child) {
                        return Column(
                          children: <Widget>[
                            Visibility(
                              visible: signup_progress.value,
                              child: Loader(
                                opacity: 0.05,
                              ),
                            ),
                            Visibility(
                              visible: !signup_progress.value,
                              child: ActionButton(
                                title: 'Continue',
                                fillColor: appTheme.primaryColor,
                                onPressed: () {
                                  signup_progress.value = true;
                                  _register();
                                  // navigateReplace(context, LandingPage());
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                /*Sign in with Google Button*/
                SizedBox(
                  height: 45.0,
                  child: FlatButton(
                    onPressed: () {
                      signInWithGoogle().whenComplete(() =>
                          Navigator.pushReplacementNamed(
                              context, LandingPage.id));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          '$kImagesFolder/google_logo.png',
                          width: 50.0,
                          height: 50.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                              color: appTheme.textTheme.headline4.color),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 15.0),
                /*Sign in with Facebook Button*/
                SizedBox(
                  height: 45.0,
                  child: FlatButton(
                    onPressed: () {},
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          '$kImagesFolder/facebook_logo.png',
                          width: 50.0,
                          height: 50.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Continue with Facebook',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By continuing, you agree to Greamit\'s',
                      style:
                          TextStyle(color: appTheme.textTheme.headline4.color),
                      children: <InlineSpan>[
                        TextSpan(
                            text: ' Terms of Service, Privacy Policy.',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ]),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Already a member? Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_passwordController.text == _confirmpasswordController.text) {
      if (_emailController.text != "") {
        final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ))
            .user;

        if (user != null) {
          await user.sendEmailVerification();

          setUser(UserModel(
            uID: user.uid,
            email: user.email,
            country: _selectedCountry,
            fullname: "",
            followers: [],
            following: [],
            reGreamPosts: [],
            gender: "",
            dob: "",
            bio: "",
            image: "",
            likedGreamPosts: [],
            username: "",
            greamsCategories: [],
            comments: 0,
            greamPosts: 0,
            joinedDateTime: DateTime.now().millisecondsSinceEpoch,
          ));

          FirestoreCloudDb().writeNewUser(userID: user.uid, userModel: getUser);

          navigateReplace(context, CompleteRegistrationScreen());
        } else {
          signup_progress.value = false;
          showSnackBar(scaffoldKey,
              message: 'An Error with creating your profile', duration: 5);
        }
      } else {
        signup_progress.value = false;
        showSnackBar(scaffoldKey, message: 'Email is empty', duration: 5);
      }
    } else {
      signup_progress.value = false;
      showSnackBar(scaffoldKey,
          message: 'Password does not match', duration: 5);
    }
  }
}

class PickCountryWidget extends StatelessWidget {
  final Function(String country) onPressed;
  final Function onCancelledPressed;

  PickCountryWidget(
      {@required this.onPressed, @required this.onCancelledPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220.0,
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.white,
            child: Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Helper.listOfCountries.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => onPressed(Helper.listOfCountries[index]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          Helper.listOfCountries[index],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          elevation: 10.0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            onTap: () => onCancelledPressed(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: kPrimaryColor, fontSize: 24.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
