import 'package:flutter/material.dart';

void showSnackBar(
  GlobalKey<ScaffoldState> _scaffoldKey, {
  String message = 'An error occurred',
  String label = 'DISMISS',
  Function onPressed,
  int duration
}) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: Colors.pinkAccent,
    content: Text(
      message == null
          ? 'An error occurred'
          : message.isNotEmpty ? message : 'An error occurred',
      style: const TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontSize: 14,
      ),
    ),
    duration: Duration(seconds: duration ?? 5 ),
    action: SnackBarAction(
      label: label,
      textColor: Colors.white,
      onPressed: onPressed ?? () {},
    ),
  ));
}
