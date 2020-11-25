import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CompleteRegistrationScreen.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class EmailVerificationScreen extends StatelessWidget {
  static final String id = 'emailVerificationScreenId';
  final String emailVerificationText =
      'We sent an email to youremail@email.com. It has instructions'
      'on how to complete your account setup.';
  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              SvgPicture.asset('$kImagesFolder/email_icon.svg'),
              SizedBox(height: 25.0),
              Text(
                'Sent! Check your mail',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              Text(
                emailVerificationText,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.0),
              ActionButton(
                title: 'Go to mail',
                fillColor: appTheme.primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, CompleteRegistrationScreen.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
