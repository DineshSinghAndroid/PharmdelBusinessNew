// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Function onPressed;
  final Color color1;
  final Color color2;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.width = double.infinity,
    this.height,
    this.color1,
    this.color2,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[color1, color2]), borderRadius: BorderRadius.circular(40), boxShadow: [
        BoxShadow(
          color: grey,
          offset: Offset(0.0, 4.5),
          blurRadius: 2.5,
        ),
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
