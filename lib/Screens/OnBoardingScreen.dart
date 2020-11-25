import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/CreateAccountScreen.dart';
import 'package:greamit_app/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';

enum IndicatorColor { FIRST, SECOND, THIRD }

class OnBoardingScreen extends StatefulWidget {
  static final String id = 'onBoardingScreenId';

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  IndicatorColor _indicatorColor = IndicatorColor.FIRST;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Image.asset(
                  '$kImagesFolder/greamit_logo.jpg',
                  width: 50.0,
                  height: 100.0,
                ),
              ),
              Expanded(
                child: PageView(
                  children: _pageViewChildren,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      switch (pageIndex) {
                        case 0:
                          _indicatorColor = IndicatorColor.FIRST;
                          break;
                        case 1:
                          _indicatorColor = IndicatorColor.SECOND;
                          break;
                        case 2:
                          _indicatorColor = IndicatorColor.THIRD;
                          break;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    /*Row to hold the Page View Indicators*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PageViewIndicator(
                            _indicatorColor == IndicatorColor.FIRST
                                ? appTheme.primaryColor
                                : Color(0XFFAAB2BA)),
                        PageViewIndicator(
                            _indicatorColor == IndicatorColor.SECOND
                                ? appTheme.primaryColor
                                : Color(0XFFAAB2BA)),
                        PageViewIndicator(
                            _indicatorColor == IndicatorColor.THIRD
                                ? appTheme.primaryColor
                                : Color(0XFFAAB2BA)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: ActionButton(
                        title: 'Create an account',
                        fillColor: appTheme.primaryColor,
                        onPressed: () {
                          navigate(context, CreateAccountScreen());
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigate(context, LoginScreen());
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            color: appTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> _pageViewChildren = [
  Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: SvgPicture.asset('$kImagesFolder/onboarding_image1.svg'),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Instant access to everything you want to know about.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0XFF262525), fontSize: 18.0),
          ),
        ),
      )
    ],
  ),
  Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: SvgPicture.asset('$kImagesFolder/onboarding_image2.svg'),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Share new content and access new content on the web.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0XFF262525), fontSize: 18.0),
          ),
        ),
      )
    ],
  ),
  Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: SvgPicture.asset('$kImagesFolder/onboarding_image3.svg'),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Collect information most valuable to you, anytime and anywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0XFF262525), fontSize: 18.0),
          ),
        ),
      )
    ],
  ),
];

class PageViewIndicator extends StatelessWidget {
  final Color color;
  PageViewIndicator(this.color);
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
