import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/ActionButton.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class BlockedList extends StatelessWidget {
  static final String id = 'blockedListId';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0),
          child: Text(
            'Back',
            style: TextStyle(color: kPrimaryColor, fontSize: 18.0),
          ),
        ),
        title: Text(
          'Blocked List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0,
        horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context,index){
                return CustomBlockedUser();
              }),
            ),
            ActionButton(title: 'Done',
            fillColor: kPrimaryColor,)
          ],
        ),
      ),
    );
  }

}

class  CustomBlockedUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0,
        horizontal: 16.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Roseline Maxwel',
          style: TextStyle(
            color: Colors.black
          ),),
          subtitle: Text('@rosiemax',
          style: TextStyle(color: Colors.black26),),
          trailing: Text('UNBLOCK',
          style: TextStyle(
            color: kPrimaryColor
          ),),
        ),
      ),
    );
  }
}
