import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';

class ForgotPassword extends StatelessWidget {
  static final String id = 'forgotPasswordId';

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    String forgotPasswordText = 'Please enter your email address. You will '
        'receive a link to create a new password via email.';
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Forgot Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              SizedBox(height: 8.0),
              Text(
                forgotPasswordText,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 25.0),
              CustomTextField(
                hintText: 'Your email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 25.0),
              ActionButton(
                title: 'Send',
                fillColor: appTheme.primaryColor,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
