import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomCompulsoryText.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomDropDownButton.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTextField.dart';
import 'package:greamit_app/Screens/PostAGream.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class PromotePost extends StatelessWidget {
  static final String id = 'promotePostId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0,
          left: 8.0),
          child: Text(
            'Back',
            style: TextStyle(color: kPrimaryColor,
            fontSize: 18.0),
          ),
        ),
        title: Text(
          'Promote Post',
          style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promotion Details',
                  style: TextStyle(color: Colors.black,
                  fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text('Promotions are calculated on a daily basis',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black26
                ),),
                SizedBox(height: 8.0),
                CustomCompulsoryText('Category'),
                CustomDropDownButton(
                  hintText: 'Select Category',
                  items: ['Food', 'Music',
                  'Politics', 'Technology'],
                ),
                SizedBox(height: 8.0),
                CustomCompulsoryText('Category'),
                CustomTextField(
                  hintText: 'Enter your budget',
                ),
                SizedBox(height: 8.0),
                CustomCompulsoryText('Duration'),
                CustomDropDownButton(
                  hintText: 'Select number of days',
                  items: ['5 Days', '2 Days'],
                ),

              ],
            ),
            ActionButton(
              title: 'Proceed',
              fillColor: Color(0XFFAAB2BA),
            )
          ],
        ),
      ),
    );
  }
}
