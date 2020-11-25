import 'package:flutter/material.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class SettingsPage extends StatelessWidget {
  static final String id = 'settingsId';

  @override
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
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('Email Address'),
                Text(
                  'judithlonge@',
                  style: TextStyle(color: Colors.black26),
                ),
                SizedBox(height: 18.0),
                Text('Language'),
                Text(
                  'English',
                  style: TextStyle(color: Colors.black26),
                ),
                SizedBox(height: 18.0),
                Text('Blocked list'),
                Text(
                  '4',
                  style: TextStyle(color: Colors.black26),
                ),
                SizedBox(height: 18.0),
                Text('Password'),
                Text(
                  '********',
                  style: TextStyle(color: Colors.black26),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    'Help',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 18.0),
                Text(
                  'Terms & Conditions',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 18.0),
                Text(
                  'FAQs',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 18.0),
                Text(
                  'About the app',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 18.0),
                Text(
                  'Report',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deactive Account'),
                  SizedBox(height: 18.0),
                  Text(
                    'Log Out',
                    style: TextStyle(color: kPrimaryColor),
                  )
                ],
              )),

        ],
      ),
    );
  }
}
