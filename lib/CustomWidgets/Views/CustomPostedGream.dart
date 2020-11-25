import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greamit_app/CustomWidgets/Loader.dart';
import 'package:greamit_app/CustomWidgets/Views/CustomTag.dart';
import 'package:greamit_app/Model/WebMetaData.dart';
import 'package:greamit_app/Screens/GreamDetailsPage.dart';
import 'package:greamit_app/Utilities/Constants.dart';
import 'package:greamit_app/Utilities/navigator.dart';
import 'package:greamit_app/Services/WebMetaDataRepo.dart';

class CustomPostedGream extends StatelessWidget {
  final String title;
  final String link;
  final String description;
  final String numberOfLikes;
  final String numberOfComments;
  final String postersName;
  final String postedTime;
  final String postersImage;
  final String greamLinkImage;
  final bool isLiked;
  final List<String> postCategories;
  Function likeGream;
  Function commentOnGream;
  Function reGream;
  Function onGreamitPostTap;

  CustomPostedGream(
      {this.title,
      this.link,
      this.description,
      this.numberOfLikes,
      this.numberOfComments,
      this.postersImage,
      this.postedTime,
      this.postCategories,
      this.greamLinkImage,
      this.postersName,
      this.likeGream,
      this.isLiked,
      this.commentOnGream,
      this.onGreamitPostTap,
      this.reGream});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return FutureBuilder<WebMetaData>(
        future: getWebsiteMetadata(websiteString: link),
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postersName,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        postedTime,
                        style: TextStyle(color: Colors.black45),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: onGreamitPostTap,
                  child: buildPostedGreamImage(
                      deviceWidth: MediaQuery.of(context).size.width,
                      categoryTag: postCategories,
                      image: snapshot.hasData != null && snapshot.data != null
                          ? snapshot.data.data.image
                          : null,
                      title: title)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      numberOfLikes + "  Likes",
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      numberOfComments + "  Comments",
                      style: TextStyle(color: Colors.black45),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: likeGream,
                      child: Row(
                        children: [
                          if (isLiked) ...[
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ] else ...[
                            Icon(
                              Icons.favorite_border,
                              color: Colors.black26,
                            ),
                          ],
                          SizedBox(width: 12.0),
                          Text(
                            'Like',
                            style: TextStyle(
                                color: Color(0XFF444444), fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: commentOnGream,
                      child: Row(
                        children: [
                          SvgPicture.asset('$kImagesFolder/comment_icon.svg'),
                          SizedBox(width: 12.0),
                          Text(
                            'Comment',
                            style: TextStyle(
                                color: Color(0XFF444444), fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('$kImagesFolder/send_icon.svg'),
                        SizedBox(width: 12.0),
                        Text(
                          'Share',
                          style: TextStyle(
                              color: Color(0XFF444444), fontSize: 16.0),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget buildPostedGreamImage(
      {double deviceWidth,
      String image,
      String title,
      List<String> categoryTag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          image != null
              ? Image.network(
                  image,
                  width: deviceWidth,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  '$kImagesFolder/random_img.png',
                  height: 230,
                  fit: BoxFit.contain,
                ),
          Container(
            height: 250.0,
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryTag.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CustomTag(
                          categoryTag[index],
                          backgroundColor: Colors.white.withOpacity(0.1),
                        );
                      }),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 18.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 350.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: title != null
                            ? Text(
                                title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300),
                              )
                            : Text(
                                'No Description found',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300),
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
