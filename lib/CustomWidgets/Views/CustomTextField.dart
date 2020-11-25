import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget suffixIcon;
  final bool isPasswordField;
  final bool isDateOfBirthField;
  final TextInputType keyboardType;
  final FocusNode currentNode;
  final int maxLines;
  final String initialValue;
  final Function(String value) onChanged;
  final int limit;

  final TextEditingController controller;
  CustomTextField(
      {this.hintText,
      this.controller,
      this.currentNode,
      this.maxLines = 1,
      this.suffixIcon,
      this.keyboardType = TextInputType.text,
      this.isDateOfBirthField = false,
      this.isPasswordField = false,
      this.initialValue,
      this.onChanged,
      this.limit});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;
  TextEditingController _controller = TextEditingController();

  changeFieldVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.isPasswordField) {
      obscureText = true;
    }
    if (widget.controller != null) {
      _controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: deviceWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(widget.limit),
          ],
          controller: widget.initialValue == null ? _controller : null,
          focusNode: widget.currentNode,
          keyboardType: widget.keyboardType,
          enableInteractiveSelection: widget.isDateOfBirthField ? false : true,
          obscureText: obscureText,
          maxLines: widget.maxLines,
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.grey[300],
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => changeFieldVisibility(),
                  )
                : widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}

class DisableFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class EnableFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}
