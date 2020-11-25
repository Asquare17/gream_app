import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Snackbar.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CompleteRegistrationScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CreateAccountScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/ForgotPassword.dart';
import 'package:greamit_app/Screens/GreamsCategoryPage.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'EmailVerificationScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static final String id = 'createAccountId';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final String id = 'loginScreenId';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode _emNode = FocusNode();
  FocusNode _pswNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ValueNotifier<bool> signin_progress = new ValueNotifier(false);

  Stream<DocumentSnapshot> stream;

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
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
                  'Welcome back',
                  style: TextStyle(
                      color: appTheme.textTheme.headline6.color,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Login to your account.',
                  style: TextStyle(
                    color: appTheme.textTheme.headline6.color,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 25.0),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  currentNode: _emNode,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  currentNode: _pswNode,
                  isPasswordField: true,
                ),
                SizedBox(height: 20.0),
                ValueListenableBuilder(
                    valueListenable: signin_progress,
                    builder: (context, bool value, child) {
                      return Column(
                        children: <Widget>[
                          Visibility(
                            visible: signin_progress.value,
                            child: Loader(
                              opacity: 0.05,
                            ),
                          ),
                          Visibility(
                            visible: !signin_progress.value,
                            child: ActionButton(
                              title: 'Log in',
                              fillColor: appTheme.primaryColor,
                              onPressed: () {
                                signin_progress.value = true;
                                _doSignIn();
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Color(0XFFAAB2BA),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('OR'),
                    ),
                    Expanded(
                        child: Divider(
                      color: Color(0XFFAAB2BA),
                    )),
                  ],
                ),
                SizedBox(height: 18.0),
                /*Sign in with Google Button*/
                SizedBox(
                  height: 45.0,
                  child: FlatButton(
                    onPressed: () {
                      signInWithGoogle().whenComplete(() =>
                          Navigator.pushReplacementNamed(
                              context, CompleteRegistrationScreen.id));
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
                        ),
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
                SizedBox(height: 15.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Color(0XFF444444), fontSize: 18.0),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, CreateAccountScreen.id);
                          },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
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

  void _doSignIn() async {
    final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text))
        .user;

    if (user != null) {
      FirestoreCloudDb().getUserData(user.uid).then((value) {
        value.snapshots().forEach((element) {
          var document = element;
          if (document != null) {
            print(document.data.toString());

            var userModel = UserModel.fromJson(document.data);

            if (userModel.greamsCategories.length == 0) {
              navigateReplace(context, GreamitCategoryPage(user: user));
            } else if (userModel.fullname == "") {
              navigateReplace(context, CompleteRegistrationScreen());
            } else {
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
                  username: userModel.username,
                  bio: userModel.bio,
                  likedGreamPosts: userModel.likedGreamPosts,
                  greamsCategories: userModel.greamsCategories,
                  comments: userModel.comments,
                  greamPosts: userModel.greamPosts,
                  joinedDateTime: userModel.joinedDateTime,
                ));

                navigateReplace(context, LandingPage());
              } catch (e) {
                print(e);
                signin_progress.value = false;
                _firebaseAuth.signOut();
                showSnackBar(scaffoldKey,
                    message: 'Sorry, Error accessing your account.',
                    duration: 5);

                return;
              }
            }
          }
        });
      });
    } else {
      showSnackBar(scaffoldKey,
          message: 'An Error with accessing   your profile', duration: 5);
    }
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String firstNameFromGoogle = '';
String lastNameFromGoogle = '';

Future signInWithGoogle() async {
  print('SIGN GOOGLE');
  final googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult =
      await _firebaseAuth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  /*To split FirstName and LastName. They usually come
  together like "Franklin Oladipo".
  */
  List<String> displayName = user.displayName.split(' ');
  firstNameFromGoogle = displayName[0];
  lastNameFromGoogle = displayName[1];

  print(firstNameFromGoogle);

  setUser(UserModel(
    uID: user.uid,
  ));
}
