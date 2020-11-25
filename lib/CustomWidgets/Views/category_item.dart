import 'package:flutter/material.dart';
import 'package:greamit_app/CustomWidgets/Texts.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {@required this.text,
      @required this.cateImage,
      @required this.onSelected,
      @required this.isSelected,
      @required this.notSelected,
      @required this.selected,
      Key key})
      : super(key: key);

  final String text;
  final String cateImage;
  final Function onSelected;
  final bool isSelected;
  final Color selected;
  final Color notSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                cateImage,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 180.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected
                    ? kPrimaryColor.withOpacity(0.5)
                    : Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NormalText(
                    text: text,
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
