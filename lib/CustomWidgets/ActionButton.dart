import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Color fillColor;
  final Function onPressed;
  ActionButton({
    this.title,
    this.onPressed,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: deviceWidth,
      height: 45.0,
      child: RaisedButton(
        color: fillColor,
        disabledColor: Color(0XFFAAB2BA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: onPressed,
        textColor: Colors.white,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
