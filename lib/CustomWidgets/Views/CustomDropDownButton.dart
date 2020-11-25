import 'package:flutter/material.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final String selectedItem;
  final Function(String) onChanged;
  final EdgeInsets contentPadding;
  final Color textColor;
  final Color color;

  CustomDropDownButton({
    this.items,
    this.hintText,
    this.selectedItem,
    this.onChanged,
    this.color,
    this.textColor,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
  });
  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            color: widget.color ?? Colors.grey[300], borderRadius: BorderRadius.circular(50.0)),
        child: SizedBox(
          width: deviceWidth,
          /*To hide the default underline of DropdownButton*/
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text(widget.hintText, style: TextStyle(color: widget.textColor ?? Colors.black),),
              isExpanded: true,
              value: widget.selectedItem,
              onChanged: (dynamic value) {
                widget.onChanged(value);
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: FittedBox(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
