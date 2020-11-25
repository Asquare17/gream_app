import 'package:flutter/material.dart';

class CustomPageViewIndicator extends StatelessWidget {
  final Color color;
  CustomPageViewIndicator(this.color);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 15.0),
      ],
    );
  }
}
