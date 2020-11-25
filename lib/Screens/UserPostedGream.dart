import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class UserPostedGream extends StatefulWidget {
  final String link;
  final Function onTap;

  UserPostedGream(this.link, this.onTap);

  @override
  _UserPostedGreamState createState() => _UserPostedGreamState();
}

class _UserPostedGreamState extends State<UserPostedGream> {
  Future _websiteDetailsFuture;
  final String baseUrl = 'http://url-metadata.herokuapp.com/api/metadata?url=';

  @override
  void initState() {
    super.initState();
    _websiteDetailsFuture = getWebsiteDetails();
  }

  Future getWebsiteDetails() async {
    http.Response _response =
        await http.get('$baseUrl' + 'https://${widget.link}');

    return jsonDecode(_response.body);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: _websiteDetailsFuture,
        builder: (context, websiteDetails) {
          if (websiteDetails.connectionState == ConnectionState.done) {
            if (websiteDetails.hasData && websiteDetails.data['data'] != null) {
              return postGreamByUserWidget(
                  deviceWidth,
                  websiteDetails.data['data']['image'],
                  websiteDetails.data['data']['title']);
            } else if (websiteDetails.data['data'] == null) {
              return Column(
                children: [
                  Text('Something went wrong'),
                  RaisedButton(
                    onPressed: () => _refresh(),
                    color: kPrimaryColor,
                    child: Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            } else {
              return Loader(opacity: 0.2);
            }
          } else {
            return Loader(opacity: 0.2);
          }
        });
  }

  Widget postGreamByUserWidget(double deviceWidth, String image, String title) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              child: image != null
                  ? Image.network(
                      image,
                      height: 230,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      '$kImagesFolder/random_img.png',
                      height: 230,
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black26),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 350.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: title != null
                        ? Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'No Description found',
                            style: TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _refresh() {
    setState(() {
      _websiteDetailsFuture = getWebsiteDetails();
    });
  }
}
