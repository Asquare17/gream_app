import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greamit_app/Utilities/Constants.dart';

import 'CustomTextField.dart';

class CustomCompulsoryText extends StatelessWidget {

  final String text;
  CustomCompulsoryText(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
          style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: text),
              WidgetSpan(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0,
                        vertical: 10.0),
                    child: SvgPicture.asset('$kImagesFolder/star_vector.svg',
                      width: 6.0,
                      height: 6.0,)
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

}
