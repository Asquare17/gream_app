import 'package:flutter/material.dart';
import 'package:greamit_app/Utilities/size_config.dart';

class TitleText extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color textColor;
  final TextAlign textAlign;

  TitleText({@required this.text, this.fontSize, this.textColor, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      textAlign: textAlign != null ? textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.headline1
          .copyWith(
            fontSize: fontSize != null ? SizeConfig().sp(fontSize): 20,
            color: textColor != null ? textColor: Colors.black
          ),
    );
  }
}

class NormalText extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  NormalText({@required this.text, this.fontSize, this.textColor, this.fontWeight, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text,

      textAlign: textAlign != null ? textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyText1
          .copyWith(
          fontSize: fontSize != null ? SizeConfig().sp(fontSize): 15,
          color: textColor != null ? textColor: Colors.black,
          fontWeight: fontWeight != null ? fontWeight: FontWeight.w400
      ),
    );
  }
}

class AccentText extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color textColor;
  final TextAlign textAlign;

  AccentText({@required this.text, this.fontSize, this.textColor, this.textAlign});

  @override
  Widget build(BuildContext context) {

    return Text(text,
      textAlign: textAlign != null ? textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyText1
          .copyWith(
          fontSize: fontSize != null ? SizeConfig().sp(fontSize): 15,
          color: textColor != null ? textColor: Colors.black
      ),
    );
  }
}

