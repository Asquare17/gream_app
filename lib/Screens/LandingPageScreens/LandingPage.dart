import 'package:flutter/material.dart';
import 'package:greamit_app/Screens/LandingPageScreens/ExploreScreen.dart';
import 'package:greamit_app/Screens/LandingPageScreens/HomePage.dart';

import 'MyProfile.dart';

class LandingPage extends StatefulWidget {
  static final id = 'landingPageId';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  void onTap(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
          index: _currentIndex ,
          children: _listOfWidgets),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        onTap: onTap,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
      ),
    );
  }
}

List<BottomNavigationBarItem> _items = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
];

List<Widget> _listOfWidgets = [
  HomePage(),
  ExploreScreen(),
  MyProfile(),
];
