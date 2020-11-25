import 'package:flutter/material.dart';
import 'package:greamit_app/Screens/LandingPageScreens/ExplorePage/CategoriesScreen.dart';
import 'package:greamit_app/Screens/LandingPageScreens/ExplorePage/PeopleScreen.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Scaffold(
            appBar: TabBar(
              indicatorColor: kPrimaryColor,
              tabs: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                  ),
                ),
                Text(
                  'People',
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                CategoriesScreen(),
                SuggestedPeople(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
