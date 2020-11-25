import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  CustomTag(this.title,{this.backgroundColor = const Color(0XFFAABAB2)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Text(title,
          style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
