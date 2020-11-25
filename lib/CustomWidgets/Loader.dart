import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key key, this.opacity = 1.0, this.label = ''})
      : super(key: key);

  final double opacity;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(opacity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.brown,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
