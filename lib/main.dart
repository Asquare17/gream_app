import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:greamit_app/Model/user.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CompleteRegistrationScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CreateAccountScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/EmailVerificationScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/ForgotPassword.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:greamit_app/Screens/BlockedList.dart';
import 'package:greamit_app/Screens/EditProfile.dart';
import 'package:greamit_app/Screens/GreamDetailsPage.dart';
import 'package:greamit_app/Screens/GreamsCategoryPage.dart';
import 'package:greamit_app/Screens/LandingPageScreens/ExplorePage/CategoriesScreen.dart';
import 'package:greamit_app/Screens/LandingPageScreens/HomePage.dart';
import 'package:greamit_app/Screens/LandingPageScreens/LandingPage.dart';
import 'package:greamit_app/Screens/OnBoardingScreen.dart';
import 'package:greamit_app/Screens/PostAGream.dart';
import 'package:greamit_app/Screens/PromotePost.dart';
import 'package:greamit_app/Screens/SettingsPage.dart';
import 'package:greamit_app/Services/CloudRepo/CloudActivities.dart';
import 'package:greamit_app/Services/Persistence/persistenceModel.dart';

import 'Services/Persistence/PersistentData.dart';
import 'Utilities/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GetIt serviceLocator = GetIt.I;
  serviceLocator
      .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  await getPersistedUser().then((UserModel persistedUser) {
    if (persistedUser != null) {
      setUser(persistedUser);
    }

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0XFFD4145A),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0XFF262525),
          ),
          headline4: TextStyle(
            color: Color(0XFFAAB2BA),
          ),
        ),
      ),
      // initialRoute: OnBoardingScreen.id,
      routes: {
        LandingPage.id: (context) => LandingPage(),
        EditProfile.id: (context) => EditProfile(),
        SettingsPage.id: (context) => SettingsPage(),
        BlockedList.id: (context) => BlockedList(),
        PromotePost.id: (context) => PromotePost(),
        OnBoardingScreen.id: (context) => OnBoardingScreen(),
        GreamDetailsPage.id: (context) => GreamDetailsPage(),
        HomePage.id: (context) => HomePage(),
        PostAGream.id: (context) => PostAGream(),
        CreateAccountScreen.id: (context) => CreateAccountScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        ForgotPassword.id: (context) => ForgotPassword(),
        CompleteRegistrationScreen.id: (context) =>
            CompleteRegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen()
      },
      home: Builder(builder: (BuildContext context) {
        SizeConfig.init(context,
            width: 360, height: 640, allowFontScaling: true);

        if (getUser != null) {
          String id = FirestoreCloudDb().getUserDoc(getUser.uID).documentID;

          if (id == null) {
            return OnBoardingScreen();
          } else {
            return LandingPage();
          }
        } else {
          return OnBoardingScreen();
        }
      }),
    );
  }
}
