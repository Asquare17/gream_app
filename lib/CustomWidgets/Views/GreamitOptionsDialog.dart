import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class GreamitPostOptions extends StatelessWidget {

  BuildContext context;
  Function copyAction;
  Function shareAction;
  Function reportAction;
  Function followAction;
  Function blockAction;
  bool isUser;
  String userModel;

  GreamitPostOptions({
    this.userModel,
    this.context,
    this.blockAction,
    this.copyAction,
    this.followAction,
    this.isUser,
    this.reportAction,
    this.shareAction,
  });

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.bottomCenter,
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    FlatButton.icon(onPressed: copyAction, icon: SvgPicture.asset('$kImagesFolder/link_icon.svg'), label: Text('Copy Link',
                      style: TextStyle(color: Colors.black54),)),

                    FlatButton.icon(onPressed: shareAction, icon: SvgPicture.asset('$kImagesFolder/share_icon.svg'), label: Text('Share gream',
                      style: TextStyle(color: Colors.black54),)),

                    FlatButton.icon(onPressed: reportAction, icon: SvgPicture.asset('$kImagesFolder/report_icon.svg'), label: Text('Report this gream',
                      style: TextStyle(color: Colors.black54),)),

                    FlatButton.icon(onPressed: followAction, icon: SvgPicture.asset('$kImagesFolder/follow_icon.svg'), label: Text('Follow',
                      style: TextStyle(color: Colors.black54),)),


                    // if(isUser) ... [
                    //
                    // ] else ... [
                    //
                    // ],

                    FlatButton.icon(onPressed: blockAction, icon: SvgPicture.asset('$kImagesFolder/block_icon.svg'), label: Text('Block @bitdbybits',
                      style: TextStyle(color: Colors.black54),)),

                  ],),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text('Cancel',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
